/**
 * Telegram Gateway relay — Google Apps Script Web App.
 *
 * Why this exists: some hosts (observed: Hugging Face Spaces) cannot reach
 * Telegram's servers at all — every OTP send attempt times out, on every
 * phone number, regardless of client timeout. A Cloudflare Worker relay was
 * tried first, but the same host turned out to have Cloudflare's entire
 * edge network blocked too (cloudflare.com and discord.com timed out
 * identically, not just Telegram and workers.dev) — so a Cloudflare-hosted
 * relay could never have worked, custom domain or not. Google's network was
 * reachable from that same host, so this relay lives on Google Apps Script
 * instead: completely free, no billing account, deployed from
 * script.google.com with nothing but a Google account.
 *
 * Unlike a Cloudflare Worker, an Apps Script Web App cannot read arbitrary
 * incoming request headers — so the shared secret and the Telegram Gateway
 * token are handled differently here than in the (now unused) Cloudflare
 * version: the secret travels as a "relay_secret" field in the JSON body,
 * and the Telegram Gateway token lives only in this script's own Script
 * Properties, never sent from the backend at all.
 *
 * Deployment — see docs/TELEGRAM_RELAY_SETUP.md for the full walkthrough:
 *   1. script.google.com -> New project -> paste this file's contents.
 *   2. Project Settings (gear icon) -> Script Properties -> add
 *      RELAY_SECRET and TELEGRAM_GATEWAY_TOKEN.
 *   3. Deploy -> New deployment -> type "Web app" -> Execute as: Me ->
 *      Who has access: Anyone -> Deploy -> copy the /exec URL.
 *   4. On the backend, set TELEGRAM_GATEWAY_PROXY_URL to that URL and
 *      TELEGRAM_GATEWAY_PROXY_SECRET to the same RELAY_SECRET value.
 */

var TELEGRAM_GATEWAY_HOST = "https://gatewayapi.telegram.org";

function doPost(e) {
  var props = PropertiesService.getScriptProperties();
  var relaySecret = props.getProperty("RELAY_SECRET");
  var telegramToken = props.getProperty("TELEGRAM_GATEWAY_TOKEN");

  var body;
  try {
    body = JSON.parse(e.postData.contents);
  } catch (err) {
    return jsonResponse({ ok: false, error: "relay: invalid JSON body" });
  }

  if (!relaySecret || body.relay_secret !== relaySecret) {
    return jsonResponse({ ok: false, error: "relay: unauthorized" });
  }
  if (!telegramToken) {
    return jsonResponse({ ok: false, error: "relay: TELEGRAM_GATEWAY_TOKEN not configured" });
  }

  var payload = {
    phone_number: body.phone_number,
    code: body.code,
    ttl: body.ttl,
  };

  var response = UrlFetchApp.fetch(TELEGRAM_GATEWAY_HOST + "/sendVerificationMessage", {
    method: "post",
    contentType: "application/json",
    headers: { Authorization: "Bearer " + telegramToken },
    payload: JSON.stringify(payload),
    muteHttpExceptions: true,
  });

  return ContentService.createTextOutput(response.getContentText()).setMimeType(
    ContentService.MimeType.JSON,
  );
}

function jsonResponse(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON);
}
