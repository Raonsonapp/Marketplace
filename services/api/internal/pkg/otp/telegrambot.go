package otp

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"tajikshop/api/internal/pkg/apperr"
)

// ChatIDLookup resolves a phone number to the Telegram chat that confirmed
// it, via internal/repository.TelegramLinkLookupAdapter.
type ChatIDLookup interface {
	ChatIDForPhone(ctx context.Context, phone string) (chatID int64, found bool, err error)
}

// TelegramBotSender delivers OTP codes as a message from a regular Telegram
// bot (created via @BotFather — see docs/SMS_PROVIDERS.md), as an
// alternative to TelegramGatewaySender for accounts that already have a bot
// set up and would rather not apply for Telegram Gateway's separate
// business API. Unlike the Gateway, a plain bot can only message a user who
// has already opened a chat with it — so the phone-entry flow first needs
// the user to open the bot via a deep link and press Start (which the
// server's Telegram-updates poller, internal/pkg/telegrambot, turns into a
// phone->chat_id row via lookup.Upsert-backed ChatIDLookup) before a code
// can be delivered. Send returns a CodeTelegramNotLinked apperr — carrying
// that deep link in Details — until that's done.
type TelegramBotSender struct {
	token       string
	botUsername string
	lookup      ChatIDLookup
	httpClient  *http.Client
	baseURL     string // overridable in tests; defaults to the real Bot API
}

// NewTelegramBotSender builds a sender using a BotFather bot token
// (TELEGRAM_BOT_TOKEN) and the bot's @username (TELEGRAM_BOT_USERNAME, used
// to build the t.me deep link).
func NewTelegramBotSender(token, botUsername string, lookup ChatIDLookup) *TelegramBotSender {
	return &TelegramBotSender{
		token:       token,
		botUsername: botUsername,
		lookup:      lookup,
		httpClient:  &http.Client{Timeout: 8 * time.Second},
		baseURL:     "https://api.telegram.org",
	}
}

// DeepLink returns the t.me link that opens the bot with phone pre-encoded
// as the /start payload, for the client to open before retrying Send.
func (t *TelegramBotSender) DeepLink(phone string) string {
	return "https://t.me/" + t.botUsername + "?start=" + EncodeStartPayload(phone)
}

// EncodeStartPayload/DecodePhoneFromStartPayload round-trip a phone number
// through Telegram's /start parameter, which only allows
// [A-Za-z0-9_-]{1,64} — base64url (no padding) fits exactly that alphabet.
func EncodeStartPayload(phone string) string {
	return base64.RawURLEncoding.EncodeToString([]byte(phone))
}

// DecodePhoneFromStartPayload is the inverse of EncodeStartPayload, used by
// internal/pkg/telegrambot's update poller.
func DecodePhoneFromStartPayload(payload string) (string, error) {
	b, err := base64.RawURLEncoding.DecodeString(payload)
	if err != nil {
		return "", fmt.Errorf("otp: decode start payload: %w", err)
	}
	return string(b), nil
}

type telegramBotSendMessageRequest struct {
	ChatID int64  `json:"chat_id"`
	Text   string `json:"text"`
}

type telegramBotAPIResponse struct {
	OK          bool   `json:"ok"`
	Description string `json:"description"`
}

// Send implements Sender: looks up phone's linked chat and messages the
// code there, or returns CodeTelegramNotLinked if the user hasn't opened
// the bot yet.
func (t *TelegramBotSender) Send(ctx context.Context, phone, code string) error {
	chatID, found, err := t.lookup.ChatIDForPhone(ctx, phone)
	if err != nil {
		return fmt.Errorf("otp: telegram bot chat lookup: %w", err)
	}
	if !found {
		return apperr.New(apperr.CodeTelegramNotLinked, map[string]any{
			"deep_link": t.DeepLink(phone),
		})
	}

	text := fmt.Sprintf("YouShop: рамзи тасдиқи шумо %s аст. Онро ба ҳеҷ кас нагӯед.", code)
	body, err := json.Marshal(telegramBotSendMessageRequest{ChatID: chatID, Text: text})
	if err != nil {
		return fmt.Errorf("otp: marshal telegram bot request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		t.baseURL+"/bot"+t.token+"/sendMessage", bytes.NewReader(body))
	if err != nil {
		return fmt.Errorf("otp: build telegram bot request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := t.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("otp: telegram bot request failed: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("otp: read telegram bot response: %w", err)
	}
	var parsed telegramBotAPIResponse
	if err := json.Unmarshal(respBody, &parsed); err != nil {
		return fmt.Errorf("otp: parse telegram bot response: %w", err)
	}
	if !parsed.OK {
		return fmt.Errorf("otp: telegram bot send failed: %s", parsed.Description)
	}
	return nil
}
