package auth

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"
)

// GoogleVerifier validates Google ID tokens through Google's tokeninfo endpoint.
// The server still checks audience against the configured OAuth web client ID;
// never trust email/name/sub before these checks pass.
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
	if v == nil || strings.TrimSpace(v.clientID) == "" {
		return nil, ErrGoogleNotConfigured
	}
	if strings.TrimSpace(idToken) == "" {
		return nil, ErrGoogleTokenInvalid
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, "https://oauth2.googleapis.com/tokeninfo?id_token="+idToken, nil)
	if err != nil {
		return nil, fmt.Errorf("google tokeninfo request: %w", err)
	}

	resp, err := v.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("google tokeninfo request failed: %w", err)
	}
	defer resp.Body.Close()

	var claims struct {
		Aud           string `json:"aud"`
		Sub           string `json:"sub"`
		Email         string `json:"email"`
		EmailVerified string `json:"email_verified"`
		Name          string `json:"name"`
		Picture       string `json:"picture"`
		Exp           string `json:"exp"`
	}
	if err := json.NewDecoder(http.MaxBytesReader(nil, resp.Body, 64<<10)).Decode(&claims); err != nil {
		return nil, fmt.Errorf("decode Google tokeninfo: %w", err)
	}
	if resp.StatusCode != http.StatusOK || claims.Aud != v.clientID || claims.Sub == "" || claims.Email == "" || claims.EmailVerified != "true" {
		return nil, ErrGoogleTokenInvalid
	}
	var exp int64
	if _, err := fmt.Sscan(claims.Exp, &exp); err != nil || exp <= time.Now().Unix() {
		return nil, ErrGoogleTokenInvalid
	}
	return &GoogleIdentity{
		Subject: claims.Sub,
		Email:   strings.ToLower(strings.TrimSpace(claims.Email)),
		Name:    claims.Name,
		Picture: claims.Picture,
	}, nil
}
