# SMS / OTP Delivery Options

TajikShop supports four ways to get an OTP code to a user, chosen so the
app always works and can be upgraded to real SMS with zero code changes —
only environment configuration.

## 1. Console-OTP (default, zero setup)

`send-otp` / `verify-otp` with `otp.ConsoleSender`: the code is written to
the server log instead of sent anywhere. This is what runs when none of the
options below is configured. Good for local development and CI; not for
real users.

## 2. Telegram bot — recommended if you already made one

If you already have a bot from [@BotFather](https://t.me/BotFather) (no
separate business signup, unlike Telegram Gateway below), this delivers OTP
codes as a message from that bot.

**The catch:** a plain bot can only message a user who has already opened a
chat with it — there's no API to message an arbitrary phone number cold.
So the first time a phone number is used, the flow is:

1. The mobile app calls `send-otp` as usual.
2. The backend doesn't yet know which Telegram chat that phone belongs to,
   so it returns `TELEGRAM_NOT_LINKED` with a `deep_link` in the error's
   `details` — `https://t.me/<bot_username>?start=<phone, base64url>`.
3. The app opens that link, the user presses **Start** in Telegram.
4. `internal/pkg/telegrambot.Poller` (started automatically in
   `cmd/server/main.go` whenever `TELEGRAM_BOT_TOKEN` is set, long-polling
   `getUpdates` — no public webhook needed) records that phone→chat link
   and replies confirming it in the bot chat.
5. The app retries `send-otp`; this time the backend knows the chat and
   `otp.TelegramBotSender` (`internal/pkg/otp/telegrambot.go`) sends the
   code as a normal bot message. Every OTP after that for the same phone
   number delivers immediately — the Start step is one-time per phone.

Setup:
1. You already have a bot token from BotFather (`123456:ABC-...`) and its
   `@username`.
2. Set `TELEGRAM_BOT_TOKEN` (the token) and `TELEGRAM_BOT_USERNAME` (the
   username, with or without the `@`) in the backend's environment.
3. Redeploy. The server log should show
   `otp: delivering codes via Telegram bot @<username>` on boot.

`TELEGRAM_BOT_TOKEN` takes priority over `TELEGRAM_GATEWAY_TOKEN` below when
both are set.

## 3. Telegram Gateway — no linking step, needs a separate signup

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

**If the backend host can't reach Telegram at all:** some hosts (observed:
Hugging Face Spaces) fail every single request to
`gatewayapi.telegram.org`/`api.telegram.org` with a TLS handshake timeout —
a network-level block on that host, not something fixable by raising
timeouts. If the server log shows `net/http: TLS handshake timeout` (or
`TLS handshake failure`) no matter how long the configured timeout is, see
`docs/TELEGRAM_RELAY_SETUP.md` — a free Google Apps Script relay that
routes around it in about five minutes, no code changes needed on top of
what's already here.

## 4. Firebase Phone Auth — alternative, client-driven

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

For a Tajikistan-focused launch with no billing account requirement: if you
already have a Telegram bot, set `TELEGRAM_BOT_TOKEN`/`TELEGRAM_BOT_USERNAME`
— it's the fastest path from what most people already have. If a one-time
"open the bot and press Start" step per user isn't acceptable, apply for
Telegram Gateway instead and set `TELEGRAM_GATEWAY_TOKEN`. Leave
`FIREBASE_WEB_API_KEY` unset either way unless you specifically want
client-driven Firebase verification. All three are already wired end-to-end
and require only environment variables to switch on.
