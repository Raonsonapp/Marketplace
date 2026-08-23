# TajikShop — Project State

Live tracker for the multi-phase build described in `docs/ARCHITECTURE.md`.
Update this file whenever a phase/feature status changes.

## Current phase

**Phase 2–3 in progress** (backend + mobile foundations), following Phase 1
(architecture, completed).

## Completed

- [x] Phase 1 — Architecture: `docs/ARCHITECTURE.md`, `docs/DATABASE_SCHEMA.md`
      + `infrastructure/database/migrations/0001_init.{up,down}.sql`,
      `docs/API_SPEC.md`, `docs/SECURITY.md`, `docs/DEPLOYMENT.md`.

## In progress

- [ ] Phase 2 — Go backend foundation (`services/api`): config, DB/Redis
      wiring, migration runner, OTP+JWT auth, RBAC middleware, auth + home +
      catalog + cart + checkout + orders endpoints, seed data.
- [ ] Phase 3 — Flutter foundation (`apps/mobile`): theme, tj/ru
      localization, GoRouter, Dio API client, Riverpod providers, core
      widgets/states, splash/onboarding/auth/home/catalog/cart screens.

## Not started

- [ ] Phase 4 — Full core-commerce vertical slice wired end-to-end
      (search, product detail, checkout, order tracking against the real API)
- [ ] Phase 5 — Loyalty (TajBonus), promotions, favorites, reviews,
      notifications, barcode scanner, support chat
- [ ] Phase 6 — Admin web panel (`apps/admin`)
- [ ] Phase 7 — Test suites (unit/widget/API) incl. the required edge cases
      (out-of-stock, price-changed cart, invalid/expired promo, double order
      submission, network timeout, unauthorized/expired token, duplicate
      review, bonus calculation)
- [ ] Phase 8 — docker-compose, Dockerfiles, GitHub Actions CI/CD
- [ ] Phase 9 — Android release build prep (signing, ProGuard, Play listing)

## Known issues / open decisions

- Real SMS/OTP provider for Tajikistan not yet selected — dev uses a
  console-log `otp.Sender` implementation behind the same interface real
  providers will implement.
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

1. Finish Phase 2 backend foundation and Phase 3 mobile foundation.
2. Seed realistic dev data (5 stores, 15 categories, 100+ products) per
   Section 37 and verify migrations run clean from an empty database.
3. Wire docker-compose so `docker compose up` gives a fully working local
   backend, then continue into Phase 4.
