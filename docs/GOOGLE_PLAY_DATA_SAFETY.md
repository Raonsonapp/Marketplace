# Google Play Data Safety Form — TajikShop

Fill the Play Console "App content → Data safety" section from this table.
Keep it in sync whenever a feature starts collecting a new data type —
Google requires the form to match actual app behavior.

## Does your app collect or share any required user data types?

**Yes.**

## Data types collected

| Data type | Collected | Shared with 3rd parties | Purpose | Optional? |
|---|---|---|---|---|
| Phone number | Yes | No | Account creation/login (OTP), order contact | Required |
| Name | Yes | No | Personalization, order/delivery contact | Optional |
| Email address | Yes | No | Account contact (optional profile field) | Optional |
| Precise location | Yes (only while placing/tracking a delivery, or using "nearby stores") | No | Determine delivery zone, show nearby stores and estimated delivery time | Optional — manual address entry always works without granting location |
| Delivery addresses | Yes | No | Order fulfillment | Required for delivery orders |
| Order history / purchase activity | Yes | No | Order management, receipts, loyalty (TajBonus), reviews eligibility | Required (core function) |
| App interactions (analytics events) | Yes | No | App functionality, performance | Optional |
| Device/app identifiers (FCM token) | Yes | No | Push notifications about orders/promotions | Optional (user can disable notifications) |
| Photos (review images, support chat attachments) | Yes, if the user attaches one | No | Product reviews, support conversations | Optional |

Nothing in this table is sold or shared with third parties for advertising.
No data is shared with the Firebase/Telegram Gateway SMS providers beyond
the phone number, which is inherent to sending the user their own OTP code.

## Security practices to declare

- Data is encrypted in transit (HTTPS/TLS only, see `docs/DEPLOYMENT.md`).
- Users can request account/data deletion (Profile → Settings → Delete
  account, once implemented in Phase 6/7 — until then, via support contact
  per `docs/PRIVACY_POLICY.md`).
- OTP codes are never stored in plaintext (`docs/SECURITY.md`).

## Permissions and why (Section 40 of the product brief: minimum necessary)

| Android permission | Requested when | Why |
|---|---|---|
| `INTERNET` | Always | All API/backend communication |
| `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` | User opens "nearby stores" or taps "use my location" during checkout | Show nearby stores and their delivery zones on the map; never requested on app start, and manual address entry remains fully available without it |
| `CAMERA` | User opens the barcode/price scanner | Scan a barcode to look up a product |
| `POST_NOTIFICATIONS` | First time a notification-worthy event would fire | Order status and promotional push notifications (user can turn categories off in Settings) |

No contacts, SMS, microphone, or background-location permissions are
requested, per the product brief's minimum-permissions rule.
