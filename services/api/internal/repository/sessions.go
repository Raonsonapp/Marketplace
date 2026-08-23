package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// SessionRepository provides access to user_sessions and implements
// auth.SessionStore.
type SessionRepository struct{}

// NewSessionRepository builds a SessionRepository.
func NewSessionRepository() *SessionRepository { return &SessionRepository{} }

// Insert creates a new session row.
func (r *SessionRepository) Insert(ctx context.Context, q Querier, s *models.Session) error {
	row := q.QueryRow(ctx, `
		INSERT INTO user_sessions (id, user_id, refresh_token_hash, device_id, device_name, ip, user_agent, expires_at)
		VALUES ($1::uuid, $2::uuid, $3, $4, $5, $6::inet, $7, $8)
		RETURNING created_at, last_used_at`,
		s.ID, s.UserID, s.RefreshTokenHash, s.DeviceID, s.DeviceName, nullableInet(s.IP), s.UserAgent, s.ExpiresAt)
	if err := row.Scan(&s.CreatedAt, &s.LastUsedAt); err != nil {
		return fmt.Errorf("repository: insert session: %w", err)
	}
	return nil
}

// nullableInet passes nil through untouched but lets pgx cast a non-empty
// string to inet via the query's explicit ::inet cast.
func nullableInet(s *string) *string { return s }

// FindActiveByHash returns the session for a refresh-token hash regardless
// of revoked/expired state (callers decide what "active" means), or nil if
// no such session exists at all.
func (r *SessionRepository) FindActiveByHash(ctx context.Context, q Querier, hash string) (*models.Session, error) {
	row := q.QueryRow(ctx, `
		SELECT id, user_id, refresh_token_hash, device_id, device_name, ip::text, user_agent, expires_at, revoked_at, created_at, last_used_at
		FROM user_sessions WHERE refresh_token_hash = $1`, hash)
	var s models.Session
	err := row.Scan(&s.ID, &s.UserID, &s.RefreshTokenHash, &s.DeviceID, &s.DeviceName, &s.IP, &s.UserAgent, &s.ExpiresAt, &s.RevokedAt, &s.CreatedAt, &s.LastUsedAt)
	if isNoRows(err) {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("repository: find session by hash: %w", err)
	}
	return &s, nil
}

// RevokeByID marks a session revoked.
func (r *SessionRepository) RevokeByID(ctx context.Context, q Querier, id uuid.UUID) error {
	if _, err := q.Exec(ctx, `UPDATE user_sessions SET revoked_at = now() WHERE id = $1::uuid AND revoked_at IS NULL`, id); err != nil {
		return fmt.Errorf("repository: revoke session: %w", err)
	}
	return nil
}

// RevokeAllForUser revokes every active session for a user (e.g. "log out
// everywhere").
func (r *SessionRepository) RevokeAllForUser(ctx context.Context, q Querier, userID uuid.UUID) error {
	if _, err := q.Exec(ctx, `UPDATE user_sessions SET revoked_at = now() WHERE user_id = $1::uuid AND revoked_at IS NULL`, userID); err != nil {
		return fmt.Errorf("repository: revoke all sessions: %w", err)
	}
	return nil
}

// SessionStoreAdapter binds a SessionRepository to a fixed Querier (the pool)
// so it satisfies internal/auth.SessionStore, whose interface is
// transaction-free (session issuance never needs to participate in the
// order/checkout transaction).
type SessionStoreAdapter struct {
	Repo *SessionRepository
	DB   Querier
}

// NewSessionStoreAdapter builds a SessionStoreAdapter.
func NewSessionStoreAdapter(repo *SessionRepository, db Querier) *SessionStoreAdapter {
	return &SessionStoreAdapter{Repo: repo, DB: db}
}

func (a *SessionStoreAdapter) Insert(ctx context.Context, s *models.Session) error {
	return a.Repo.Insert(ctx, a.DB, s)
}

func (a *SessionStoreAdapter) FindActiveByHash(ctx context.Context, hash string) (*models.Session, error) {
	return a.Repo.FindActiveByHash(ctx, a.DB, hash)
}

func (a *SessionStoreAdapter) RevokeByID(ctx context.Context, id uuid.UUID) error {
	return a.Repo.RevokeByID(ctx, a.DB, id)
}

func (a *SessionStoreAdapter) RevokeAllForUser(ctx context.Context, userID uuid.UUID) error {
	return a.Repo.RevokeAllForUser(ctx, a.DB, userID)
}
