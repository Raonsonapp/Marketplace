# TajikShop — Deployment Architecture (Phase 1)

## Local development

`infrastructure/deployment/docker-compose.yml` brings up:
- `postgres` (15) — primary database, migrations applied on `api` startup.
- `redis` (7) — OTP throttling/cache/refresh-token bookkeeping.
- `minio` — S3-compatible object storage standing in for Cloudflare R2/
  Supabase Storage in dev (same `object storage` interface, different
  endpoint/credentials via env).
- `api` — the Go backend, built from `infrastructure/docker/api.Dockerfile`.

Flutter runs against `http://10.0.2.2:8080` (Android emulator loopback) or a
LAN IP for a physical device, configured via `--dart-define=API_BASE_URL=...`
(see `apps/mobile/lib/core/config`).

## Environments

| Env | Purpose | Notes |
|---|---|---|
| `local` | Developer machines | docker-compose, seeded data, console-log OTP sender |
| `staging` | Pre-prod validation | Managed Postgres/Redis, real FCM, real SMS provider (sandboxed) |
| `production` | Live | Managed Postgres (HA) + Redis, R2, FCM, real SMS provider, behind TLS-terminating LB |

## CI/CD (GitHub Actions, `.github/workflows/`)

- `mobile-ci.yml`: `flutter pub get` → `flutter analyze` → `flutter test` on
  every PR touching `apps/mobile/**`.
- `backend-ci.yml`: `go vet ./...` → `go build ./...` → `go test ./...`
  against an ephemeral Postgres/Redis service container, migrations run from
  an empty database, on every PR touching `services/api/**`.
- `android-release.yml`: on a `v*` tag, builds a signed AAB + APK using
  secrets injected as GitHub Actions secrets (never committed) and uploads
  them as build artifacts.

## Configuration & secrets

- Every required variable is documented (with a placeholder, never a real
  value) in `infrastructure/deployment/.env.example`.
- Backend loads config via environment variables only (12-factor) —
  `internal/config`.
- Signing keys (JWT RS256 keypair, Android keystore) are generated per
  environment and injected at deploy time / via CI secrets — never committed.

## Scaling notes (Section 29)

- Stateless API pods behind a load balancer; horizontal scaling is safe
  because sessions live in Postgres/Redis, not in-process.
- Redis caches hot reads (home feed, category tree, product detail) with
  short TTL + explicit invalidation on admin writes.
- Postgres connection pooling via `pgxpool`; read-heavy endpoints use
  covering indexes defined in the migration (see DATABASE_SCHEMA.md).
- All list endpoints are cursor-paginated; the mobile app never requests
  more than one page of products at a time.
- Background jobs (bonus expiry sweep, notification fan-out, delivery slot
  cleanup) run as a separate worker process reading from a Postgres-backed
  or Redis-backed queue, so they never block request latency.

## Android / Google Play (Phase 9)

- Package name: `tj.tajikshop.app`.
- Release build: `flutter build appbundle --release` with R8/ProGuard
  minification enabled (`android/app/build.gradle`), signed with a release
  keystore supplied via CI secrets (`ANDROID_KEYSTORE_BASE64`,
  `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`).
- Requested permissions kept to the minimum actually used at each phase:
  `INTERNET` always; `CAMERA` only once the barcode scanner ships;
  `POST_NOTIFICATIONS` once FCM ships. No location/contacts/SMS/microphone
  permissions — delivery address is entered manually, not derived from
  device GPS, in the initial release.
