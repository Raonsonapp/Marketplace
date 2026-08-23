# TajikShop — Canonical Enums

Single source of truth for enum values used across the API, database, and
both clients. Never invent a new spelling in one layer without updating this
file and the others.

## User role (`users.role`)
`customer` | `store_manager` | `courier` | `support_agent` | `admin`

## Order status (`orders.status`)
`pending` → `confirmed` → `preparing` → `ready` → `courier_assigned` →
`picked_up` → `delivering` → `delivered`
(`cancelled` reachable from any pre-`delivering` state)

## Payment method (`orders.payment_method`)
`cash_on_delivery` (only implementation today — the field is a free string so
future providers can be added without a migration)

## Payment status (`orders.payment_status`)
`pending` | `paid` | `failed` | `refunded`

## Delivery method (`orders.delivery_method`)
`delivery` | `pickup`

## Discount type (`promo_codes.discount_type`, `discounts.discount_type`)
`percentage` | `fixed`

## Discount scope (`discounts.scope`)
`user` | `category` | `product` | `campaign`

## Loyalty transaction type (`loyalty_transactions.type`)
`earn` | `spend` | `expire` | `adjust` | `campaign`

## Review status (`reviews.status`)
`pending` | `approved` | `hidden`

## Product unit (`products.unit`)
`pcs` | `kg` | `g` | `l` | `ml`

## Notification type (`notifications.type`)
`order_confirmed` | `order_preparing` | `courier_assigned` | `order_delivered`
| `promotion` | `personal_offer` | `bonus_update` | `new_product`

## Language (`users.language`)
`tj` (default) | `ru` | `en` (reserved for future)

## API error codes (`error.code` in the standard error envelope)
`VALIDATION_ERROR` | `UNAUTHORIZED` | `FORBIDDEN` | `NOT_FOUND` |
`OUT_OF_STOCK` | `INVALID_PROMO_CODE` | `PROMO_CODE_EXPIRED` |
`PROMO_CODE_LIMIT_REACHED` | `OTP_INVALID` | `OTP_EXPIRED` |
`OTP_RATE_LIMITED` | `TOKEN_EXPIRED` | `DUPLICATE_REVIEW` |
`REVIEW_REQUIRES_PURCHASE` | `IDEMPOTENCY_CONFLICT` | `INTERNAL_ERROR`
