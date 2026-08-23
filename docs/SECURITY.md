# TajikShop — Security Model (Phase 1)

## Authentication

- Phone-first, OTP-based, no passwords stored anywhere.
- OTP: 6-digit numeric, generated with `crypto/rand`, stored only as a
  bcrypt hash in `otp_codes`, 5-minute expiry, max 5 verification attempts
  (`otp_codes.attempts`), one active OTP per phone (older ones invalidated
  on a new send). Resend cooldown of 60s enforced via Redis key
  `otp:cooldown:<phone>`. Delivery is pluggable (`otp.Sender`): console
  logging in dev, Telegram Gateway in production by default — see
  `docs/SMS_PROVIDERS.md` for the full comparison, including the Firebase
  Phone Auth alternative below.
- Rate limiting (Redis, sliding window): 5 OTP sends / phone / hour, 20 / IP
  / hour; 5 verify attempts / phone / 15 min.
- On success: JWT access token (RS256, 15 min TTL) + opaque refresh token
  (random 256-bit, stored only as SHA-256 hash in `user_sessions`, 30-day
  TTL, rotated on every refresh — old token hash is invalidated the moment a
  new one is issued, closing the replay window).
- `user_sessions` doubles as device/session management: device id/name, IP,
  user agent, last-used timestamp; users can view/revoke sessions from
  Profile → Security (Phase 5+).
- Google Sign-In (optional): server verifies the Google ID token signature
  and audience server-side before ever trusting `sub`/phone/email claims.
- **Firebase Phone Auth (`POST /auth/firebase-verify`)**: the real-SMS
  registration path — see `docs/FIREBASE_SETUP.md`. Firebase's own
  infrastructure sends and verifies the SMS code on the device; the backend
  never sees the code, only the resulting ID token, which it confirms is
  genuine (`internal/auth/firebase.go`, `accounts:lookup` against Google)
  before extracting the verified phone number and issuing a normal
  TajikShop session (same `issueTokens` path, same session/JWT rules above).
  The console-OTP flow (`send-otp`/`verify-otp`) remains available as the
  offline/local-dev fallback that needs no external account.

## Authorization (RBAC)

Roles: `customer`, `store_manager`, `courier`, `support_agent`, `admin`.
- Every route declares required role(s) via middleware
  (`middleware.RequireRole(...)`); default is `customer`-or-anonymous for
  public catalog reads.
- Ownership checks: a customer can only read/mutate their own cart,
  addresses, orders, favorites, reviews, support conversations — enforced by
  filtering every query on `user_id = ctx.UserID`, never trusting a body/
  query-supplied user id.
- `store_manager` is scoped to their assigned store(s) (future
  `store_managers` join table) for admin product/inventory endpoints.
- Admin actions (product/price/stock/promo/order status changes) write an
  `audit_logs` row with actor, action, entity, before/after metadata.

## Server-authoritative money & stock

Non-negotiable rule, enforced in the service layer, not just documented:
- Cart, checkout quote, and order creation always re-read `products` +
  `inventory` + active `discounts`/`promo_codes`/`loyalty_accounts` from the
  database inside a single serializable-enough transaction (`SELECT ... FOR
  UPDATE` on the touched `inventory` rows) and recompute subtotal, discount,
  delivery fee, bonus usage, and total from scratch.
- Any price/discount/total/bonus field present in a client request body is
  parsed for shape validation only and then discarded before the compute
  step — it is never written to the database or used in a calculation.
- Stock is decremented only inside the same transaction that creates the
  order; insufficient stock aborts the whole transaction (no partial
  orders), returning `OUT_OF_STOCK` with the offending line items.
- `loyalty_transactions` is append-only and written by the service layer
  only; there is no endpoint that accepts a client-supplied balance delta.

## Input validation & injection protection

- All SQL goes through `pgx` parameterized queries — no string
  concatenation of user input into SQL, anywhere.
- Every DTO is validated (struct tags + explicit checks: phone format
  `+992XXXXXXXXX` (Tajikistan) or `+7XXXXXXXXXX` (Russia) — TajikShop's two
  served regions — quantity > 0, enum membership for status/role/discount
  type, UUID format) before touching the service layer.
- File uploads (review images, support attachments) are validated by
  content-type/magic-bytes and size limit, stored under a generated key
  (never the client-supplied filename), served from object storage with a
  restrictive bucket policy.

## Transport & headers

- HTTPS only in production (HSTS enabled).
- CORS: explicit allow-list of the admin web origin(s); mobile app talks
  over Bearer tokens, not cookies, so CSRF is not applicable to it — the
  admin web origin is still locked down.
- Standard secure headers (`X-Content-Type-Options`, `X-Frame-Options`,
  `Referrer-Policy`) via middleware.
- Structured request logging (method, path, status, latency, user id — no
  request/response bodies with PII) plus the separate `audit_logs` table for
  admin actions.

## Secrets

- Nothing sensitive is committed. `.env.example` documents every variable
  with a placeholder; real values live in the deployment environment/secret
  manager only.
