/**
 * Telegram Gateway relay — Cloudflare Worker.
 *
 * Why this exists: some hosts (observed: Hugging Face Spaces) cannot
 * complete a TLS handshake to Telegram's own servers at all — every OTP
 * send attempt times out (net/http: TLS handshake timeout), on every phone
 * number, regardless of how generous the client timeout is. That is a
 * network-level block on the *host*, not something fixable by tuning HTTP
 * client settings. Cloudflare's edge network reaches Telegram fine, so this
 * Worker sits in between: the Go backend calls this Worker instead of
 * gatewayapi.telegram.org directly, and the Worker forwards the request on.
 *
 * Deployment (no CLI needed — see docs/TELEGRAM_RELAY_SETUP.md for the full
 * click-by-click walkthrough):
 *   1. Cloudflare dashboard -> Workers & Pages -> Create -> paste this file.
 *   2. Settings -> Variables and Secrets -> add secret RELAY_SECRET (any
 *      long random string you make up).
 *   3. Deploy, copy the workers.dev URL.
 *   4. On the backend, set TELEGRAM_GATEWAY_PROXY_URL to that URL and
 *      TELEGRAM_GATEWAY_PROXY_SECRET to the same RELAY_SECRET value.
 *
 * Security: requests are rejected unless they carry a matching
 * X-Relay-Secret header, and only the fixed Telegram Gateway host is ever
 * forwarded to — this is not an open proxy.
 */

const TELEGRAM_GATEWAY_HOST = "https://gatewayapi.telegram.org";

export default {
  async fetch(request, env) {
    if (!env.RELAY_SECRET) {
      return new Response("relay misconfigured: RELAY_SECRET not set", { status: 500 });
    }
    if (request.headers.get("X-Relay-Secret") !== env.RELAY_SECRET) {
      return new Response("unauthorized", { status: 401 });
    }

    const url = new URL(request.url);
    const target = TELEGRAM_GATEWAY_HOST + url.pathname + url.search;

    const upstream = await fetch(target, {
      method: request.method,
      headers: {
        Authorization: request.headers.get("Authorization") || "",
        "Content-Type": request.headers.get("Content-Type") || "application/json",
      },
      body: request.method === "GET" || request.method === "HEAD" ? undefined : await request.text(),
    });

    const body = await upstream.text();
    return new Response(body, {
      status: upstream.status,
      headers: { "Content-Type": upstream.headers.get("Content-Type") || "application/json" },
    });
  },
};
