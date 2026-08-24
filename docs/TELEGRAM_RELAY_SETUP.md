# Telegram Relay Setup (fixing "TLS handshake timeout" on Hugging Face Spaces)

## When you need this

The backend log shows OTP sends failing like this, on every attempt, for
every phone number, no matter how long the timeout is set to:

```
otp: telegram gateway request failed: Post "https://gatewayapi.telegram.org/sendVerificationMessage": net/http: TLS handshake timeout
```

This means the host running the backend (Hugging Face Spaces, in this
project's case) cannot open a TLS connection to Telegram's servers at all —
it's a network-level block on that host's outbound traffic to Telegram,
not slowness. Raising `http.Client` timeouts cannot fix a connection that
never completes; the fix is to send the request from somewhere that *can*
reach Telegram, and have that place hand the result back to the backend.

Cloudflare's edge network reaches Telegram fine, and this project already
uses Cloudflare (R2 storage), so a tiny Cloudflare Worker is the relay:
the backend calls the Worker instead of `gatewayapi.telegram.org`
directly; the Worker forwards the request to Telegram and returns
Telegram's response unchanged. No backend logic changes — same request,
same code generation/hashing/verification in `OTPManager`, just one extra
hop that happens to succeed where a direct connection doesn't.

This whole setup is free (Cloudflare Workers free tier: 100,000
requests/day — nowhere close to what OTP sends need) and takes about five
minutes, entirely in the Cloudflare dashboard, no command line required.

## Steps

### 1. Create the Worker

1. Go to <https://dash.cloudflare.com>, sign in (the same account used for
   R2 — no new account needed).
2. Left sidebar → **Workers & Pages** → **Create** → **Create Worker**.
3. Give it any name (e.g. `youshop-telegram-relay`) → **Deploy** (this
   deploys Cloudflare's default "Hello World" template first — that's
   fine, it gets replaced next).
4. Click **Edit code** to open the online editor.
5. Delete everything in the editor and paste the full contents of
   [`infrastructure/cloudflare-worker/telegram-relay.js`](../infrastructure/cloudflare-worker/telegram-relay.js)
   from this repo.
6. Click **Deploy** (top right).

### 2. Set the relay secret

This stops anyone else who discovers the Worker's URL from using it to
send arbitrary requests to Telegram on your account's behalf.

1. On the Worker's page → **Settings** → **Variables and Secrets**.
2. **Add** → type: **Secret**, name: `RELAY_SECRET`, value: any long
   random string (e.g. generate one with `openssl rand -hex 32`, or just
   mash the keyboard for 40+ characters — it only needs to be unguessable).
3. **Save and deploy**.

### 3. Copy the Worker's URL

On the Worker's page, the URL is shown near the top — it looks like
`https://youshop-telegram-relay.<your-subdomain>.workers.dev`.

### 4. Configure the backend

Add two secrets to the Hugging Face Space (same place `DATABASE_URL`,
`JWT_SECRET`, etc. are already set):

| Secret | Value |
|---|---|
| `TELEGRAM_GATEWAY_PROXY_URL` | the Worker URL from step 3 (no trailing slash) |
| `TELEGRAM_GATEWAY_PROXY_SECRET` | the same value you set as `RELAY_SECRET` in step 2 |

Restart/redeploy the Space. The boot log should now show:

```
otp: delivering codes via Telegram Gateway (relayed through https://youshop-telegram-relay.<...>.workers.dev)
```

Send a test OTP — it should now succeed instead of timing out.

## Reverting

If Telegram ever becomes directly reachable from the backend's host again
(or the backend moves to different hosting), just remove
`TELEGRAM_GATEWAY_PROXY_URL` and `TELEGRAM_GATEWAY_PROXY_SECRET` — the
backend falls back to calling `gatewayapi.telegram.org` directly, no code
changes needed either way.
