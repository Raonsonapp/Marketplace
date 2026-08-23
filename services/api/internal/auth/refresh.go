package auth

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// ErrSessionNotFound / ErrSessionExpired / ErrSessionRevoked describe why a
// refresh attempt failed.
var (
	ErrSessionNotFound = errors.New("auth: session not found")
	ErrSessionExpired  = errors.New("auth: session expired")
	ErrSessionRevoked  = errors.New("auth: session revoked")
)

// refreshTokenBytes is 256 bits, per docs/SECURITY.md.
const refreshTokenBytes = 32

// GenerateRefreshToken returns a new random opaque refresh token (hex
// encoded) and its SHA-256 hash (hex encoded) for storage. Only the hash is
// ever persisted, matching the "no table stores plaintext ... refresh
// tokens" rule in docs/DATABASE_SCHEMA.md.
func GenerateRefreshToken() (plain string, hash string, err error) {
	buf := make([]byte, refreshTokenBytes)
	if _, err := rand.Read(buf); err != nil {
		return "", "", fmt.Errorf("auth: generate refresh token: %w", err)
	}
	plain = hex.EncodeToString(buf)
	return plain, HashRefreshToken(plain), nil
}

// HashRefreshToken returns the SHA-256 hex digest of a plaintext refresh token.
func HashRefreshToken(plain string) string {
	sum := sha256.Sum256([]byte(plain))
	return hex.EncodeToString(sum[:])
}

// SessionStore is the persistence dependency SessionManager needs from
// internal/repository (kept narrow and defined here so this package has no
// import-time dependency on the repository package).
type SessionStore interface {
	Insert(ctx context.Context, s *models.Session) error
	FindActiveByHash(ctx context.Context, hash string) (*models.Session, error)
	RevokeByID(ctx context.Context, id uuid.UUID) error
	RevokeAllForUser(ctx context.Context, userID uuid.UUID) error
}

// SessionManager issues, verifies, rotates, and revokes refresh-token
// sessions (user_sessions rows), one per device.
type SessionManager struct {
	store SessionStore
	ttl   time.Duration
}

// NewSessionManager builds a SessionManager.
func NewSessionManager(store SessionStore, ttl time.Duration) *SessionManager {
	return &SessionManager{store: store, ttl: ttl}
}

// DeviceInfo captures request metadata recorded on the session row.
type DeviceInfo struct {
	DeviceID   string
	DeviceName string
	IP         string
	UserAgent  string
}

// IssueSession creates a brand-new session (used right after OTP verify).
// It returns the plaintext refresh token to hand back to the client.
func (sm *SessionManager) IssueSession(ctx context.Context, userID uuid.UUID, info DeviceInfo) (plainRefreshToken string, err error) {
	plain, hash, err := GenerateRefreshToken()
	if err != nil {
		return "", err
	}
	session := &models.Session{
		ID:               uuid.New(),
		UserID:           userID,
		RefreshTokenHash: hash,
		ExpiresAt:        time.Now().Add(sm.ttl),
	}
	if info.DeviceID != "" {
		session.DeviceID = &info.DeviceID
	}
	if info.DeviceName != "" {
		session.DeviceName = &info.DeviceName
	}
	if info.IP != "" {
		session.IP = &info.IP
	}
	if info.UserAgent != "" {
		session.UserAgent = &info.UserAgent
	}
	if err := sm.store.Insert(ctx, session); err != nil {
		return "", fmt.Errorf("auth: insert session: %w", err)
	}
	return plain, nil
}

// Rotate validates a plaintext refresh token, revokes it, and issues a new
// one bound to the same user (closing the replay window, per docs/SECURITY.md).
func (sm *SessionManager) Rotate(ctx context.Context, plainRefreshToken string, info DeviceInfo) (userID uuid.UUID, newPlainToken string, err error) {
	hash := HashRefreshToken(plainRefreshToken)
	session, err := sm.store.FindActiveByHash(ctx, hash)
	if err != nil {
		return uuid.Nil, "", err
	}
	if session == nil {
		return uuid.Nil, "", ErrSessionNotFound
	}
	if session.RevokedAt != nil {
		return uuid.Nil, "", ErrSessionRevoked
	}
	if time.Now().After(session.ExpiresAt) {
		return uuid.Nil, "", ErrSessionExpired
	}
	if err := sm.store.RevokeByID(ctx, session.ID); err != nil {
		return uuid.Nil, "", fmt.Errorf("auth: revoke old session: %w", err)
	}
	newPlain, err := sm.IssueSession(ctx, session.UserID, info)
	if err != nil {
		return uuid.Nil, "", err
	}
	return session.UserID, newPlain, nil
}

// Revoke logs a single session out (used by POST /auth/logout).
func (sm *SessionManager) Revoke(ctx context.Context, plainRefreshToken string) error {
	hash := HashRefreshToken(plainRefreshToken)
	session, err := sm.store.FindActiveByHash(ctx, hash)
	if err != nil {
		return err
	}
	if session == nil {
		// Logging out an already-invalid token is a no-op success, not an error.
		return nil
	}
	return sm.store.RevokeByID(ctx, session.ID)
}
