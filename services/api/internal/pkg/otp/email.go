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

// EmailSender delivers OTP codes by email through the Google Apps Script
// relay (docs/TELEGRAM_RELAY_SETUP.md), which calls Apps Script's built-in
// MailApp.sendEmail from the owner's own Google account.
//
// Why this rather than SMTP or a transactional-email API: this backend's
// host (Hugging Face Spaces) blocks outbound connections to Telegram and to
// Cloudflare's entire edge network, and cloud hosts commonly block outbound
// SMTP ports outright — but Google's network is reachable (that is exactly
// why the OTP relay lives on Apps Script). Reusing the same already-working
// relay keeps email delivery free, needs no API key or billing account, and
// travels a network path this host is known to reach.
//
// Quota, stated plainly: Apps Script's MailApp allows ~100 recipients/day on
// a consumer Gmail account (1500/day on Workspace). That is ample for launch
// but is a real ceiling — past it, sends fail until the daily quota resets.
// Moving to a transactional email API (Resend, Brevo, SES) is the upgrade
// path and only requires a different Sender implementation here.
type EmailSender struct {
	relayURL    string
	relaySecret string
	fromName    string
	httpClient  *http.Client
}

// NewEmailSender builds an EmailSender posting to the Apps Script relay at
// relayURL, authenticated by relaySecret (the same pair used for the
// Telegram Gateway relay — TELEGRAM_GATEWAY_PROXY_URL/_SECRET).
func NewEmailSender(relayURL, relaySecret, fromName string) *EmailSender {
	if fromName == "" {
		fromName = "YouShop"
	}
	return &EmailSender{
		relayURL:    relayURL,
		relaySecret: relaySecret,
		fromName:    fromName,
		httpClient:  &http.Client{Timeout: 25 * time.Second},
	}
}

type relayEmailRequest struct {
	RelaySecret string `json:"relay_secret"`
	Kind        string `json:"kind"`
	To          string `json:"to"`
	Subject     string `json:"subject"`
	Body        string `json:"body"`
	FromName    string `json:"from_name"`
}

type relayEmailResponse struct {
	OK    bool   `json:"ok"`
	Error string `json:"error"`
}

// Send implements Sender: recipient is the user's email address. The code
// is generated, hashed, and verified entirely by this backend's own
// OTPManager (docs/SECURITY.md) — email is only the delivery channel.
func (e *EmailSender) Send(ctx context.Context, recipient, code string) error {
	body, err := json.Marshal(relayEmailRequest{
		RelaySecret: e.relaySecret,
		Kind:        "email",
		To:          recipient,
		Subject:     fmt.Sprintf("%s: рамзи тасдиқ %s", e.fromName, code),
		Body:        e.messageBody(code),
		FromName:    e.fromName,
	})
	if err != nil {
		return fmt.Errorf("otp: marshal email relay request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, e.relayURL, bytes.NewReader(body))
	if err != nil {
		return fmt.Errorf("otp: build email relay request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := e.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("otp: email relay request failed: %w", err)
	}
	defer resp.Body.Close()

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("otp: read email relay response: %w", err)
	}
	var out relayEmailResponse
	if err := json.Unmarshal(data, &out); err != nil {
		return fmt.Errorf("otp: decode email relay response: %w", err)
	}
	if !out.OK {
		return fmt.Errorf("otp: email relay declined: %s", out.Error)
	}
	return nil
}

// messageBody is deliberately plain text in all three app languages —
// Apps Script's MailApp sends it as-is, and a plain multilingual body
// renders correctly in every mail client without HTML/template risk.
func (e *EmailSender) messageBody(code string) string {
	return fmt.Sprintf(
		"Рамзи тасдиқи шумо: %[1]s\n"+
			"Ин рамз %[2]d дақиқа эътибор дорад. Онро ба касе нагӯед.\n\n"+
			"Ваш код подтверждения: %[1]s\n"+
			"Код действителен %[2]d минут. Никому его не сообщайте.\n\n"+
			"Your verification code: %[1]s\n"+
			"It is valid for %[2]d minutes. Do not share it with anyone.\n\n"+
			"— %[3]s",
		code, int(OTPMessageTTL.Minutes()), e.fromName,
	)
}
