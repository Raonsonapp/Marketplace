# Deploying the TajikShop API to Hugging Face Spaces

A real, live backend for TajikShop — not just code sitting in this repo —
using the same free-hosting pattern as this account's other projects
(Hugging Face Spaces for compute, a managed Postgres, Cloudflare R2 for
object storage). Everything below is an external step you do once in your
own accounts; nothing here can be done from inside a coding sandbox.

## Reusing an existing Space (e.g. the one behind "Superior AI")

If you already have a Hugging Face Space with `DATABASE_URL`,
`SUPABASE_URL`, `CF_ACCOUNT_ID`, `CF_R2_ACCESS_KEY_ID`,
`CF_R2_SECRET_ACCESS_KEY`, `CF_R2_BUCKET`, and `CF_R2_PUBLIC_URL` already
set as secrets, TajikShop's config reads those exact names — nothing to
rename. You only need to:

1. Add two secrets it doesn't have yet: **`REDIS_URL`** (see §2 below —
   Upstash's free tier) and **`JWT_SECRET`** (any long random string,
   e.g. `openssl rand -base64 48`).
2. Replace that Space's root `Dockerfile` and `README.md` with
   `infrastructure/huggingface/Dockerfile` and
   `infrastructure/huggingface/README.md` from this repo (they build
   TajikShop's `services/api` instead of whatever was there before).
   Clone the Space's own git repo, copy the two files in, commit, push.
3. Leftover secrets from the previous app (`BOT_TOKEN`, `HF_TOKEN`,
   `AI_MODEL`, ...) are simply unused by TajikShop — harmless to leave, or
   delete them if you'd rather tidy up.
4. Push. The Space rebuilds, runs every DB migration automatically on
   first boot, and starts serving. Check
   `https://<you>-<space-name>.hf.space/healthz` for
   `{"database":"ok","redis":"ok"}`.

The rest of this document is the from-scratch walkthrough if you're
setting up a new Space instead.

## 1. Managed Postgres (required)

Any managed Postgres works; **Supabase** is what this account already uses
elsewhere and has a free tier:

1. Create a project at [supabase.com](https://supabase.com).
2. Project Settings → Database → copy the **connection string** (URI,
   "Session pooler" or "Direct connection" both work). It looks like:
   `postgres://postgres:<password>@<host>:5432/postgres`.
3. That whole string is your `DATABASE_URL` secret (step 4). The backend
   applies every migration automatically on first boot
   (`internal/db/migrate.go`) — you do not need to run anything by hand.

## 2. Managed Redis (required)

Redis backs OTP rate limiting and checkout idempotency
(`docs/SECURITY.md`). [Upstash](https://upstash.com) has a free tier and
issues a TLS connection string (`rediss://...`) that works as-is —
`internal/db/redis.go` uses `redis.ParseURL`, which supports both
`redis://` and `rediss://`.

## 3. Cloudflare R2 (optional — only for image uploads)

Powers `POST /api/v1/uploads/presign` (review photos, support-chat
attachments). Skip this section if you don't need uploads yet; that
endpoint just returns `UPLOADS_NOT_CONFIGURED` until it's set up.

1. Cloudflare dashboard → R2 → create a bucket (e.g. `tajikshop-media`) →
   note it as `CF_R2_BUCKET`.
2. Cloudflare dashboard → top-right account menu → note your **Account
   ID** as `CF_ACCOUNT_ID` (the R2 S3 API endpoint,
   `https://<account>.r2.cloudflarestorage.com`, is derived from this —
   you don't set the endpoint directly).
3. R2 → Manage API tokens → create a token with read/write access to that
   bucket → note the **Access Key ID** (`CF_R2_ACCESS_KEY_ID`) and
   **Secret Access Key** (`CF_R2_SECRET_ACCESS_KEY`).
4. R2 → bucket → Settings → enable public access (or attach a custom
   domain) → note that base URL as `CF_R2_PUBLIC_URL`
   (`https://<id>.r2.dev` or your domain).

## 4. Create the Hugging Face Space

1. [huggingface.co/new-space](https://huggingface.co/new-space) → SDK:
   **Docker** → visibility your choice.
2. Push `infrastructure/huggingface/Dockerfile` and
   `infrastructure/huggingface/README.md` from this repo as the **root**
   files of the new Space's own git repo (`git remote add space
   https://huggingface.co/spaces/<you>/<space-name>`, copy those two files
   in, commit, `git push space main`). The Dockerfile clones this public
   repo (`Raonsonapp/Marketplace`) at build time and builds
   `services/api` — see that file's header comment for why, and how to
   force a fresh clone on redeploy (Settings → Factory rebuild).
3. Space → Settings → **Variables and secrets** → add as secrets (never as
   plain "Variables", which are visible in the UI):
   - `DATABASE_URL` (step 1)
   - `REDIS_URL` (step 2)
   - `JWT_SECRET` — a long random string (`openssl rand -base64 48`)
   - `TELEGRAM_GATEWAY_TOKEN` (recommended — see `docs/SMS_PROVIDERS.md`)
     and/or `FIREBASE_WEB_API_KEY` (see `docs/FIREBASE_SETUP.md`)
   - `CF_ACCOUNT_ID`, `CF_R2_ACCESS_KEY_ID`, `CF_R2_SECRET_ACCESS_KEY`,
     `CF_R2_BUCKET`, `CF_R2_PUBLIC_URL` (step 3, optional)
   - `CORS_ORIGINS` — your admin web origin(s), comma-separated
4. The Space builds and starts automatically. Check
   `https://<you>-<space-name>.hf.space/healthz` — `{"database":"ok","redis":"ok"}`
   means everything connected.

## 5. Point the mobile app at it

Build/run with the Space's URL instead of the emulator loopback:

```bash
flutter run --dart-define=API_BASE_URL=https://<you>-<space-name>.hf.space/api/v1
```

For a release build, bake this into the CI workflow or a build flavor
rather than typing it by hand each time (see `docs/DEPLOYMENT.md`).

## 6. Redeploying after new commits — automatic

HF caches Docker layers, so a plain restart would reuse the stale
`git clone` layer from a previous build instead of picking up new commits.
`.github/workflows/deploy-huggingface.yml` handles this automatically:
on every push to `main` that touches `services/api/**` or
`infrastructure/huggingface/**`, it calls Hugging Face's REST API to
trigger a **factory** rebuild (no cache) — https://huggingface.co/docs/hub/en/spaces-config-reference
— which forces a fresh `git clone` of the latest commit. Nothing needs to
be pushed to the Space's own git repo for this to work; it only needs to
exist once (§4 above).

Setup (one-time):
1. Create a Hugging Face access token with **write** access to the Space:
   [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens)
   → "New token" → role **Write** (a fine-grained token needs the
   "Manage Spaces" permission specifically — a read-only token gets a 403).
2. In this GitHub repo: Settings → Secrets and variables → Actions → **New
   repository secret** → name `HF_TOKEN`, value the token from step 1.
3. If your Space lives somewhere other than `Mahmadmurodov/YouShop`, edit
   the `HF_SPACE` value at the top of
   `.github/workflows/deploy-huggingface.yml` to match
   (`<owner>/<space-name>` from the Space's URL).

From then on, every backend change that reaches `main` redeploys the live
server within a few minutes — no manual "Factory rebuild" click needed.
You can also trigger it by hand from GitHub: Actions → "Deploy to Hugging
Face Spaces" → Run workflow.

## Known limits of this setup

- Hugging Face Spaces sleep after inactivity on the free tier — the first
  request after a sleep has extra latency while it wakes up. Fine for
  development/testing; for a production launch, prefer a
  container platform with no cold-start sleep (see `docs/DEPLOYMENT.md`'s
  staging/production environment table).
- This Dockerfile always builds the current `main` branch of
  `Raonsonapp/Marketplace` — there is no per-Space version pinning. If you
  need to test a branch before merging, temporarily point the `git clone`
  line at that branch (`-b <branch>`), then revert it.
