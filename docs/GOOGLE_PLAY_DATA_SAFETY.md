# Google Play Data Safety Form — YouShop

Fill the Play Console "App content → Data safety" section from this table.
Keep it in sync whenever a feature starts collecting a new data type —
Google requires the form to match actual app behavior.

## Does your app collect or share any required user data types?

**Yes.**

## Data types collected

| Data type | Collected | Shared with 3rd parties | Purpose | Optional? |
|---|---|---|---|---|
| Email address | Yes | No | Account creation and login (one-time code), account contact | Required |
| Phone number | Yes | No | Order/delivery contact | Optional |
| Name | Yes | No | Personalization, order/delivery contact | Optional |
| Country of residence | Yes | No | Currency, delivery cities, and which stores are shown (the app serves Tajikistan and Russia) | Required |
| Precise location | Yes (only while placing/tracking a delivery, or using "nearby stores") | No | Determine delivery zone, show nearby stores and estimated delivery time | Optional — manual address entry always works without granting location |
| Delivery addresses | Yes | No | Order fulfillment | Required for delivery orders |
| Order history / purchase activity | Yes | No | Order management, receipts, loyalty (TajBonus), reviews eligibility | Required (core function) |
| App interactions (analytics events) | Yes | No | App functionality, performance | Optional |
| Device/app identifiers (FCM token) | Yes | No | Push notifications about orders/promotions | Optional (user can disable notifications) |
| Photos (review images, support chat attachments) | Yes, if the user attaches one | No | Product reviews, support conversations | Optional |
| Cargo parcel details (description, tracking code, weight) | Yes, if the user registers a parcel | No | Parcel forwarding from China | Optional |

Nothing in this table is sold or shared with third parties for advertising.
Login codes are delivered by email through a Google Apps Script relay, so
the address and the code itself pass through Google's mail infrastructure —
inherent to sending the user their own code. The app sends no SMS and needs
no phone number to sign in.

## Security practices to declare

- Data is encrypted in transit (HTTPS/TLS only, see `docs/DEPLOYMENT.md`).
- Users delete their account in-app at Profile → Settings → Delete account
  (`DELETE /profile`), and can request deletion without signing in at the
  public `/delete-account` page — both routes Google Play requires.
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
