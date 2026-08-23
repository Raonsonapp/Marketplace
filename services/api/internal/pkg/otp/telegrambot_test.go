package otp

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"tajikshop/api/internal/pkg/apperr"
)

type fakeChatIDLookup struct {
	chatID int64
	found  bool
	err    error
}

func (f *fakeChatIDLookup) ChatIDForPhone(context.Context, string) (int64, bool, error) {
	return f.chatID, f.found, f.err
}

func TestTelegramBotSender_NotLinked(t *testing.T) {
	sender := NewTelegramBotSender("test-token", "YouShopBot", &fakeChatIDLookup{found: false})

	err := sender.Send(context.Background(), "+992901234567", "042817")
	if err == nil {
		t.Fatalf("expected an error when the phone has no linked chat")
	}
	ae, ok := apperr.As(err)
	if !ok || ae.Code != apperr.CodeTelegramNotLinked {
		t.Fatalf("expected CodeTelegramNotLinked, got %v", err)
	}
	wantLink := "https://t.me/YouShopBot?start=" + EncodeStartPayload("+992901234567")
	if got := ae.Details["deep_link"]; got != wantLink {
		t.Errorf("deep_link = %v, want %v", got, wantLink)
	}
}

func TestTelegramBotSender_Linked(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var body telegramBotSendMessageRequest
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
			t.Fatalf("decode request body: %v", err)
		}
		if body.ChatID != 12345 {
			t.Errorf("chat_id = %d, want 12345", body.ChatID)
		}
		_ = json.NewEncoder(w).Encode(telegramBotAPIResponse{OK: true})
	}))
	defer srv.Close()

	sender := NewTelegramBotSender("test-token", "YouShopBot", &fakeChatIDLookup{chatID: 12345, found: true})
	sender.baseURL = srv.URL

	if err := sender.Send(context.Background(), "+992901234567", "042817"); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestStartPayloadRoundTrip(t *testing.T) {
	phone := "+992901234567"
	payload := EncodeStartPayload(phone)
	got, err := DecodePhoneFromStartPayload(payload)
	if err != nil {
		t.Fatalf("decode: %v", err)
	}
	if got != phone {
		t.Errorf("round-trip = %q, want %q", got, phone)
	}
}
