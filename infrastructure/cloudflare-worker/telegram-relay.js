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
      const probe = async (label, path, init) => {
        const start = Date.now();
        const controller = new AbortController();
        const timeoutID = setTimeout(() => controller.abort(), 12000);
        try {
          const r = await fetch(TELEGRAM_GATEWAY_HOST + path, { ...init, signal: controller.signal });
          const text = await r.text();
          return { label, ok: true, status: r.status, ms: Date.now() - start, body: text.slice(0, 500) };
        } catch (err) {
          return { label, ok: false, error: String(err), ms: Date.now() - start };
        } finally {
          clearTimeout(timeoutID);
        }
      };

      const probes = [
        probe("root_get", "/", {}),
        // No real token here — checks whether the send endpoint itself
        // hangs for any POST, or only once a real, valid token is attached.
        probe("send_post_fake_auth", "/sendVerificationMessage", {
          method: "POST",
          headers: { Authorization: "Bearer fake-token-for-diagnostics", "Content-Type": "application/json" },
          body: JSON.stringify({ phone_number: "+10000000000", code: "000000", ttl: 60 }),
        }),
      ];
      // Optional: set TELEGRAM_GATEWAY_TOKEN as a Worker secret (same value
      // as the backend's) to also probe with the real token — this sends a
      // real verification message, so it uses a fixed test number rather
      // than accepting one from the request.
      if (env.TELEGRAM_GATEWAY_TOKEN) {
        probes.push(
          probe("send_post_real_auth", "/sendVerificationMessage", {
            method: "POST",
            headers: { Authorization: "Bearer " + env.TELEGRAM_GATEWAY_TOKEN, "Content-Type": "application/json" },
            body: JSON.stringify({ phone_number: "+992559994751", code: "000000", ttl: 60 }),
          }),
        );
      }

      const results = await Promise.all(probes);
      return new Response(JSON.stringify({ probes: results }), {
        headers: { "Content-Type": "application/json" },
      });
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
