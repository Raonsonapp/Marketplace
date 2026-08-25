package otp

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// defaultGatewayBaseURL is the real Telegram Gateway API. Some hosts
// (observed: Hugging Face Spaces) cannot complete a TLS handshake to it at
// all — and, it turns out, to Cloudflare's entire edge network either (a
// Cloudflare Worker relay was tried first; every Cloudflare-fronted host
// tested, not just Telegram, timed out identically — see
// docs/TELEGRAM_RELAY_SETUP.md's history). Google's network was not
// blocked, so NewTelegramGatewaySender's proxy mode targets a Google Apps
// Script relay instead (see docs/TELEGRAM_RELAY_SETUP.md).
const defaultGatewayBaseURL = "https://gatewayapi.telegram.org"

// TelegramGatewaySender delivers OTP codes via Telegram Gateway
// (https://gateway.telegram.org), Telegram's official verification-message
// API. It is the recommended free SMS provider for TajikShop: delivery to a
// phone number that has Telegram installed (the overwhelming majority of
// numbers in Tajikistan/Central Asia and Russia) is free — Telegram only
// charges if it has to fall back to a real SMS, and new accounts start with
// a free credit balance for exactly that fallback case. Unlike Firebase
// Phone Auth, this needs no Google Cloud billing account at all.
//
// Telegram delivers the message; TajikShop still generates, hashes, and
// verifies the code itself (see internal/auth/otp.go) — Telegram is purely
// a delivery channel here, just like an SMS gateway would be, which is why
// this implements the same Sender interface as ConsoleSender.
type TelegramGatewaySender struct {
	token       string
	proxyURL    string // Google Apps Script Web App /exec URL; empty means call Telegram directly
	proxySecret string // sent as a "relay_secret" body field (Apps Script Web Apps can't read custom request headers)
	httpClient  *http.Client
}

// NewTelegramGatewaySender builds a sender using an API token from
// https://gateway.telegram.org (Account -> API access). Keep it out of
// version control; it belongs in TELEGRAM_GATEWAY_TOKEN.
//
// proxyURL, when non-empty, is a Google Apps Script Web App relay URL
// (docs/TELEGRAM_RELAY_SETUP.md) to send requests to instead of Telegram
// directly — some hosts (observed: Hugging Face Spaces) cannot complete a
// TLS handshake to Telegram's own servers, or to Cloudflare's edge network
// (tried first as a relay host, also blocked), on every attempt — a
// network-level block, not something client-side timeout tuning fixes.
// Google's network was reachable, so the relay lives there instead.
// proxySecret is sent as a body field (not a header — Apps Script Web Apps
// don't expose custom request headers to script code) so the relay only
// accepts requests from this backend. Both empty means "call Telegram
// directly", i.e. previous behavior.
func NewTelegramGatewaySender(token, proxyURL, proxySecret string) *TelegramGatewaySender {
	return &TelegramGatewaySender{
		token:       token,
		proxyURL:    proxyURL,
		proxySecret: proxySecret,
		// Observed in production (a Hugging Face Space host): the TCP
		// connection to gatewayapi.telegram.org succeeds but the TLS
		// handshake itself never completes — a longer overall
		// http.Client.Timeout alone didn't help, because
		// http.DefaultTransport's own TLSHandshakeTimeout defaults to 10s
		// and aborts first ("net/http: TLS handshake timeout"), and raising
		// that ceiling to 20s didn't help either (still times out at the
		// new ceiling, every attempt, on a fresh unthrottled number — a
		// network-level block, not slowness). These generous values are
		// kept as a safety margin for the proxy path too, and stay under
		// the mobile app's receiveTimeout (AppConstants.receiveTimeout).
		httpClient: &http.Client{
			Timeout: 25 * time.Second,
			Transport: &http.Transport{
				TLSHandshakeTimeout: 20 * time.Second,
			},
		},
	}
}

type telegramSendRequest struct {
	PhoneNumber string `json:"phone_number"`
	Code        string `json:"code"`
	TTL         int    `json:"ttl"`
}

// relaySendRequest is what's posted to the Apps Script relay: the Telegram
// Gateway payload plus the shared secret as a body field, since the relay
// can't authenticate via a header.
type relaySendRequest struct {
	RelaySecret string `json:"relay_secret"`
	PhoneNumber string `json:"phone_number"`
	Code        string `json:"code"`
	TTL         int    `json:"ttl"`
}

type telegramSendResponse struct {
	OK     bool   `json:"ok"`
	Error  string `json:"error"`
	Result *struct {
		RequestID string `json:"request_id"`
	} `json:"result"`
}

// Send implements Sender: it asks Telegram Gateway to deliver code to
// phone. Telegram embeds code into its own verification message template,
// so the message text itself is not controlled here.
func (t *TelegramGatewaySender) Send(ctx context.Context, phone, code string) error {
	var (
		url        string
		reqBody    []byte
		err        error
		setAuthHdr bool
	)
	if t.proxyURL != "" {
		url = t.proxyURL
		reqBody, err = json.Marshal(relaySendRequest{
			RelaySecret: t.proxySecret,
			PhoneNumber: phone,
			Code:        code,
			TTL:         int(OTPMessageTTL.Seconds()),
		})
	} else {
		url = defaultGatewayBaseURL + "/sendVerificationMessage"
		reqBody, err = json.Marshal(telegramSendRequest{
			PhoneNumber: phone,
			Code:        code,
			TTL:         int(OTPMessageTTL.Seconds()),
		})
		setAuthHdr = true
	}
	if err != nil {
		return fmt.Errorf("otp: marshal telegram gateway request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(reqBody))
	if err != nil {
		return fmt.Errorf("otp: build telegram gateway request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	if setAuthHdr {
		req.Header.Set("Authorization", "Bearer "+t.token)
	}

	resp, err := t.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("otp: telegram gateway request failed: %w", err)
	}
	defer resp.Body.Close()

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("otp: read telegram gateway response: %w", err)
	}

	var out telegramSendResponse
	if err := json.Unmarshal(data, &out); err != nil {
		return fmt.Errorf("otp: decode telegram gateway response: %w", err)
	}
	if !out.OK {
		return fmt.Errorf("otp: telegram gateway declined: %s", out.Error)
	}
	return nil
}

// OTPMessageTTL bounds how long Telegram should keep trying to deliver the
// message; it mirrors the OTP's own expiry so a late-delivered message never
// arrives after the code would be rejected anyway.
const OTPMessageTTL = 5 * time.Minute
