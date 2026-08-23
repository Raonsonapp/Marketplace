# TajikShop — Project State

Live tracker for the multi-phase build described in `docs/ARCHITECTURE.md`.
Update this file whenever a phase/feature status changes.

## Current phase

**Phases 1–3 and 5 complete and verified**; Phase 5 (promotions, reviews,
notifications, support chat) landed on both backend and mobile and is
merged to `main`. Also fixed: the Android release build was silently
signed with the debug keystore — now uses a real key.properties-based
signing config with R8/ProGuard enabled. Next up: Phase 4 (run mobile +
backend together live in a real Android environment), Phase 6 (admin
panel), Phase 7 (fuller test suite), Phase 9 (real device/Play submission).

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
