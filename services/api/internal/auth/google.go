package auth

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

// GoogleVerifier validates Google ID tokens and checks the configured OAuth
// client audience before identity claims are trusted.
type GoogleVerifier struct {
	clientID string
	client   *http.Client
}

func NewGoogleVerifier(clientID string) *GoogleVerifier {
	return &GoogleVerifier{
		clientID: strings.TrimSpace(clientID),
		client:   &http.Client{Timeout: 8 * time.Second},
	}
}

var (
	ErrGoogleNotConfigured = errors.New("auth: Google Sign-In is not configured")
	ErrGoogleTokenInvalid  = errors.New("auth: invalid Google ID token")
)

type GoogleIdentity struct {
	Subject string
	Email   string
	Name    string
	Picture string
}

func (v *GoogleVerifier) VerifyIDToken(ctx context.Context, idToken string) (*GoogleIdentity, error) {
	if v == nil || v.clientID == "" {
		return nil, ErrGoogleNotConfigured
	}
	if strings.TrimSpace(idToken) == "" {
		return nil, ErrGoogleTokenInvalid
	}
	endpoint := "https://oauth2.googleapis.com/tokeninfo?id_token=" + url.QueryEscape(idToken)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return nil, fmt.Errorf("build Google token verification request: %w", err)
	}
	resp, err := v.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("Google token verification request failed: %w", err)
	}
	defer resp.Body.Close()

	var claims struct {
		Aud           string `json:"aud"`
		Sub           string `json:"sub"`
		Email         string `json:"email"`
		EmailVerified string `json:"email_verified"`
		Name          string `json:"name"`
		Picture       string `json:"picture"`
		Exp           int64  `json:"exp"`
	}
	if err := json.NewDecoder(io.LimitReader(resp.Body, 64<<10)).Decode(&claims); err != nil {
		return nil, fmt.Errorf("decode Google token verification response: %w", err)
	}
	if resp.StatusCode != http.StatusOK || claims.Aud != v.clientID || claims.Sub == "" ||
		claims.Email == "" || claims.EmailVerified != "true" || claims.Exp <= time.Now().Unix() {
		return nil, ErrGoogleTokenInvalid
	}
	return &GoogleIdentity{
		Subject: claims.Sub,
		Email:   strings.ToLower(strings.TrimSpace(claims.Email)),
		Name:    claims.Name,
		Picture: claims.Picture,
	}, nil
}
