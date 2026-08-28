#!/usr/bin/env bash
#
# Creates the Android upload keystore that signs YouShop's Play releases,
# and prints the four values to paste into GitHub repository secrets.
#
#   ./scripts/make-upload-keystore.sh
#
# Run this on YOUR OWN machine. The .jks it writes is the private key that
# signs every future release of the app: Google Play permanently binds the
# app to it, so if it is lost you cannot ship an update to the same
# listing, only a brand-new one with no installs and no reviews. Back the
# file up somewhere you will still have in five years, and never commit it.
set -euo pipefail

OUT_DIR="${OUT_DIR:-$(pwd)}"
KEYSTORE="${KEYSTORE:-$OUT_DIR/upload-keystore.jks}"
ALIAS="${ALIAS:-upload}"
# 10000 days (~27 years). Play requires the key to outlive the app's
# lifetime; a key that expires makes the listing un-updatable.
VALIDITY="${VALIDITY:-10000}"
DNAME="${DNAME:-CN=YouShop, OU=Mobile, O=YouShop, L=Dushanbe, C=TJ}"

if ! command -v keytool >/dev/null 2>&1; then
  cat >&2 <<'MSG'
keytool not found.

keytool ships with any JDK. If you have Android Studio installed, its
bundled JDK has one; try adding it to PATH:

  macOS:   export PATH="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$PATH"
  Linux:   export PATH="$HOME/android-studio/jbr/bin:$PATH"
  Windows: use scripts/make-upload-keystore.ps1 instead

Otherwise install a JDK (e.g. Temurin 17) and re-run.
MSG
  exit 1
fi

if [ -e "$KEYSTORE" ]; then
  echo "Refusing to overwrite an existing keystore: $KEYSTORE" >&2
  echo "If this is the key your app is already published with, keep it." >&2
  exit 1
fi

# Read the password twice, without echoing it, rather than taking it as an
# argument — an argument would land in the shell history file.
if [ -z "${STORE_PASSWORD:-}" ]; then
  printf 'Choose a keystore password (at least 6 characters): '
  read -rs STORE_PASSWORD
  printf '\nRepeat it: '
  read -rs STORE_PASSWORD_CONFIRM
  printf '\n'
  if [ "$STORE_PASSWORD" != "$STORE_PASSWORD_CONFIRM" ]; then
    echo "Passwords do not match." >&2
    exit 1
  fi
fi
if [ ${#STORE_PASSWORD} -lt 6 ]; then
  echo "keytool requires at least 6 characters." >&2
  exit 1
fi

# One password for both the store and the key: the workflow supports two,
# but a second distinct password buys nothing here and is one more thing to
# lose.
keytool -genkeypair \
  -keystore "$KEYSTORE" \
  -alias "$ALIAS" \
  -keyalg RSA -keysize 2048 \
  -validity "$VALIDITY" \
  -dname "$DNAME" \
  -storepass "$STORE_PASSWORD" \
  -keypass "$STORE_PASSWORD" \
  -storetype PKCS12 >/dev/null

# macOS base64 has no -w flag; both platforms need the output on one line.
if base64 --help 2>&1 | grep -q -- '-w'; then
  KEYSTORE_BASE64=$(base64 -w0 "$KEYSTORE")
else
  KEYSTORE_BASE64=$(base64 "$KEYSTORE" | tr -d '\n')
fi

cat <<MSG

Keystore written to:
  $KEYSTORE

BACK THIS FILE UP NOW, somewhere you will still have in five years.
Losing it means never being able to update the published app again.

--------------------------------------------------------------------------
Add these four repository secrets on GitHub:
  Settings -> Secrets and variables -> Actions -> New repository secret
--------------------------------------------------------------------------

Name:  ANDROID_KEYSTORE_PASSWORD
Value: $STORE_PASSWORD

Name:  ANDROID_KEY_ALIAS
Value: $ALIAS

Name:  ANDROID_KEY_PASSWORD
Value: $STORE_PASSWORD

Name:  ANDROID_KEYSTORE_BASE64
Value: (the single long line below, with no spaces or line breaks)

$KEYSTORE_BASE64

--------------------------------------------------------------------------
The base64 line is also saved next to the keystore for easier copying:
  $KEYSTORE.base64.txt

Delete that .txt once the secret is set — it is the private key in text form.
--------------------------------------------------------------------------
MSG

printf '%s' "$KEYSTORE_BASE64" > "$KEYSTORE.base64.txt"
chmod 600 "$KEYSTORE" "$KEYSTORE.base64.txt"
