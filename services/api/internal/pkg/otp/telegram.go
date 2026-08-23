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
	token      string
	httpClient *http.Client
	baseURL    string // overridable in tests; defaults to the real Gateway API
}

// NewTelegramGatewaySender builds a sender using an API token from
// https://gateway.telegram.org (Account -> API access). Keep it out of
// version control; it belongs in TELEGRAM_GATEWAY_TOKEN.
func NewTelegramGatewaySender(token string) *TelegramGatewaySender {
	return &TelegramGatewaySender{
		token:      token,
		httpClient: &http.Client{Timeout: 8 * time.Second},
		baseURL:    "https://gatewayapi.telegram.org",
	}
}

type telegramSendRequest struct {
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
	body, err := json.Marshal(telegramSendRequest{
		PhoneNumber: phone,
		Code:        code,
		TTL:         int(OTPMessageTTL.Seconds()),
	})
	if err != nil {
		return fmt.Errorf("otp: marshal telegram gateway request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		t.baseURL+"/sendVerificationMessage", bytes.NewReader(body))
	if err != nil {
		return fmt.Errorf("otp: build telegram gateway request: %w", err)
	}
	req.Header.Set("Authorization", "Bearer "+t.token)
	req.Header.Set("Content-Type", "application/json")

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
