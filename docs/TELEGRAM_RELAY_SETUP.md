# Telegram Relay Setup (when Telegram is unreachable from the backend's host)

## When you need this

The backend log shows OTP sends failing like this, on every attempt, for
every phone number, no matter how long the timeout is set to:

```
otp: telegram gateway request failed: Post "https://gatewayapi.telegram.org/sendVerificationMessage": net/http: TLS handshake timeout
```

This means the host running the backend (Hugging Face Spaces, in this
project's case) cannot open a TLS connection to Telegram's servers at all —
it's a network-level block on that host's outbound traffic, not slowness.
Raising `http.Client` timeouts cannot fix a connection that never
completes; the fix is to send the request from somewhere that *can* reach
Telegram, and have that place hand the result back to the backend.

**A Cloudflare Worker was tried first and does not work for this**:
`gatewayapi.telegram.org`/`api.telegram.org` failed as expected, but so did
plain requests to `www.cloudflare.com` and `discord.com` — hosts with
nothing to do with Telegram, chosen only because they're served from
Cloudflare's shared edge network. That means the block isn't
Telegram-specific; it's Cloudflare's entire network, so no Cloudflare
Worker (custom domain or not) can ever reach it from that host. If you're
diagnosing a *different* deployment and want to check this yourself before
picking a relay host, add a temporary route that GETs a handful of external
hosts and compares which succeed — that's exactly what ruled Cloudflare out
here.

Google's network was not blocked (`google.com`, `script.google.com` both
succeeded fast), so the relay lives on **Google Apps Script** instead:
completely free, no billing account required (unlike Firebase Phone Auth,
which needs the Blaze plan even for free-tier usage), deployed entirely
from `script.google.com` with nothing but a Google account — no command
line.

## Steps

### 1. Create the Apps Script project

1. Go to <https://script.google.com>, sign in with any Google account.
2. **New project**.
3. Delete the placeholder `Code.gs` contents and paste the full contents of
   [`infrastructure/google-apps-script/telegram-relay.gs`](../infrastructure/google-apps-script/telegram-relay.gs)
   from this repo.
4. Rename the project (top left, "Untitled project") to something like
   `youshop-telegram-relay` — cosmetic only.

### 2. Set the script properties

These are Apps Script's equivalent of secrets — not visible to anyone the
project isn't shared with, not exposed to callers.

1. Click the gear icon (**Project Settings**) in the left sidebar.
2. Scroll to **Script Properties** → **Add script property**.
3. Add two properties:
   - `RELAY_SECRET` = any long random string you make up (e.g.
     `openssl rand -hex 32`, or just mash the keyboard for 40+ characters —
     it only needs to be unguessable).
   - `TELEGRAM_GATEWAY_TOKEN` = the same Telegram Gateway token already set
     as `TELEGRAM_GATEWAY_TOKEN` on the backend (copy it from wherever the
     backend's secrets are configured, e.g. Hugging Face Space secrets).
4. **Save**.

### 3. Deploy as a Web App

1. Back in the editor, **Deploy** (top right) → **New deployment**.
2. Click the gear icon next to "Select type" → **Web app**.
3. Settings: **Execute as: Me**, **Who has access: Anyone**.
4. **Deploy**. Google will ask you to authorize the script (it's calling an
   external URL via `UrlFetchApp`) — review and allow it.
5. Copy the **Web app URL** shown (ends in `/exec`).

### 4. Configure the backend

Add two secrets to the Hugging Face Space (same place `DATABASE_URL`,
`JWT_SECRET`, etc. are already set):

| Secret | Value |
|---|---|
| `TELEGRAM_GATEWAY_PROXY_URL` | the Web App URL from step 3.5 |
| `TELEGRAM_GATEWAY_PROXY_SECRET` | the same value you set as `RELAY_SECRET` in step 2 |

Restart/redeploy the Space. The boot log should now show:

```
otp: delivering codes via Telegram Gateway (relayed through https://script.google.com/macros/s/.../exec)
```

Send a test OTP — it should now succeed instead of timing out.

### If you change the script later

Apps Script Web App URLs stay the same across re-deployments **only** if
you edit the existing deployment (**Deploy → Manage deployments → edit
(pencil icon) → New version → Deploy**) rather than creating a fresh one.
Creating a brand new deployment gives a new URL, which would need updating
in the backend's `TELEGRAM_GATEWAY_PROXY_URL` secret too.

## Optional: owner alerts (new seller applications & support messages)

The same relay can also deliver the owner's operational alerts — a Telegram
message to you whenever a customer opens a "become a seller" application or
sends a support-chat message — so you can run the shop without an admin
panel or a paid email service. This is off until you configure it.

1. **Your bot** — you need the Telegram bot from `@BotFather` whose token is
   `TELEGRAM_BOT_TOKEN` (the app's is `VerificationYouShopBot`). In the Apps
   Script project's **Script Properties**, add one more property:
   `TELEGRAM_BOT_TOKEN` = that bot token.
2. **Your chat id** — open that bot in Telegram and press **Start** (or send
   it any message), then message `@userinfobot`, which replies with your
   numeric id. (That number is your chat id.)
3. **Backend** — set the secret `TELEGRAM_ADMIN_CHAT_ID` to that number.
   Nothing else — the alerts reuse the `TELEGRAM_GATEWAY_PROXY_URL`/
   `TELEGRAM_GATEWAY_PROXY_SECRET` you already set for OTP.

On boot the log shows `notify: owner alerts ... enabled for chat <id>`, and
from then on new seller applications and new support messages arrive in your
Telegram. Leave `TELEGRAM_ADMIN_CHAT_ID` unset to keep alerts off.

## Reverting

If Telegram (or Google) ever becomes unreachable and something else needs
to change, or the backend moves to different hosting with normal outbound
access, just remove `TELEGRAM_GATEWAY_PROXY_URL` and
`TELEGRAM_GATEWAY_PROXY_SECRET` — the backend falls back to calling
`gatewayapi.telegram.org` directly, no code changes needed either way.
