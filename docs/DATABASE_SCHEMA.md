# TajikShop — Database Schema (Phase 1)

PostgreSQL 15+. Full DDL lives in
`infrastructure/database/migrations/0001_init.up.sql` (golang-migrate format,
symmetric `.down.sql` provided). This document is the human-readable ERD
description; the SQL file is the source of truth.

## Conventions

- All primary keys are `uuid DEFAULT gen_random_uuid()` (pgcrypto).
- All monetary columns are `numeric(12,2)` in TJS — never floats.
- All tables have `created_at timestamptz default now()`; mutable tables also
  have `updated_at`; user-facing tables that can be removed use
  `deleted_at timestamptz` (soft delete) instead of `DELETE`.
- Bilingual content stores `*_tj` (required) and `*_ru` (optional, falls back
  to `_tj` in the API layer if missing).
- No table stores plaintext OTP or refresh tokens — only bcrypt/SHA-256
  hashes.

## Table groups

**Identity & access**
`users`, `user_sessions` (refresh tokens per device), `otp_codes`
(hashed, expiring, attempt-limited), `device_tokens` (FCM).

**Location**
`countries` (the markets served — TJ and RU — each with its currency code and
per-language label, dial code and default map centre), `cities` (the
deliverable cities of each country, with centre coordinates),
`addresses` (per user, multiple, one default), `stores`, `store_hours`,
`delivery_zones` (GeoJSON polygon + fee rules — provider-agnostic, no PostGIS
dependency required for Phase 1; can be upgraded to PostGIS geometry later
without changing the API contract).

`addresses`, `stores` and `users` each carry a `country` code defaulting to
`'TJ'`: the app served Tajikistan only until migration 0007, so every row
written before it is Tajik by definition. A row's country decides which
currency its money columns are denominated in — the `numeric(12,2)` amounts
themselves carry no currency tag.

**Cargo (parcel forwarding, China -> TJ/RU)**
`cargo_tariffs` (one row per destination country: the China warehouse address,
the per-kilo rate, transit estimate, and an `is_active` switch — a destination
stays hidden until an operator has filled in an address and a rate),
`cargo_shipments` (one parcel: description, optional tracking code and product
link, destination, and — once an operator weighs it at the warehouse — weight
and price; `status` walks new -> received -> shipped -> arrived -> delivered,
with `cancelled` reachable only while the parcel is still `new`).

**Catalog**
`brands`, `categories` (self-referencing `parent_id` for subcategories),
`products` (bilingual name/description, barcode, tags), `product_images`,
`inventory` (per-store price + stock — this is what checkout reads, not
`products.base_price`, which is a catalog-wide fallback/display value).

**Shopping**
`favorites`, `carts` (one active cart per user, pinned to a store),
`cart_items`.

**Orders & delivery**
`orders`, `order_items` (price/name snapshot at order time — never re-reads
`products`), `order_status_history`, `delivery_slots`, `couriers`,
`receipts` (immutable JSON snapshot per order).

**Commerce rules**
`promo_codes`, `promo_code_usage`, `discounts` (personal/category/product/
campaign offers), `loyalty_accounts`, `loyalty_transactions` (append-only
ledger — balance is derived/cached, never mutated directly by clients).

**Engagement**
`reviews` (FK to `order_items` to enforce purchase-gating),
`review_images`, `notifications`, `notification_preferences`.

**Support**
`support_conversations`, `support_messages`.

**Governance**
`audit_logs` (admin action trail, used from Phase 6 onward).

## Key invariants enforced at the DB level

- `orders.total = subtotal - discount_amount + delivery_fee - bonus_used`
  (checked in the service layer inside a transaction; a `CHECK` constraint
  guards non-negativity of money columns).
- `inventory.stock_qty >= 0` (CHECK), decremented only inside the order
  transaction, never from client input.
- `reviews` has a unique constraint on `(user_id, product_id, order_item_id)`
  and a mandatory FK to `order_items`, so a review cannot exist without a
  matching purchase.
- `loyalty_transactions` is append-only; `loyalty_accounts.balance` is
  updated only by the service layer in the same transaction as the ledger
  row, never directly by an API request body.
- `promo_code_usage` unique `(promo_code_id, order_id)` prevents double
  application; per-user/global limits are checked in `service/promotions`.

See `infrastructure/database/migrations/0001_init.up.sql` for full column
definitions, indexes, and constraints.
