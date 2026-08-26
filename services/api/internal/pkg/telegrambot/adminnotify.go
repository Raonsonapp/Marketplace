package telegrambot

import (
	"bytes"
	"context"
	"encoding/json"
	"log"
	"net/http"
	"time"
)

// AdminNotifier sends free-text operational alerts (new seller application,
// new support message) to a single Telegram chat — the owner's — via the
// bot. It exists because such alerts are the free stand-in for a paid
// email/push notification service (docs/SMS_PROVIDERS.md's "no billing"
// requirement).
//
// Delivery mirrors the OTP path's constraint: some hosts (Hugging Face
// Spaces) can't reach api.telegram.org directly, so when a relay is
// configured (the same Google Apps Script relay used for OTP, see
// docs/TELEGRAM_RELAY_SETUP.md) the message is POSTed there with
// kind="bot_message" and the relay calls the Bot API from Google's network
// instead. With no relay configured it calls api.telegram.org directly
// (fine for hosts that can reach it, e.g. local dev).
//
// Every failure is logged, never returned: a missed admin ping must never
// fail the user action that triggered it.
type AdminNotifier struct {
	botToken    string
	chatID      int64
	proxyURL    string
	proxySecret string
	httpClient  *http.Client
}

// NewAdminNotifier builds an AdminNotifier. chatID is the numeric Telegram
// chat id of the owner (TELEGRAM_ADMIN_CHAT_ID); proxyURL/proxySecret are
// the same values as the OTP relay (empty = call the Bot API directly).
func NewAdminNotifier(botToken string, chatID int64, proxyURL, proxySecret string) *AdminNotifier {
	return &AdminNotifier{
		botToken:    botToken,
		chatID:      chatID,
		proxyURL:    proxyURL,
		proxySecret: proxySecret,
		httpClient:  &http.Client{Timeout: 15 * time.Second},
	}
}

// Enabled reports whether notifications can actually be sent: a chat id is
// always required, plus either a relay or (for direct calls) a bot token.
func (n *AdminNotifier) Enabled() bool {
	return n.chatID != 0 && (n.proxyURL != "" || n.botToken != "")
}

// Notify sends text to the configured admin chat. Safe to call from a
// goroutine with a background context; a no-op (with a debug log) when not
// enabled.
func (n *AdminNotifier) Notify(ctx context.Context, text string) {
	if !n.Enabled() {
		return
	}
	var (
		url     string
		payload []byte
		err     error
	)
	if n.proxyURL != "" {
		url = n.proxyURL
		payload, err = json.Marshal(map[string]any{
			"relay_secret": n.proxySecret,
			"kind":         "bot_message",
			"chat_id":      n.chatID,
			"text":         text,
		})
	} else {
		url = "https://api.telegram.org/bot" + n.botToken + "/sendMessage"
		payload, err = json.Marshal(map[string]any{"chat_id": n.chatID, "text": text})
	}
	if err != nil {
		log.Printf("telegrambot: marshal admin notify: %v", err)
		return
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(payload))
	if err != nil {
		log.Printf("telegrambot: build admin notify: %v", err)
		return
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := n.httpClient.Do(req)
	if err != nil {
		log.Printf("telegrambot: admin notify to %d failed: %v", n.chatID, err)
		return
	}
	defer resp.Body.Close()
	if resp.StatusCode >= 300 {
		log.Printf("telegrambot: admin notify to %d returned %s", n.chatID, resp.Status)
	}
}
