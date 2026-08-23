# TajikShop — Project State

Live tracker for the multi-phase build described in `docs/ARCHITECTURE.md`.
Update this file whenever a phase/feature status changes.

## Current phase

**Phase 3 in progress** (mobile foundation, now also covering the barcode
scanner and order delivery-status timeline pulled forward from Phase 5).
Phase 2 (backend) is complete and verified.

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

## In progress

- [ ] Phase 3 — Flutter foundation (`apps/mobile`): theme, tj/ru
      localization, GoRouter, Dio API client, Riverpod providers, core
      widgets/states, splash/onboarding/auth/home/catalog/cart/checkout/
      orders/favorites/profile screens. Pulled forward from Phase 5 at the
      user's request: outline icon set (`lucide_icons`, Feather-style
      fallback) replacing default Material icons app-wide; a real barcode/
      price scanner screen (`mobile_scanner` against
      `GET /products/barcode/:code`); an order delivery-status timeline on
      the order detail screen (wired to `/ws/orders/:id` where possible);
      and Firebase Phone Auth wired into the phone-login screens (falling
      back to the console-OTP flow until the user completes the Firebase
      console setup in `docs/FIREBASE_SETUP.md`).

## Not started

- [ ] Phase 4 — Full core-commerce vertical slice wired end-to-end against a
      running backend (currently wired in code but not yet run together live)
- [ ] Phase 5 remainder — promotions, reviews, notifications, support chat
      (barcode scanner and delivery-status tracking pulled into Phase 3, see
      above)
- [ ] Phase 6 — Admin web panel (`apps/admin`)
- [ ] Phase 7 — Test suites (unit/widget/API) incl. the required edge cases
      (out-of-stock, price-changed cart, invalid/expired promo, double order
      submission, network timeout, unauthorized/expired token, duplicate
      review, bonus calculation)
- [ ] Phase 8 — docker-compose, Dockerfiles, GitHub Actions CI/CD
- [ ] Phase 9 — Android release build prep (signing, ProGuard, Play listing)

## Known issues / open decisions

- SMS delivery: two paths now exist — console-log OTP (no setup, dev
  default) and Firebase Phone Auth (real, free-tier SMS to +992 numbers).
  Firebase requires one-time external console setup by the project owner
  (see `docs/FIREBASE_SETUP.md`) that cannot be completed from a sandbox.
- Real online payment provider not yet selected — `payment.Provider`
  interface has only `cash_on_delivery` implemented, as required.
- Map provider intentionally not chosen — delivery-zone checks use raw
  lat/lng + GeoJSON polygon in Postgres, no map SDK dependency yet.

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

1. Finish Phase 3 mobile foundation (incl. scanner/delivery-timeline/icons).
2. Run the mobile app against the live backend via `docker compose up` +
   `flutter run` to validate the vertical slice end-to-end (Phase 4).
3. Decide and merge the completed work into `main` (user has asked for a
   direct push once the current build is verified).
4. Continue into Phase 5 remainder (promotions, reviews, notifications,
   support chat), then Phase 6 admin panel, Phase 7 tests, Phase 9 Android
   release prep.
