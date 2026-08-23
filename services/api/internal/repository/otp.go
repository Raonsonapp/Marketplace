package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// OTPRepository provides access to otp_codes and implements auth.OTPStore
// (via OTPStoreAdapter below).
type OTPRepository struct{}

// NewOTPRepository builds an OTPRepository.
func NewOTPRepository() *OTPRepository { return &OTPRepository{} }

// Insert creates a new OTP code row.
func (r *OTPRepository) Insert(ctx context.Context, q Querier, o *models.OTPCode) error {
	row := q.QueryRow(ctx, `
		INSERT INTO otp_codes (id, phone, code_hash, purpose, max_attempts, expires_at)
		VALUES ($1::uuid, $2, $3, $4, $5, $6)
		RETURNING created_at`, o.ID, o.Phone, o.CodeHash, o.Purpose, o.MaxAttempts, o.ExpiresAt)
	if err := row.Scan(&o.CreatedAt); err != nil {
		return fmt.Errorf("repository: insert otp: %w", err)
	}
	return nil
}

// InvalidateActive consumes every not-yet-consumed OTP for phone, enforcing
// "one active OTP per phone" per docs/SECURITY.md.
func (r *OTPRepository) InvalidateActive(ctx context.Context, q Querier, phone string) error {
	if _, err := q.Exec(ctx, `UPDATE otp_codes SET consumed_at = now() WHERE phone = $1 AND consumed_at IS NULL`, phone); err != nil {
		return fmt.Errorf("repository: invalidate otp: %w", err)
	}
	return nil
}

// LatestActive returns the most recent unconsumed OTP for phone (regardless
// of expiry — the caller checks expiry), or nil if none exists.
func (r *OTPRepository) LatestActive(ctx context.Context, q Querier, phone string) (*models.OTPCode, error) {
	row := q.QueryRow(ctx, `
		SELECT id, phone, code_hash, purpose, attempts, max_attempts, expires_at, consumed_at, created_at
		FROM otp_codes WHERE phone = $1 AND consumed_at IS NULL
		ORDER BY created_at DESC LIMIT 1`, phone)
	var o models.OTPCode
	err := row.Scan(&o.ID, &o.Phone, &o.CodeHash, &o.Purpose, &o.Attempts, &o.MaxAttempts, &o.ExpiresAt, &o.ConsumedAt, &o.CreatedAt)
	if isNoRows(err) {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("repository: latest active otp: %w", err)
	}
	return &o, nil
}

// IncrementAttempts bumps the attempt counter on a failed verify.
func (r *OTPRepository) IncrementAttempts(ctx context.Context, q Querier, id uuid.UUID) error {
	if _, err := q.Exec(ctx, `UPDATE otp_codes SET attempts = attempts + 1 WHERE id = $1::uuid`, id); err != nil {
		return fmt.Errorf("repository: increment otp attempts: %w", err)
	}
	return nil
}

// Consume marks an OTP as used on a successful verify.
func (r *OTPRepository) Consume(ctx context.Context, q Querier, id uuid.UUID) error {
	if _, err := q.Exec(ctx, `UPDATE otp_codes SET consumed_at = now() WHERE id = $1::uuid`, id); err != nil {
		return fmt.Errorf("repository: consume otp: %w", err)
	}
	return nil
}

// OTPStoreAdapter binds an OTPRepository to a fixed Querier so it satisfies
// internal/auth.OTPStore.
type OTPStoreAdapter struct {
	Repo *OTPRepository
	DB   Querier
}

// NewOTPStoreAdapter builds an OTPStoreAdapter.
func NewOTPStoreAdapter(repo *OTPRepository, db Querier) *OTPStoreAdapter {
	return &OTPStoreAdapter{Repo: repo, DB: db}
}

func (a *OTPStoreAdapter) Insert(ctx context.Context, o *models.OTPCode) error {
	return a.Repo.Insert(ctx, a.DB, o)
}

func (a *OTPStoreAdapter) InvalidateActive(ctx context.Context, phone string) error {
	return a.Repo.InvalidateActive(ctx, a.DB, phone)
}

func (a *OTPStoreAdapter) LatestActive(ctx context.Context, phone string) (*models.OTPCode, error) {
	return a.Repo.LatestActive(ctx, a.DB, phone)
}

func (a *OTPStoreAdapter) IncrementAttempts(ctx context.Context, id uuid.UUID) error {
	return a.Repo.IncrementAttempts(ctx, a.DB, id)
}

func (a *OTPStoreAdapter) Consume(ctx context.Context, id uuid.UUID) error {
	return a.Repo.Consume(ctx, a.DB, id)
}
