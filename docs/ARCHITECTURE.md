# TajikShop — Architecture (Phase 1)

TajikShop is an original grocery/marketplace delivery platform for Tajikistan
(primary language: Tajik, secondary: Russian, currency: TJS). This document is
the Phase 1 deliverable: architecture, folder tree, feature matrix, and
development roadmap. It is the source of truth all later phases must stay
consistent with — see `PROJECT_STATE.md` for live progress.

## 1. High-level architecture

```
┌─────────────────┐        ┌──────────────────┐        ┌───────────────────┐
│  Flutter Mobile  │  HTTPS │                   │        │   PostgreSQL       │
│  (apps/mobile)   │◄──────►│   Go API (Gin)    │◄──────►│   (primary store)  │
│  Android first   │  WSS   │  services/api     │        └───────────────────┘
└─────────────────┘        │                   │        ┌───────────────────┐
┌─────────────────┐        │  - REST v1        │◄──────►│   Redis            │
│  Admin Web       │  HTTPS │  - WebSocket hub  │        │   (cache/session)  │
│  (apps/admin)    │◄──────►│  - Auth/RBAC      │        └───────────────────┘
└─────────────────┘        │  - Job workers    │        ┌───────────────────┐
                            └─────────┬─────────┘◄──────►│ Object storage      │
                                      │                  │ (R2 / Supabase)     │
                                      ▼                  └───────────────────┘
                            ┌───────────────────┐        ┌───────────────────┐
                            │ FCM (push)         │        │ SMS/OTP provider   │
                            └───────────────────┘        │ (interface, local  │
                                                          │ dev = console log) │
                                                          └───────────────────┘
```

Design principles:
- **Clean architecture** everywhere: handlers/UI never talk to the database or
  each other's internals directly — always through a service/repository layer
  behind an interface, so any external dependency (SMS gateway, map provider,
  payment provider) is swappable without touching business logic.
- **Server is the source of truth** for price, stock, discounts, bonus
  balance, and order totals. The client never computes money.
- **Feature-based** organization on both mobile and backend so features can be
  built/tested/shipped independently.

## 2. Monorepo layout

```
/apps
  /mobile                 Flutter app (Android first, iOS-ready)
    lib/
      core/
        config/           env, flavors, constants
        network/          Dio client, interceptors, error mapping
        router/            GoRouter setup, route guards
        localization/      tj (default) + ru ARB files, l10n config
        theme/             Material 3 theme, colors, typography, spacing
        storage/           secure storage, token storage
        analytics/         analytics abstraction (events, no PII)
        widgets/           shared components (buttons, cards, states)
      features/
        auth/               phone+OTP login, session
        onboarding/
        home/
        catalog/
        search/
        product/
        cart/
        checkout/
        orders/
        favorites/
        loyalty/            TajBonus
        promotions/
        reviews/
        barcode/
        notifications/
        support/
        profile/
        settings/
      main.dart
    test/
  /admin                  Admin web dashboard (Phase 6)

/services
  /api                    Go backend (Gin)
    cmd/server/           entrypoint
    internal/
      config/             env config loader
      httpserver/         router wiring, middleware chain
      auth/               OTP issuing/verification, JWT, RBAC
      middleware/         auth, rate-limit, logging, CORS, recover
      db/                 pgx pool, redis client, migrations runner
      models/             DB row structs
      repository/         SQL access per aggregate (one file per table group)
      service/            business logic per feature (orders, cart, loyalty…)
      httpapi/             HTTP handlers + DTOs, grouped by feature
      ws/                 WebSocket hub (support chat, order status)
      jobs/               background workers (bonus accrual, notifications)
      pkg/                 small internal libs (money, otp, pagination)
    migrations/           SQL migrations (golang-migrate format)
    go.mod / go.sum

/packages
  /shared                 Cross-cutting contracts shared by all clients
    openapi.yaml          REST API contract (source of truth for DTOs)
    enums.md              Canonical enums (order status, discount type, …)

/infrastructure
  /docker                 Dockerfiles (api, admin)
  /database               migrations (symlinked/copied into services/api),
                           seed scripts
  /deployment             docker-compose (dev/prod), env docs

/docs                     Architecture, API spec, schema, security, roadmap
/.github/workflows        CI (flutter analyze/test, go test/vet, builds)
PROJECT_STATE.md          Live phase/feature tracker (see root)
```

## 3. Technology decisions

| Layer | Choice | Notes |
|---|---|---|
| Mobile | Flutter 3.x / Dart 3.x | Material 3, dark theme primary |
| State mgmt | Riverpod (hooks_riverpod) | Testable, no BuildContext coupling |
| Routing | go_router | Declarative, guarded routes (auth) |
| HTTP | dio + interceptors | Retry, auth refresh, error mapping |
| Models | freezed + json_serializable | Immutable DTOs matching openapi.yaml |
| Secure storage | flutter_secure_storage | Access/refresh tokens only |
| Backend | Go 1.22+, Gin | REST v1, WebSocket via gorilla/websocket |
| DB driver | pgx v5 (+ sqlc-style hand repositories) | No heavy ORM — explicit SQL |
| DB | PostgreSQL 15+ | Normalized schema, see DATABASE_SCHEMA.md |
| Cache/session | Redis 7 | OTP throttling, cache, refresh-token denylist |
| Object storage | S3-compatible interface → Cloudflare R2 (prod) / MinIO (dev) | |
| Push | Firebase Cloud Messaging | Abstracted behind `notifier.Sender` interface |
| SMS/OTP | `otp.Sender` interface → console/log sender (dev), pluggable provider (prod) | |
| Payments | `payment.Provider` interface → `cash_on_delivery` (only impl now) | |
| Maps | `geo.Provider` interface, no vendor import outside it | Zone checks use raw lat/lng + polygon table, no map SDK required |
| Auth | Phone + OTP, JWT access (15 min) + refresh (30 days, rotating, Redis-backed denylist) | |
| Migrations | golang-migrate | Up/down SQL files, run in CI against empty DB |
| CI/CD | GitHub Actions | analyze/test/vet + Android AAB/APK build |

## 4. Feature matrix (Phase scope)

| Feature | Backend | Mobile | Admin | Phase |
|---|---|---|---|---|
| Phone+OTP auth, sessions, refresh | ✅ | ✅ | ✅ (staff login) | 2–4 |
| Home feed (dynamic sections) | ✅ | ✅ | – | 4 |
| Catalog / categories / stores | ✅ | ✅ | Phase 6 | 4 |
| Search + filters + sort | ✅ | ✅ | – | 4 |
| Product details | ✅ | ✅ | Phase 6 | 4 |
| Cart (server-recalculated) | ✅ | ✅ | – | 4 |
| Checkout (COD) + delivery zones | ✅ | ✅ | – | 4 |
| Orders + status history | ✅ | ✅ | Phase 6 | 4 |
| Favorites | ✅ | ✅ | – | 5 |
| TajBonus loyalty | ✅ | ✅ | Phase 6 | 5 |
| Promo codes / personal discounts | ✅ | ✅ | Phase 6 | 5 |
| Reviews (purchase-gated) | ✅ | ✅ | Phase 6 | 5 |
| Barcode scanner | – (uses product search API) | ✅ | – | 5 |
| Notifications (FCM) | ✅ | ✅ | – | 5 |
| Support chat (WebSocket) | ✅ | ✅ | Phase 6 | 5 |
| Admin dashboard | ✅ APIs | – | ✅ | 6 |
| Tests (unit/widget/API) | ✅ | ✅ | – | 7 |
| Docker/CI/CD | ✅ | ✅ | ✅ | 8 |
| Android release build | – | ✅ | – | 9 |

## 5. Security model — summary (full detail in `docs/SECURITY.md`)

- OTP: 6 digits, hashed (bcrypt) at rest, 5-minute expiry, max 5 verify
  attempts, resend cooldown, per-phone + per-IP rate limiting via Redis.
- JWT access token (short-lived) + rotating refresh token (device-bound,
  revocable, stored hashed). Session table tracks device/IP/last-seen.
- RBAC: `customer`, `store_manager`, `courier`, `support_agent`, `admin`.
  Every admin endpoint requires role middleware; every mutating customer
  endpoint requires ownership checks.
- All money/stock/loyalty logic runs server-side inside a DB transaction;
  client-submitted price/discount/bonus values are always ignored and
  recomputed.
- Parameterized SQL only (pgx), no string-built queries.
- Structured audit log table for admin actions (`audit_logs`, added in
  Phase 6 migration).

## 6. Deployment architecture — summary (full detail in `docs/DEPLOYMENT.md`)

- Local/dev: `docker-compose.yml` — postgres, redis, minio (R2-compatible),
  api, (later) admin.
- CI: GitHub Actions runs `flutter analyze`, `flutter test`, `go vet ./...`,
  `go test ./...`, then builds Android APK/AAB on tagged builds.
- Prod: containerized API behind a reverse proxy/load balancer, managed
  Postgres + Redis, R2 for objects, FCM for push. No secrets in git —
  `.env.example` documents every variable.

## 7. Development roadmap (matches Section 43 of the brief)

1. **Phase 1 — Architecture** (this document + DATABASE_SCHEMA.md, API_SPEC.md,
   SECURITY.md, DEPLOYMENT.md, FEATURE_MATRIX in this doc). ✅ this session.
2. **Phase 2 — Backend foundation**: Go project, config, DB pool, migrations,
   models/repositories, auth (OTP+JWT), middleware, first API group (auth +
   home + catalog).
3. **Phase 3 — Flutter foundation**: theme, localization (tj/ru), router,
   API client, Riverpod setup, core widgets/states.
4. **Phase 4 — Core commerce**: auth, home, catalog, search, product, cart,
   checkout, orders (end-to-end against the real API).
5. **Phase 5 — Engagement**: loyalty, promotions, favorites, reviews,
   notifications, barcode, support chat.
6. **Phase 6 — Admin panel**.
7. **Phase 7 — Testing**.
8. **Phase 8 — Docker/CI/CD**.
9. **Phase 9 — Android release prep**.

This is a multi-week, production-scope build. Phases 2–3 (with a working
vertical slice into Phase 4: auth → home → catalog) are the focus of the next
commits in this session; later phases continue in follow-up sessions and are
tracked feature-by-feature in `PROJECT_STATE.md`.
