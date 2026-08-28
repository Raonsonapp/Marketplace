# TajikShop — API Specification (Phase 1)

Base URL: `https://api.tajikshop.tj/api/v1` (dev: `http://localhost:8080/api/v1`)

Full machine-readable contract: `packages/shared/openapi.yaml` (kept in sync
as endpoints are implemented — Phase 2+).

## Conventions

- JSON in/out, `Content-Type: application/json`.
- Auth: `Authorization: Bearer <access_token>` except `auth/*` and public
  catalog/home/search reads (which work anonymously but personalize when a
  token is present).
- Pagination: cursor-based on list endpoints — `?cursor=<opaque>&limit=20`,
  response includes `next_cursor` (null when exhausted).
- All list responses: `{ "data": [...], "next_cursor": "..." }`.
- All errors:
  ```json
  { "error": { "code": "OUT_OF_STOCK", "message": "Маҳсулот дар анбор нест", "details": {} } }
  ```
  `code` is a stable machine-readable string (used for client-side handling
  and localized message lookup); `message` is already localized server-side
  based on `Accept-Language` (`tj`/`ru`).
- Money fields are strings with 2 decimals (`"125.50"`) to avoid float
  rounding on the client; currency is always TJS and is not repeated per
  field.
- Idempotency: `POST /orders` requires an `Idempotency-Key` header to make
  double-submission safe (see Section 38 test case "double order submission").

## Endpoints

### Auth
```
POST   /auth/send-otp          { email }                         -> { retry_after_seconds } — the code is
                                                                     emailed via the Apps Script relay
                                                                     (docs/TELEGRAM_RELAY_SETUP.md); there
                                                                     is no SMS path.
POST   /auth/verify-otp        { email, code }                   -> { access_token, refresh_token, user, is_new_user }
POST   /auth/refresh           { refresh_token }                 -> { access_token, refresh_token }
POST   /auth/logout            { refresh_token }                 -> 204
POST   /auth/firebase-verify   { id_token, full_name? }          -> same shape as verify-otp — real-SMS
                                                                     path via Firebase Phone Auth, see
                                                                     docs/FIREBASE_SETUP.md. Returns
                                                                     FIREBASE_NOT_CONFIGURED (503) if the
                                                                     backend has no FIREBASE_WEB_API_KEY set.
POST   /auth/google             { id_token }                      -> same as verify-otp (optional)
```

### Home / Catalog / Search
```
GET    /countries                              -> the markets YouShop serves (TJ, RU): name per language,
                                                  currency code + label per language, dial code, map centre,
                                                  and the deliverable cities of each
GET    /countries/:code/cities                 -> just one market's cities
GET    /home                                   -> dynamic home sections (banners, categories, popular, discounted, recommended, recently_viewed, personal_offers, nearby_stores, featured_brands, buy_again) — each section is data-driven and independently paginated/omitted if empty
GET    /categories                             -> tree of categories
GET    /categories/:id/products                -> paginated products in category
GET    /stores                                 -> nearby/available stores (lat/lng/country/city query params)
GET    /stores/:id                             -> store detail (hours, zones, pickup/delivery flags)
GET    /products                               -> filter/sort query params (see below)
GET    /products/:id                           -> full product detail incl. related/similar
GET    /products/barcode/:code                 -> lookup by scanned barcode
GET    /search                                 -> q, filters, sort, cursor
GET    /search/suggestions                     -> q -> suggestions + recent/popular searches (auth optional)
```
`GET /products` filters: `category_id, brand_id, min_price, max_price,
min_rating, has_discount, store_id, in_stock` — `sort`: `popular|price_asc|
price_desc|rating|discount|newest`.

### Cart
```
GET    /cart                                   -> current cart w/ live-recalculated prices/availability
POST   /cart/items          { product_id, quantity }
PATCH  /cart/items/:id      { quantity }
DELETE /cart/items/:id
POST   /cart/items/:id/save-for-later
DELETE /cart                                    -> clear cart
POST   /cart/promo-code     { code }            -> validates + attaches promo to cart preview
DELETE /cart/promo-code
```

### Checkout / Orders
```
POST   /checkout/quote      { address_id|store pickup, delivery_method, promo_code?, bonus_amount? }
                                                 -> server-computed subtotal/discount/delivery_fee/bonus/total preview
POST   /orders               { cart snapshot ref, address_id, delivery_method, scheduled_at?, payment_method, promo_code?, bonus_amount? }
                                                 -> creates order; server recomputes everything, ignores any client totals
GET    /orders                                  -> ?status=active|completed|cancelled
GET    /orders/:id
POST   /orders/:id/cancel    { reason }
POST   /orders/:id/reorder                       -> re-adds available items to cart
GET    /orders/:id/receipt
```

### Favorites / Reviews
```
GET    /favorites
POST   /favorites/:productId
DELETE /favorites/:productId
GET    /reviews?product_id=
POST   /reviews               { product_id, order_item_id, rating, text, images? }
```

### Loyalty / Promotions
```
GET    /loyalty                                 -> balance, tier, lifetime_earned
GET    /loyalty/transactions
GET    /promotions                              -> active campaigns/personal offers
POST   /promo-codes/validate  { code }
```

### Addresses / Profile
```
GET    /addresses
POST   /addresses             { country, city, street, ... }
PATCH  /addresses/:id
DELETE /addresses/:id
POST   /addresses/:id/default
GET    /profile
PATCH  /profile               { full_name, email, language, country }
```

### Cargo (parcel forwarding, China -> TJ/RU)
```
GET    /cargo/tariffs                          -> public: the destinations forwarding is offered for,
                                                  each with its China warehouse address, per-kg rate
                                                  and transit time. An empty list means no operator has
                                                  switched the service on yet — not an error.
GET    /cargo                                  -> the caller's own parcels
POST   /cargo                 { destination, description, track_code?, product_link? }
GET    /cargo/:id
POST   /cargo/:id/cancel                       -> withdraw a parcel the warehouse hasn't received yet
                                                  (409 CARGO_NOT_CANCELABLE once it is in motion)
```
Operator surface (role: admin/store_manager):
```
GET    /admin/cargo                            -> queue, unfinished first; ?status= to filter
PATCH  /admin/cargo/:id       { track_code?, weight_kg?, status?, note? }
                                               -> the price is always recomputed server-side as
                                                  weight x the destination's rate; there is no cost field
PUT    /admin/cargo/tariffs/:destination
                              { rate_per_kg, warehouse_address, contact_phone,
                                estimated_days_min?, estimated_days_max?, is_active }
```

### Notifications / Support
```
GET    /notifications
PATCH  /notifications/:id/read
GET    /notifications/preferences
PATCH  /notifications/preferences
POST   /devices                { fcm_token, platform }
GET    /support/conversations
POST   /support/conversations
GET    /support/conversations/:id/messages
POST   /support/conversations/:id/messages   { text, image_url? }
WS     /ws/support/:conversationId            -> realtime messages
WS     /ws/orders/:orderId                     -> realtime status updates
```

### Uploads
```
POST   /uploads/presign        { content_type, purpose }        -> { upload_url, public_url, expires_in_seconds }
```
`purpose` is `review-images` or `support-attachments`. The client PUTs the
file bytes directly to `upload_url` (an object-storage presigned URL, see
docs/HUGGINGFACE_DEPLOYMENT.md §3) — the API server never proxies the file
— then submits `public_url` as e.g. a review's `images` entry. Returns
`UPLOADS_NOT_CONFIGURED` (503) if the backend has no R2/S3 credentials set.

### Admin (role: admin/store_manager, separate router group with RBAC middleware)
```
GET/POST/PATCH/DELETE  /admin/products
GET/POST/PATCH/DELETE  /admin/categories
GET/POST/PATCH         /admin/stores
GET/PATCH              /admin/stores/:id/inventory
GET/PATCH              /admin/orders            (filter, status update, assign courier, cancel)
GET                    /admin/users             (search, view, disable)
GET/POST/PATCH/DELETE  /admin/promo-codes
GET/POST/PATCH/DELETE  /admin/discounts
GET/PATCH              /admin/reviews           (moderate)
GET/POST              /admin/support/conversations
GET                    /admin/dashboard/stats
```

## DTO / model source of truth

Flutter (`freezed` models) and Go (`internal/httpapi/dto`) both derive their
field names/types from `packages/shared/openapi.yaml`. When a field is added
to the DB schema, it must be reflected in the OpenAPI contract before either
client consumes it — this keeps mobile, admin, and backend from drifting.
