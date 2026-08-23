# Deploying the TajikShop API to Hugging Face Spaces

A real, live backend for TajikShop — not just code sitting in this repo —
using the same free-hosting pattern as this account's other projects
(Hugging Face Spaces for compute, a managed Postgres, Cloudflare R2 for
object storage). Everything below is an external step you do once in your
own accounts; nothing here can be done from inside a coding sandbox.

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

1. Cloudflare dashboard → R2 → create a bucket (e.g. `tajikshop-media`).
2. R2 → Manage API tokens → create a token with read/write access to that
   bucket. Note the **Access Key ID**, **Secret Access Key**, and the
   account's R2 **S3 API endpoint**
   (`https://<accountid>.r2.cloudflarestorage.com`).
3. R2 → bucket → Settings → enable public access (or attach a custom
   domain) to get a public base URL (`https://<id>.r2.dev` or your domain).

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
   - `R2_ENDPOINT`, `R2_ACCESS_KEY`, `R2_SECRET_KEY`, `R2_BUCKET`,
     `R2_PUBLIC_URL` (step 3, optional)
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

## 6. Redeploying after new commits

HF caches Docker layers, so a plain restart can reuse the stale
`git clone` layer from the first build. Use **Settings → Factory rebuild**
to force a clean rebuild that picks up the latest commit on
`Raonsonapp/Marketplace`.

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
