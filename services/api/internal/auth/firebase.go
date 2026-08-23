package auth

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"time"
)

// FirebaseVerifier verifies a Firebase Phone Authentication ID token and
// extracts the verified phone number. This is the "real free SMS" path
// requested for TajikShop: Firebase's own infrastructure sends the SMS to
// the user's device for free (within Firebase's standard phone-auth quota)
// and performs the actual OTP challenge on the client; the backend's only
// job is to confirm the resulting ID token is genuine before trusting the
// phone number it carries.
//
// This mirrors the verification approach already proven in production by
// the user's github.com/Raonsonapp/TajikShop project (see
// backend/internal/handles/firebase_handler.go there), adapted to this
// service's error/config conventions. It calls the Identity Toolkit
// "accounts:lookup" endpoint with the project's Web API key, which Google
// only returns success for a currently valid, non-expired ID token — an
// invalid/expired/tampered token yields an error response, exactly like a
// local signature check would reject it.
type FirebaseVerifier struct {
	webAPIKey  string
	httpClient *http.Client
}

// NewFirebaseVerifier builds a FirebaseVerifier. webAPIKey is the Firebase
// project's "Web API Key" (Project settings -> General in the Firebase
// console) — not a secret service-account credential, but still only ever
// read from configuration, never hard-coded.
func NewFirebaseVerifier(webAPIKey string) *FirebaseVerifier {
	return &FirebaseVerifier{
		webAPIKey:  webAPIKey,
		httpClient: &http.Client{Timeout: 8 * time.Second},
	}
}

// Configured reports whether a Web API key was supplied. Callers should
// surface a clear "not configured" error instead of attempting a network
// call when this is false.
func (v *FirebaseVerifier) Configured() bool { return v.webAPIKey != "" }

var (
	// ErrFirebaseNotConfigured means no Web API key is set for this
	// environment — Firebase Phone Auth has not been wired up yet.
	ErrFirebaseNotConfigured = errors.New("auth: firebase phone auth is not configured")
	// ErrFirebaseTokenInvalid means Google rejected the ID token (expired,
	// malformed, wrong project, or already revoked).
	ErrFirebaseTokenInvalid = errors.New("auth: invalid firebase id token")
	// ErrFirebasePhoneMissing means the token was valid but had no verified
	// phone number attached (e.g. an email/password Firebase user).
	ErrFirebasePhoneMissing = errors.New("auth: firebase token has no verified phone number")
)

type lookupRequest struct {
	IDToken string `json:"idToken"`
}

type lookupUser struct {
	LocalID     string `json:"localId"`
	PhoneNumber string `json:"phoneNumber"`
}

type lookupResponse struct {
	Users []lookupUser `json:"users"`
	Error *struct {
		Message string `json:"message"`
	} `json:"error"`
}

// VerifyIDToken verifies idToken against Google's Identity Toolkit and
// returns the verified phone number and Firebase UID. Returns
// ErrFirebaseNotConfigured, ErrFirebaseTokenInvalid, or
// ErrFirebasePhoneMissing on failure.
func (v *FirebaseVerifier) VerifyIDToken(ctx context.Context, idToken string) (phone, uid string, err error) {
	if !v.Configured() {
		return "", "", ErrFirebaseNotConfigured
	}
	if idToken == "" {
		return "", "", ErrFirebaseTokenInvalid
	}

	body, err := json.Marshal(lookupRequest{IDToken: idToken})
	if err != nil {
		return "", "", fmt.Errorf("auth: marshal firebase lookup request: %w", err)
	}

	url := "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=" + v.webAPIKey
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(body))
	if err != nil {
		return "", "", fmt.Errorf("auth: build firebase lookup request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := v.httpClient.Do(req)
	if err != nil {
		return "", "", fmt.Errorf("auth: firebase lookup request failed: %w", err)
	}
	defer resp.Body.Close()

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", "", fmt.Errorf("auth: read firebase lookup response: %w", err)
	}

	var out lookupResponse
	if err := json.Unmarshal(data, &out); err != nil {
		return "", "", fmt.Errorf("auth: decode firebase lookup response: %w", err)
	}

	if resp.StatusCode != http.StatusOK || out.Error != nil {
		return "", "", ErrFirebaseTokenInvalid
	}
	if len(out.Users) == 0 {
		return "", "", ErrFirebaseTokenInvalid
	}

	user := out.Users[0]
	if user.PhoneNumber == "" {
		return "", "", ErrFirebasePhoneMissing
	}
	return user.PhoneNumber, user.LocalID, nil
}
