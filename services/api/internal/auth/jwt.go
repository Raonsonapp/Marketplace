// Package auth implements OTP issuance/verification, JWT access tokens, and
// rotating refresh-token sessions per docs/SECURITY.md.
package auth

import (
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

// ErrInvalidToken is returned for any token that fails signature, shape, or
// expiry validation. Callers should map this to apperr.CodeUnauthorized.
var ErrInvalidToken = errors.New("auth: invalid or expired token")

// AccessClaims is the JWT payload for access tokens.
type AccessClaims struct {
	UserID uuid.UUID `json:"uid"`
	Role   string    `json:"role"`
	jwt.RegisteredClaims
}

// TokenManager issues and verifies HS256 access tokens. See
// internal/config.Config's doc comment for why HS256 was chosen over the
// RS256 described in docs/SECURITY.md for this phase.
type TokenManager struct {
	secret    []byte
	accessTTL time.Duration
	issuer    string
}

// NewTokenManager builds a TokenManager.
func NewTokenManager(secret string, accessTTL time.Duration) *TokenManager {
	return &TokenManager{secret: []byte(secret), accessTTL: accessTTL, issuer: "tajikshop-api"}
}

// IssueAccessToken creates a signed access token for the given user/role.
func (tm *TokenManager) IssueAccessToken(userID uuid.UUID, role string) (string, time.Time, error) {
	now := time.Now()
	expiresAt := now.Add(tm.accessTTL)
	claims := AccessClaims{
		UserID: userID,
		Role:   role,
		RegisteredClaims: jwt.RegisteredClaims{
			Issuer:    tm.issuer,
			Subject:   userID.String(),
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(expiresAt),
			ID:        uuid.NewString(),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signed, err := token.SignedString(tm.secret)
	if err != nil {
		return "", time.Time{}, fmt.Errorf("auth: sign token: %w", err)
	}
	return signed, expiresAt, nil
}

// ParseAccessToken validates a token string and returns its claims.
func (tm *TokenManager) ParseAccessToken(tokenStr string) (*AccessClaims, error) {
	claims := &AccessClaims{}
	token, err := jwt.ParseWithClaims(tokenStr, claims, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("auth: unexpected signing method %v", t.Header["alg"])
		}
		return tm.secret, nil
	}, jwt.WithIssuer(tm.issuer), jwt.WithValidMethods([]string{"HS256"}))
	if err != nil || !token.Valid {
		return nil, ErrInvalidToken
	}
	return claims, nil
}
