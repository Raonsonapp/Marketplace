# SMS / OTP Delivery Options

TajikShop supports three ways to get an OTP code to a user, chosen so the
app always works and can be upgraded to real SMS with zero code changes —
only environment configuration.

## 1. Console-OTP (default, zero setup)

`send-otp` / `verify-otp` with `otp.ConsoleSender`: the code is written to
the server log instead of sent anywhere. This is what runs when neither of
the options below is configured. Good for local development and CI; not for
real users.

## 2. Telegram Gateway — recommended for production

**Why this one:** it requires no billing account, and delivery is free
whenever the recipient has Telegram installed — which covers the large
majority of phone numbers in Tajikistan, the rest of Central Asia, and
Russia, exactly the regions this app targets. Telegram only charges (from a
small free credit new accounts start with) if it has to fall back to a real
SMS text.

Setup:
1. Open <https://gateway.telegram.org>, sign in with a Telegram account.
2. Create an API token (Account → API access).
3. Set `TELEGRAM_GATEWAY_TOKEN` in the backend's environment.

Once set, `cmd/server/main.go` automatically switches `otp.Sender` from
`ConsoleSender` to `otp.TelegramGatewaySender`
(`internal/pkg/otp/telegram.go`) — no other code changes. The code is still
generated, bcrypt-hashed, and verified entirely by TajikShop's own
`OTPManager` (see `docs/SECURITY.md`); Telegram is purely the delivery
channel, exactly like an SMS gateway would be.

## 3. Firebase Phone Auth — alternative, client-driven

A different shape of integration: instead of TajikShop generating the code,
Firebase's own infrastructure sends and verifies the SMS code on the
device, and the backend (`POST /auth/firebase-verify`) only checks that the
resulting ID token is genuine. See `docs/FIREBASE_SETUP.md` for the full
setup. Worth knowing before choosing this one: Firebase Phone Auth requires
the Firebase project to be on the **Blaze (pay-as-you-go)** plan — a billing
account must be attached even though typical usage stays inside the free
monthly quota. If you'd rather avoid attaching billing at all, use Telegram
Gateway instead; both can also be left enabled side by side, and the mobile
app can offer either as a sign-in option.

## Recommendation

For a Tajikistan-focused launch with no billing account requirement, set
`TELEGRAM_GATEWAY_TOKEN` and leave `FIREBASE_WEB_API_KEY` unset. Both are
already wired end-to-end and require only the environment variable to
switch on.
