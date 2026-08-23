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

1. Add one secret it doesn't have yet: **`JWT_SECRET`** (any long random
   string, e.g. `openssl rand -base64 48`). `REDIS_URL` is optional (§2) —
   skip it if you don't have a spare free-tier Redis database; the backend
   falls back to an in-process in-memory one automatically.
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
2. Project Settings → Database → Connection string → **use the "Session
   pooler" tab, not "Direct connection".** Supabase's direct-connection
   hostname (`db.<ref>.supabase.co`) is IPv6-only; Hugging Face Spaces
   containers have no IPv6 egress, so a direct-connection URL fails with a
   DNS lookup error at startup ("no such host"). The Session pooler
   hostname (`aws-0-<region>.pooler.supabase.com`, port `5432`) is
   IPv4-reachable and works as a drop-in `DATABASE_URL`.
3. That whole string is your `DATABASE_URL` secret (step 4). The backend
   applies every migration automatically on first boot
   (`internal/db/migrate.go`) — you do not need to run anything by hand.

## 2. Managed Redis (optional)

Redis backs OTP rate limiting and checkout idempotency
(`docs/SECURITY.md`). **If you already have a free-tier Redis database
(e.g. one Upstash database used by another project), reuse it** — set its
connection string as `REDIS_URL` here too. TajikShop namespaces every key
it touches (`otp:`, `ratelimit:`, `idempotency:`, ...), so sharing one
Redis instance across unrelated apps is safe.

If you don't have one and don't want to create one, **leave `REDIS_URL`
unset** — `internal/db/redis.go`'s `ConnectRedis` then starts an
in-process, in-memory Redis-compatible server (`miniredis`) automatically,
and everything works with zero external setup. The trade-off: that data
(rate-limit counters, OTP cooldowns, the idempotency cache) lives only in
that one container's memory — it's wiped on every restart/redeploy and
isn't shared if you ever run more than one instance. Fine for
development, a small single-instance deployment, or getting started
before scale justifies a real Redis; add a real `REDIS_URL` later with no
code changes needed when it does.

If you do want a real one: [Upstash](https://upstash.com) has a free tier
and issues a TLS connection string (`rediss://...`) that works as-is —
`redis.ParseURL` supports both `redis://` and `rediss://`. (Upstash's free
tier caps you at one database — if you've already used it elsewhere,
reuse that one rather than trying to create a second.)

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
   files of the new Space's own git repo, once, to get it building at all
   (`git remote add space https://huggingface.co/spaces/<you>/<space-name>`,
   copy those two files in, commit, `git push space main`) — or just do the
   one-time `HF_TOKEN` setup in §6 below first and let the CI job create
   that initial push for you by running it once
   (Actions → "Deploy to Hugging Face Spaces" → Run workflow). Either way,
   **after that, don't hand-edit the Dockerfile on huggingface.co** — every
   automated deploy overwrites it; edit `infrastructure/huggingface/Dockerfile`
   in this repo instead (see §6, and that file's own header comment for why
   editing it in place would just get reverted on the next push).
3. Space → Settings → **Variables and secrets** → add as secrets (never as
   plain "Variables", which are visible in the UI):
   - `DATABASE_URL` (step 1)
   - `REDIS_URL` (step 2, optional — omit to use the automatic in-memory
     fallback)
   - `JWT_SECRET` — a long random string (`openssl rand -base64 48`)
   - `TELEGRAM_BOT_TOKEN` + `TELEGRAM_BOT_USERNAME` if you already have a
     Telegram bot (fastest to set up), or `TELEGRAM_GATEWAY_TOKEN` if you'd
     rather apply for Telegram Gateway instead (no bot-linking step for
     users, but a separate signup) — see `docs/SMS_PROVIDERS.md` for the
     trade-off. `TELEGRAM_BOT_TOKEN` wins if both are set. Either is
     optional alongside `FIREBASE_WEB_API_KEY` (see `docs/FIREBASE_SETUP.md`)
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

`.github/workflows/deploy-huggingface.yml` owns the Space's Dockerfile
from here on: on every push to `main` that touches `services/api/**` or
`infrastructure/huggingface/**`, it takes
`infrastructure/huggingface/Dockerfile`, bakes the current commit's SHA
into its `ARG SOURCE_COMMIT` line, and `git push -f`'s that file plus
`README.md` straight to the Space's own git repo. That accomplishes two
things at once: the Space always has the current Dockerfile (no more
manually copy-pasting it on huggingface.co and forgetting to update it —
that's exactly what caused a stale-Go-version build failure the first
time this was set up by hand), and because the `ARG SOURCE_COMMIT` line's
text is different on every deploy, Docker can't reuse its cached
`git clone` layer from a previous build — it always fetches the latest
commit. A plain HF restart (or a manual "Factory rebuild") is no longer
needed for routine deploys.

Setup (one-time):
1. Create a Hugging Face access token with **write** access to the Space:
   [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens)
   → "New token" → role **Write** (a fine-grained token needs the
   "Manage Spaces" permission specifically — a read-only token gets a 403
   when the workflow tries to push).
2. In this GitHub repo: Settings → Secrets and variables → Actions → **New
   repository secret** → name `HF_TOKEN`, value the token from step 1.
3. If your Space lives somewhere other than `Mahmadmurodov/YouShop`, edit
   the `HF_SPACE` value at the top of
   `.github/workflows/deploy-huggingface.yml` to match
   (`<owner>/<space-name>` from the Space's URL).

From then on, every backend change that reaches `main` redeploys the live
server within a few minutes. You can also trigger it by hand from GitHub:
Actions → "Deploy to Hugging Face Spaces" → Run workflow — useful the very
first time, to push the Dockerfile/README to a brand-new Space instead of
copy-pasting them by hand.

## TajikShop lives in its own Postgres schema, not "public"

Every TajikShop table is created in a dedicated `tajikshop` schema
(`internal/db/migrate.go`'s `AppSchema`), not Postgres's default `public`
schema — `RunMigrations` creates that schema on first boot if it doesn't
exist, and both the migration connection and the app's connection pool set
`search_path=tajikshop` so every unqualified table name in the codebase
resolves there automatically, no per-query changes needed.

This matters specifically because §1 of this doc explicitly supports
reusing one existing Supabase project across more than one app — and
`public` is exactly where an unrelated app's own tables would already
live. That's not hypothetical: it's what caused a real failure — a
pre-existing `public.users`/`public.categories` pair (from something other
than this app) happened to share TajikShop's table names but not their
columns, so migrations reported `relation "users" already exists` and, once
that was worked around, the app itself failed with
`column "name_tj" does not exist`. Giving TajikShop its own schema makes
that whole class of collision impossible regardless of what else is in the
same database — nothing in `public` is ever read, written, or touched.

If you hit either of those errors on an older deployment, no manual fix is
needed: redeploy with the current code and it creates and populates the
`tajikshop` schema fresh on next boot. Any stray `public.schema_migrations`
row from an earlier manual "force version" workaround is harmless and can
be ignored or dropped — it's not read by this schema-scoped setup.

## Prepared-statement errors through a pooled connection

If the container logs ever show `prepared statement "stmtcache_..." already
exists (SQLSTATE 42P05)`, or a migration fails with `relation "..." already
exists` right after that, it's a known pgx-vs-pooler interaction: pgx names
its prepared statements deterministically by SQL hash, and a pooler
(Supabase's Session/Transaction pooler, PgBouncer, Supavisor, ...) can hand a
reconnecting client a backend connection that still has a same-named
statement left over from a previous, abruptly-terminated container instance
— the name collides. Both `internal/db/postgres.go` (the app's pool) and
`internal/db/migrate.go` (the migration runner) already force
`default_query_exec_mode=simple_protocol`, which never names or caches a
prepared statement, so this shouldn't happen going forward. The
`relation "..." already exists` symptom means an *earlier* crash already got
far enough to run the CREATE TABLE statements before hitting this bug, so
the schema is half-applied without `schema_migrations` recording it — if you
hit that on a fresh project with no real data yet, reset it once from
Supabase's SQL Editor (`DROP SCHEMA public CASCADE; CREATE SCHEMA public;`)
and let the next boot re-run every migration cleanly.

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
