# Firebase Phone Auth Setup — real, free SMS delivery

TajikShop supports two registration/login paths (see `docs/SECURITY.md`):

1. **Console-OTP** (`send-otp` / `verify-otp`) — works out of the box with
   zero external setup; in local dev the code is written to the server log
   instead of an SMS. This is the offline fallback, not a placeholder to be
   deleted — it lets the whole app be developed and tested without any
   third-party account.
2. **Firebase Phone Auth** (`firebase-verify`) — the real path for actual
   SMS delivery to real Tajik `+992` numbers, using Firebase's own SMS
   infrastructure (free within Firebase's standard phone-auth quota — no
   SMS gateway contract needed). This is the path the mobile app's phone
   login screens use once configured.

This document is the "EXTERNAL ACTION REQUIRED" list — nothing here can be
done from inside a coding sandbox, because a Firebase project is tied to
your own Google account. Follow it once and the app's SMS login works for
real.

## 1. Firebase project

You already have a Firebase project for the TajikShop brand
(`github.com/Raonsonapp/TajikShop`, project id `tajikshop`,
project number `940101388450`). Reuse it — do not create a second project
unless you want these two apps fully isolated:

1. Open the [Firebase console](https://console.firebase.google.com/) →
   project **`tajikshop`**.
2. **Authentication → Sign-in method → Phone** → make sure it is **Enabled**.
   (If it's already on for the other app, nothing to do here.)
3. **Project settings → General → Your apps → Add app → Android.**
   Register a **new** Android app with package name **`tj.tajikshop.app`**
   (this project's package — see `docs/DEPLOYMENT.md` §"Android / Google
   Play"). Do not reuse the other app's `com.tajikshop.app` registration;
   Firebase ties config files to the exact package name.
4. Download the generated `google-services.json` for `tj.tajikshop.app` and
   place it at `apps/mobile/android/app/google-services.json` (this file is
   already gitignored by the Flutter template — do not force-add it to a
   public repo).
5. Run `flutterfire configure` from `apps/mobile/` (requires the
   [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup)) and
   select the `tajikshop` project + the `tj.tajikshop.app` Android app. This
   generates `lib/firebase_options.dart`, which `main.dart` expects at
   `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
6. **Project settings → General → Web API Key** → copy that value into the
   backend's `FIREBASE_WEB_API_KEY` environment variable (`.env`, not
   committed). This is a public client identifier, not a secret credential,
   but it still only ever belongs in environment configuration.

> Do not invent project IDs, app IDs, or API keys — use exactly what the
> Firebase console gives you, per app. If you'd rather isolate TajikShop
> grocery from the other TajikShop app entirely, create a brand-new Firebase
> project instead of step 1 and repeat steps 2–6 against it.

## 2. What happens once this is done

- The mobile app's phone entry screen calls Firebase's
  `verifyPhoneNumber`, which sends a real SMS to the device.
- The user enters the code Firebase texted them; the app signs in with
  Firebase locally and gets a Firebase ID token.
- The app sends that ID token to `POST /api/v1/auth/firebase-verify`.
- The backend verifies the token with Google (`internal/auth/firebase.go`),
  extracts the verified phone number, finds-or-creates the TajikShop user,
  and returns the same `access_token`/`refresh_token`/`user` shape as
  `verify-otp` — nothing else in the app needs to know which path was used.

## 3. Costs

Firebase Phone Auth's standard SMS quota is free; very high volume can move
a project onto Firebase's paid phone-auth tier (see the current
[Firebase Authentication pricing](https://firebase.google.com/pricing) for
up-to-date numbers before launch) — for development and a moderate user
base this stays within the free allowance.
