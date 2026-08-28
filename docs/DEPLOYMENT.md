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
- Release build: `.github/workflows/android-release.yml` builds
  `flutter build appbundle --release` and `flutter build apk --release`
  (never a debug build) on every push to `main` touching the mobile app, on
  `v*` tags, and on demand (`workflow_dispatch`). R8/ProGuard minification
  and resource shrinking are enabled in `android/app/build.gradle.kts`
  (`isMinifyEnabled`/`isShrinkResources`, rules in
  `android/app/proguard-rules.pro`).
- **Real signing, not the debug keystore**: `android/app/build.gradle.kts`
  reads `android/key.properties` (never committed — see `android/.gitignore`)
  for the release `signingConfig`. Two ways to provide it:
  - **Generate the key** (once, ever) with the helper script, which creates
    the keystore and prints the four secret values ready to paste:
    ```
    ./scripts/make-upload-keystore.sh                                     # macOS/Linux
    powershell -ExecutionPolicy Bypass -File scripts\make-upload-keystore.ps1   # Windows
    ```
    It refuses to overwrite an existing keystore, reads the password without
    echoing it, and writes a PKCS12 store with a ~27-year validity (a key
    that expires makes the Play listing un-updatable). **Back the `.jks` up
    somewhere you will still have in five years**: Google Play binds the app
    to this key permanently, so losing it means never shipping an update to
    that listing again — only a brand-new listing with no installs.
  - **CI**: set the repository secrets the script prints —
    `ANDROID_KEYSTORE_BASE64` (the keystore file, base64-encoded on a single
    line), `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`,
    `ANDROID_KEY_PASSWORD` — under **Settings → Secrets and variables →
    Actions → New repository secret**. The workflow decodes the keystore and
    writes `key.properties` itself before building.
  - **Locally** (optional, for a signed build on your own machine): create
    `apps/mobile/android/key.properties` pointing at the same keystore:
    ```
    storeFile=/absolute/path/to/upload-keystore.jks
    storePassword=...
    keyAlias=upload
    keyPassword=...
    ```
  - If neither is present, the release build type **falls back to the debug
    keystore and logs a loud warning** (both in Gradle's own output and as a
    GitHub Actions `::warning::`) so an unsigned-for-Play build is never
    mistaken for a real one — it still builds successfully for local
    smoke-testing.
- Requested permissions are added only as each feature ships and are
  documented with their exact trigger in `docs/GOOGLE_PLAY_DATA_SAFETY.md`:
  `INTERNET` always; `CAMERA` only when the barcode scanner opens;
  `ACCESS_FINE_LOCATION`/`ACCESS_COARSE_LOCATION` only when the user opens
  "nearby stores" or taps "use my location" (manual address entry always
  remains available without granting it); `POST_NOTIFICATIONS` once FCM
  push is used. No contacts/SMS/microphone/background-location permissions.
