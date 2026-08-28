package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/repository"
)

// ProfileService implements GET/PATCH/DELETE /profile.
type ProfileService struct {
	db       *pgxpool.Pool
	users    *repository.UserRepository
	sessions *repository.SessionRepository
}

// NewProfileService builds a ProfileService.
func NewProfileService(db *pgxpool.Pool, users *repository.UserRepository, sessions *repository.SessionRepository) *ProfileService {
	return &ProfileService{db: db, users: users, sessions: sessions}
}

// Get returns the authenticated user's profile.
func (s *ProfileService) Get(ctx context.Context, userID uuid.UUID) (*models.User, error) {
	u, err := s.users.GetByID(ctx, s.db, userID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: get profile: %w", err)
	}
	return u, nil
}

// Update applies a partial profile update.
func (s *ProfileService) Update(ctx context.Context, userID uuid.UUID, fullName, email, language, country *string) (*models.User, error) {
	u, err := s.users.UpdateProfile(ctx, s.db, userID, fullName, email, language, country)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		if err == repository.ErrConflict {
			return nil, apperr.New(apperr.CodeEmailTaken, map[string]any{"field": "email"})
		}
		return nil, fmt.Errorf("service: update profile: %w", err)
	}
	return u, nil
}

// Delete retires the caller's account: identifying fields are cleared and
// every session is revoked, so the app on any device the person is still
// signed in on drops to signed-out on its next call.
//
// Google Play requires an in-app deletion path for any app that lets users
// create an account, and the privacy policy states exactly what deletion
// does and does not remove — see internal/legal/privacy_policy.md.
func (s *ProfileService) Delete(ctx context.Context, userID uuid.UUID) error {
	tx, err := s.db.Begin(ctx)
	if err != nil {
		return fmt.Errorf("service: delete profile: begin: %w", err)
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if err := s.users.SoftDelete(ctx, tx, userID); err != nil {
		if err == repository.ErrNotFound {
			return apperr.New(apperr.CodeNotFound, nil)
		}
		return fmt.Errorf("service: delete profile: %w", err)
	}
	// Revoked inside the same transaction as the deletion: an account that
	// is gone must never still have a usable refresh token.
	if err := s.sessions.RevokeAllForUser(ctx, tx, userID); err != nil {
		return fmt.Errorf("service: delete profile: revoke sessions: %w", err)
	}
	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("service: delete profile: commit: %w", err)
	}
	return nil
}
