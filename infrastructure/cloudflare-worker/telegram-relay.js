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
    const url = new URL(request.url);

    // No secret needed — a read-only connectivity probe you can open
    // directly in a phone browser (no app, no backend, no OTP rate limit)
    // to see whether *Cloudflare itself* can reach Telegram, independent of
    // whether the relay call from the backend is set up correctly.
    if (url.pathname === "/__debug") {
      const start = Date.now();
      const controller = new AbortController();
      const timeoutID = setTimeout(() => controller.abort(), 8000);
      try {
        const r = await fetch(TELEGRAM_GATEWAY_HOST + "/", { signal: controller.signal });
        clearTimeout(timeoutID);
        return new Response(
          JSON.stringify({ ok: true, status: r.status, ms: Date.now() - start }),
          { headers: { "Content-Type": "application/json" } },
        );
      } catch (err) {
        clearTimeout(timeoutID);
        return new Response(
          JSON.stringify({ ok: false, error: String(err), ms: Date.now() - start }),
          { status: 502, headers: { "Content-Type": "application/json" } },
        );
      }
    }

    if (!env.RELAY_SECRET) {
      return new Response("relay misconfigured: RELAY_SECRET not set", { status: 500 });
    }
    if (request.headers.get("X-Relay-Secret") !== env.RELAY_SECRET) {
      return new Response("unauthorized", { status: 401 });
    }

    const target = TELEGRAM_GATEWAY_HOST + url.pathname + url.search;

    // A bounded timeout turns a hang into a clean JSON error instead of the
    // Workers runtime silently killing the isolate and dropping the
    // connection (which the Go backend sees as an opaque "EOF" with no way
    // to tell a Cloudflare-side problem from a Telegram-side one).
    const controller = new AbortController();
    const timeoutID = setTimeout(() => controller.abort(), 15000);
    try {
      const upstream = await fetch(target, {
        method: request.method,
        headers: {
          Authorization: request.headers.get("Authorization") || "",
          "Content-Type": request.headers.get("Content-Type") || "application/json",
        },
        body: request.method === "GET" || request.method === "HEAD" ? undefined : await request.text(),
        signal: controller.signal,
      });

      const body = await upstream.text();
      return new Response(body, {
        status: upstream.status,
        headers: { "Content-Type": upstream.headers.get("Content-Type") || "application/json" },
      });
    } catch (err) {
      return new Response(
        JSON.stringify({ ok: false, error: "relay: upstream fetch to Telegram failed: " + String(err) }),
        { status: 502, headers: { "Content-Type": "application/json" } },
      );
    } finally {
      clearTimeout(timeoutID);
    }
  },
};
