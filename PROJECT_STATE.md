# TajikShop — Project State

Live tracker for the multi-phase build described in `docs/ARCHITECTURE.md`.
Update this file whenever a phase/feature status changes.

## Current phase

**Phases 1–3 and 5 complete and verified**; Phase 5 (promotions, reviews,
notifications, support chat) landed on both backend and mobile and is
merged to `main`. Android Release Build CI is now green end-to-end and has
produced a real, installable APK/AAB (`.github/workflows/android-release.yml`,
run #8, https://github.com/Raonsonapp/Marketplace/actions/runs/32635164211)
— see "CI-verified" below for the two real bugs that had to be fixed to get
there. Next up: Phase 4 (run mobile + backend together live in a real
Android environment), Phase 6 (admin panel), Phase 7 (fuller test suite),
Phase 9 (real signing key + Play submission).

## CI-verified (this is the first time the Android build has actually run green)

- [x] `android-release.yml` parse bug: GitHub Actions rejects the `secrets`
      context referenced directly inside a step's `if:` ("Unrecognized
      named-value: 'secrets'") — a hard parse-time failure, so literally
      every run of this workflow failed with zero jobs from the moment it
      was introduced until this was found and fixed. Fix: mirror the four
      `ANDROID_KEYSTORE_*` secrets into job-level `env:` and check `env.*`
      in step `if:` conditions instead (the documented, supported pattern).
- [x] `flutter_secure_storage`'s AAR metadata requires compiling against
      Android SDK 37+; `android/app/build.gradle.kts` was compiling against
      `flutter.compileSdkVersion` (36 on the bundled Flutter stable),
      failing `:app:checkReleaseAarMetadata`. Fixed by pinning
      `compileSdk = 37` explicitly.
- [x] Confirmed live in GitHub Actions (not just locally): `flutter build
      appbundle --release` and `flutter build apk --release` both succeed;
      the `tajikshop-android-release` artifact (AAB + APK, ~109 MB) is
      attached to the run. This build is signed with the **debug**
      keystore (no `ANDROID_KEYSTORE_BASE64` secret is set yet — the
      workflow warns about this loudly, as designed) — installable for
      testing right now, but not Play-Store-uploadable until a real
      upload keystore is configured per `docs/DEPLOYMENT.md`.
- [x] Real device testing surfaced two more bugs, both fixed and shipped in
      run #9 (https://github.com/Raonsonapp/Marketplace/actions/runs/32637027965):
      `Firebase.initializeApp` doesn't validate its API key over the
      network, so it "succeeds" even with the committed placeholder
      `firebase_options.dart`, leaving `Firebase.apps` non-empty and
      wrongly triggering a real (and failing) Firebase Phone Auth attempt
      on login. Fixed by skipping `initializeApp` entirely while the
      config is still the known placeholder sentinel. Also added Russia
      (+7) as a second served region alongside Tajikistan (+992) —
      `PhoneValidator` region-aware, phone-entry screen has a region
      selector, backend `ValidPhone` regex accepts both shapes.

## Real hosted backend (Hugging Face Spaces + Supabase + R2)

- [x] `POST /api/v1/uploads/presign` — real, working S3-compatible
      presigned-upload endpoint (`internal/storage`, using `minio-go`
      against Cloudflare R2 or any S3-compatible endpoint), for review
      photos and support-chat attachments. The client uploads directly to
      object storage; the API never proxies file bytes. Returns
      `UPLOADS_NOT_CONFIGURED` until `R2_ENDPOINT`/`R2_ACCESS_KEY`/
      `R2_SECRET_KEY`/`R2_BUCKET` are set. Mobile-side wiring (image
      picker → presign → PUT → attach `public_url`) is not done yet — the
      write-review/support-chat screens still take a manual `image_url`
      string; hooking the picker up to this endpoint is a small follow-up.
- [x] `docs/HUGGINGFACE_DEPLOYMENT.md` + `infrastructure/huggingface/`
      (Dockerfile + Space README frontmatter) — a complete, ready-to-push
      recipe for a real, live TajikShop backend on Hugging Face Spaces
      (Docker SDK), backed by a managed Postgres (Supabase) and Redis
      (Upstash), mirroring the hosting pattern already used by this
      account's other projects. This is external setup the user does
      once in their own accounts — cannot be completed from a sandbox.
- [x] Fixed two real, previously-undetected config bugs found while
      writing the above: `.env.example` documented `CORS_ALLOWED_ORIGINS`
      but `internal/config` actually reads `CORS_ORIGINS` (silently
      falling back to the default and ignoring whatever was set); and the
      `OBJECT_STORAGE_*` variables documented for MinIO/R2 were never
      wired to any code at all. Both fixed — `.env.example` and
      `docker-compose.yml` now match reality (`R2_*` naming, chosen to
      match the env-var convention already used by this account's other
      Hugging-Face-hosted services).
- [x] First real deploy attempt on `Mahmadmurodov/YouShop`, and what it
      took to get green — all found via actual HF build/runtime logs, not
      guessed:
      - R2 secret names on the real Space didn't match what was guessed —
        fixed to read `CF_ACCOUNT_ID`/`CF_R2_ACCESS_KEY_ID`/
        `CF_R2_SECRET_ACCESS_KEY`/`CF_R2_BUCKET`/`CF_R2_PUBLIC_URL` (R2
        endpoint derived from `CF_ACCOUNT_ID`).
      - `services/api/go.mod` requires `go >= 1.25.0`; the Space's
        Dockerfile used `golang:1.24-bookworm` and HF's build environment
        runs `GOTOOLCHAIN=local` (no auto-download) — hard build failure.
        Fixed to `golang:1.25-bookworm`; `backend-ci.yml`'s go-version
        bumped to match (it only "worked" before via `GOTOOLCHAIN=auto`
        silently downloading the right version).
      - Triggering a factory-rebuild via the HF REST API alone did NOT
        pick up that fix — it just rebuilds whatever Dockerfile is
        currently sitting in the *Space's own* git repo, which still had
        the stale hand-pasted content. `deploy-huggingface.yml` now
        actually `git push`es `infrastructure/huggingface/{Dockerfile,
        README.md}` to the Space's repo on every deploy (with the
        commit SHA baked into a new `ARG SOURCE_COMMIT` line, which is
        what busts Docker's cached git-clone layer) — the Space's
        Dockerfile is now always in sync with this repo, automatically.
      - `REDIS_URL` was a hard-required config value; the user hit
        Upstash's one-free-database limit and asked for the server to run
        without Redis at all. Made it optional:
        `internal/db.ConnectRedis` starts an in-process, in-memory
        Redis-compatible server (`miniredis`, already a dependency) when
        `REDIS_URL` is unset, so rate limiting/OTP cooldowns/checkout
        idempotency keep working unchanged with zero external setup —
        trade-off documented in `docs/HUGGINGFACE_DEPLOYMENT.md`: that
        data doesn't survive a restart and isn't shared across replicas,
        fine for one container, not a substitute for real Redis at scale.
        Verified with a real test (`internal/db/redis_test.go`) that pings
        and round-trips a value through the in-memory server.

## Completed

- [x] Phase 1 — Architecture: `docs/ARCHITECTURE.md`, `docs/DATABASE_SCHEMA.md`
      + `infrastructure/database/migrations/0001_init.{up,down}.sql`,
      `docs/API_SPEC.md`, `docs/SECURITY.md`, `docs/DEPLOYMENT.md`.
- [x] Phase 2 — Go backend foundation (`services/api`): config, Postgres/Redis
      wiring with an embedded golang-migrate runner, OTP+JWT auth (Redis rate
      limiting, rotating refresh sessions), RBAC middleware, and
      repository/service/handler layers for home, catalog, search, cart,
      checkout (server-recomputed totals, `SELECT ... FOR UPDATE` stock
      locking, `Idempotency-Key` double-submit protection), orders (incl.
      compensating cancel), favorites, loyalty (TajBonus append-only ledger),
      addresses, profile, and a polling-based `/ws/orders/:id` channel.
      Seed data: 5 stores, 15 categories, 120 products in TJS. Verified live
      against real Postgres/Redis in-session (not just compiled); `go build`,
      `go vet`, `go test` all pass. Deviation: JWT is HS256 (not RS256 as
      drafted in docs/SECURITY.md) — documented in `internal/config`.
- [x] Firebase Phone Auth (`POST /auth/firebase-verify`) — the real-SMS
      registration path added at the user's request, adapted from the
      verification approach already proven in their
      `github.com/Raonsonapp/TajikShop` repo (`internal/auth/firebase.go`).
      Console-OTP remains the no-external-account local-dev fallback. See
      `docs/FIREBASE_SETUP.md` for the external (Firebase console) steps
      required to turn on real SMS delivery — cannot be done from a sandbox.
- [x] Telegram Gateway SMS provider (`internal/pkg/otp/telegram.go`) — the
      recommended free, no-billing-account SMS path for Tajikistan/Central
      Asia/Russia, requested after the user flagged that Firebase Phone
      Auth needs a Google Cloud Blaze account. Auto-selected by
      `cmd/server/main.go` when `TELEGRAM_GATEWAY_TOKEN` is set; see
      `docs/SMS_PROVIDERS.md` for the comparison of all three options.
- [x] App icon processed from the user-supplied artwork (background
      removed, tightly cropped) at `apps/mobile/assets/branding/` — see
      `docs/BRANDING.md`. Wiring into `flutter_launcher_icons` is part of
      the in-progress mobile work below.
- [x] Google Play submission paperwork: `docs/GOOGLE_PLAY_LISTING.md`
      (store copy in tj/ru/en), `docs/GOOGLE_PLAY_DATA_SAFETY.md`,
      `docs/PRIVACY_POLICY.md` (trilingual, needs public hosting before
      submission — see that doc).

- [x] Phase 3 — Flutter foundation (`apps/mobile`): theme (dark primary +
      light, brand colors), tj/ru/en localization, GoRouter
      (`StatefulShellRoute` bottom nav + auth redirect guard), Dio API
      client (auth-refresh interceptor, typed exceptions), Riverpod
      providers, core widgets/states (empty/error/skeleton/offline), and
      full screens: auth (phone+OTP), home feed, catalog, product detail,
      search, cart (server-totals only, never computed client-side),
      checkout (COD + idempotency key), orders (tabs + detail), favorites,
      profile/settings/addresses. Plus, pulled forward from Phase 5 at the
      user's request: a bundled outline icon set (Lucide font + glyphs,
      offline, no broken third-party package dependency); a real barcode/
      price scanner (`mobile_scanner` against
      `GET /products/barcode/:code`, on-demand camera permission); an
      order delivery-status timeline (WebSocket `/ws/orders/:id` with an
      8s-polling fallback); Firebase Phone Auth wired with an automatic
      fallback to the console-OTP flow when no real Firebase project is
      configured yet; the real app icon via `flutter_launcher_icons`
      (Android adaptive icon + iOS AppIcon, from the user's processed
      artwork); and a GPS + OpenStreetMap "nearby stores" screen
      (`geolocator` + `flutter_map`, no paid Google Maps key, tap-to-see
      each store's distance/delivery-pickup flags/sample products).
      Verified in-session: `flutter analyze` — 0 issues; `flutter test` —
      23/23 passing; `flutter_launcher_icons`/`build_runner` ran clean.
- [x] Phase 5 — Promotions, reviews, notifications, support chat, on both
      sides:
      - **Backend**: `GET /promotions`, `POST /promo-codes/validate`
        (reuses `CheckoutService`'s existing promo-validation logic against
        the caller's live cart, no duplicated rules), `GET/POST /reviews`
        (purchase-gated via a real join on `order_items`→`orders`, new
        `DUPLICATE_REVIEW`/`REVIEW_REQUIRES_PURCHASE` apperr codes),
        notifications list/mark-read/preferences/device registration,
        support conversations/messages REST plus a real
        `WS /ws/support/:conversationId` (generalized the existing
        `ws.Hub` used by `/ws/orders/:id` rather than duplicating it).
        Verified live against real Postgres/Redis: OTP→order→review
        purchase-gating and duplicate rejection, promo validation/rejection,
        notification preferences/mark-read ownership checks, and a genuine
        WebSocket round-trip (POST a support message → connected socket
        receives it; `/ws/orders/:id` regression-checked unaffected).
        `go build`/`go vet`/`go test` all pass.
      - **Mobile**: `lib/features/loyalty/` (TajBonus balance + transaction
        ledger, entry point from Profile), `lib/features/promotions/`
        (active campaigns/offers, wired from Home's "personal offers"
        section), `lib/features/reviews/` (product-detail review list +
        a write-review flow reachable only from a delivered order's real
        line item, so `order_item_id` is never invented), 
        `lib/features/notifications/` (list + preferences — REST only, see
        known issues re: FCM), `lib/features/support/` (conversations +
        a chat screen using a new `SupportChatSocket` mirroring the
        existing `OrderTrackingSocket` connect/reconnect pattern). All
        strings localized in tj/ru/en. Verified: `flutter analyze` —
        0 issues; `flutter test` — 34/34 passing.
- [x] Android release build fixed to sign for real: `android/app/build.gradle.kts`
      previously hard-coded the release build type to the debug keystore
      (unmodified Flutter template placeholder) — every "release" build was
      actually debug-signed. Now reads `android/key.properties` (local dev)
      or CI-provided `ANDROID_KEYSTORE_*` secrets
      (`.github/workflows/android-release.yml`, which also had a second bug:
      its keystore-decode step checked an unset `env` value and never ran).
      Falls back to the debug key only when no real key is configured, and
      does so loudly (Gradle + GitHub Actions warnings), never silently.
      R8/ProGuard minification enabled with `android/app/proguard-rules.pro`.
      Workflow now also triggers on push to `main` and `workflow_dispatch`,
      not only on `v*` tags. See `docs/DEPLOYMENT.md`.

## Not started

- [ ] Phase 4 — Run the mobile app against the live backend
      (`docker compose up` + `flutter run`) to validate the full vertical
      slice end-to-end; currently wired in code on both sides but never
      exercised together live in this sandbox (no Android/emulator
      environment here — see PROJECT_STATE known issues)
- [ ] Phase 6 — Admin web panel (`apps/admin`)
- [ ] Phase 7 — Test suites (unit/widget/API) incl. the required edge cases
      (out-of-stock, price-changed cart, invalid/expired promo, double order
      submission, network timeout, unauthorized/expired token, duplicate
      review, bonus calculation)
- [ ] Phase 8 — docker-compose, Dockerfiles, GitHub Actions CI/CD
- [ ] Phase 9 — Android release build prep (signing, ProGuard, Play listing)

## Known issues / open decisions

- SMS delivery: three paths now exist — console-log OTP (no setup, dev
  default), Telegram Gateway (recommended: free, no billing account,
  strong in Tajikistan/CIS), and Firebase Phone Auth (real SMS but needs a
  Google Cloud Blaze billing account). See `docs/SMS_PROVIDERS.md`.
- Real online payment provider not yet selected — `payment.Provider`
  interface has only `cash_on_delivery` implemented, as required.
- Map provider: backend delivery-zone checks still use raw lat/lng +
  GeoJSON polygon in Postgres (no map SDK dependency). The mobile "nearby
  stores" map (in progress) uses `flutter_map` + OpenStreetMap tiles
  specifically to avoid a paid/API-key-gated vendor.
- Google Play screenshots/feature graphic not yet produced — needs a
  stable, running UI to capture from (Phase 9 task).
- Firebase Phone Auth's Dart-level fallback (try/catch around
  `Firebase.initializeApp`) is structurally verified, but the mobile app
  itself has never been launched on a device/emulator in this sandbox — a
  native-level Firebase SDK failure on the still-placeholder
  `firebase_options.dart` cannot be fully ruled out until someone completes
  `docs/FIREBASE_SETUP.md` and runs the app for real.
- Notifications are REST-list-only for now — `firebase_messaging` is not
  yet wired into the mobile app (only `firebase_core`/`firebase_auth` for
  phone sign-in), so there is no real push receiving yet and
  `POST /devices` is intentionally not called (no real FCM token to
  register). Adding real push is a reasonable Phase 6/7 follow-up.
- `GET /promotions`'s response shape and promo-code validation being
  scoped to the caller's current cart (rather than a bare code-only check)
  were judgment calls made where `docs/API_SPEC.md` was underspecified —
  worth confirming against the mobile UI's actual needs as Phase 4 (live
  end-to-end run) proceeds.

## Files created (updated per commit)

See git log on `claude/tajikshop-marketplace-app-rvkxre` for the authoritative
list; this section summarizes top-level additions per phase.

### Phase 1
- `docs/ARCHITECTURE.md`, `docs/DATABASE_SCHEMA.md`, `docs/API_SPEC.md`,
  `docs/SECURITY.md`, `docs/DEPLOYMENT.md`
- `infrastructure/database/migrations/0001_init.up.sql`,
  `infrastructure/database/migrations/0001_init.down.sql`
- `PROJECT_STATE.md`, `README.md`

## Next tasks

1. Merged into `main` at the user's explicit, repeated request (kept
   up to date with every verified phase, most recently Phase 5 + the
   Android release-signing fix).
2. Run the mobile app against the live backend via `docker compose up` +
   `flutter run` on a real Android environment to validate the full
   vertical slice end-to-end (Phase 4) — not possible from this sandbox
   (no Android SDK/emulator here).
3. Complete the external, sandbox-can't-do-this setup: `docs/FIREBASE_SETUP.md`
   (if Firebase Phone Auth is wanted) and/or get a `TELEGRAM_GATEWAY_TOKEN`
   (recommended, see `docs/SMS_PROVIDERS.md`); host `docs/PRIVACY_POLICY.md`
   at a public URL for Play Console; generate a real upload keystore and
   set the four `ANDROID_KEYSTORE_*` GitHub secrets so release builds are
   Play-Store-signed (see `docs/DEPLOYMENT.md`).
4. Continue into Phase 6 (admin web panel), Phase 7 (fuller test suite:
   out-of-stock, price-changed cart, invalid/expired promo, double order
   submission, network timeout, unauthorized/expired token — several of
   these are already covered by Phase 2/5's service-layer tests, but not
   yet as an exhaustive suite), and Phase 9 (real Play Store screenshots,
   feature graphic, and an actual signed build).
5. Add real push notification delivery (`firebase_messaging` on mobile +
   an FCM sender on the backend) — currently notifications are REST-only.
