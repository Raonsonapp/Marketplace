package auth

import (
	"context"
	"errors"
	"testing"
)

func TestFirebaseVerifier_NotConfigured(t *testing.T) {
	v := NewFirebaseVerifier("")
	if v.Configured() {
		t.Fatalf("expected Configured() to be false for an empty web API key")
	}

	_, _, err := v.VerifyIDToken(context.Background(), "some-token")
	if !errors.Is(err, ErrFirebaseNotConfigured) {
		t.Fatalf("expected ErrFirebaseNotConfigured, got %v", err)
	}
}

func TestFirebaseVerifier_EmptyToken(t *testing.T) {
	v := NewFirebaseVerifier("fake-web-api-key")
	if !v.Configured() {
		t.Fatalf("expected Configured() to be true when a web API key is set")
	}

	_, _, err := v.VerifyIDToken(context.Background(), "")
	if !errors.Is(err, ErrFirebaseTokenInvalid) {
		t.Fatalf("expected ErrFirebaseTokenInvalid for an empty token, got %v", err)
	}
}
