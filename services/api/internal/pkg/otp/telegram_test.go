package otp

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestTelegramGatewaySender_Success(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if got := r.Header.Get("Authorization"); got != "Bearer test-token" {
			t.Errorf("expected Authorization header, got %q", got)
		}
		var body telegramSendRequest
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
			t.Fatalf("decode request body: %v", err)
		}
		if body.PhoneNumber != "+992901234567" || body.Code != "042817" {
			t.Errorf("unexpected request body: %+v", body)
		}
		_ = json.NewEncoder(w).Encode(telegramSendResponse{OK: true})
	}))
	defer srv.Close()

	sender := NewTelegramGatewaySender("test-token", "", "")
	sender.baseURL = srv.URL

	if err := sender.Send(context.Background(), "+992901234567", "042817"); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestTelegramGatewaySender_Declined(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_ = json.NewEncoder(w).Encode(telegramSendResponse{OK: false, Error: "PHONE_NUMBER_INVALID"})
	}))
	defer srv.Close()

	sender := NewTelegramGatewaySender("test-token", "", "")
	sender.baseURL = srv.URL

	if err := sender.Send(context.Background(), "not-a-phone", "042817"); err == nil {
		t.Fatalf("expected an error when the gateway declines the request")
	}
}
