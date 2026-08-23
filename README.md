# TajikShop

An original grocery/marketplace delivery platform for Tajikistan — Tajik
(primary) / Russian (secondary) UI, Tajik Somoni (TJS) currency, Android
first (Flutter, iOS-ready).

This is a production-scope build developed in phases. Start here:

- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — system architecture,
  monorepo layout, tech stack, feature matrix, roadmap.
- [`docs/DATABASE_SCHEMA.md`](docs/DATABASE_SCHEMA.md) — schema overview
  (full DDL in `infrastructure/database/migrations/`).
- [`docs/API_SPEC.md`](docs/API_SPEC.md) — REST API contract.
- [`docs/SECURITY.md`](docs/SECURITY.md) — auth, RBAC, and server-authoritative
  money/stock/loyalty rules.
- [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) — local dev, CI/CD, environments.
- [`PROJECT_STATE.md`](PROJECT_STATE.md) — live phase/feature progress tracker.

## Monorepo layout

```
apps/mobile        Flutter app (Android first)
apps/admin         Admin web dashboard
services/api       Go backend (Gin)
packages/shared    Cross-cutting contracts (OpenAPI spec, enums)
infrastructure     Docker, database migrations/seed, deployment config
docs               Architecture and specification documents
```

## Getting started (local dev)

```bash
cd infrastructure/deployment
cp .env.example .env
docker compose up -d          # postgres, redis, minio, api
```

```bash
cd apps/mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1
```

See `docs/DEPLOYMENT.md` for full environment and CI/CD details.
