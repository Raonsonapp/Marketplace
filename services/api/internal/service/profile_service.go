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

// ProfileService implements GET/PATCH /profile.
type ProfileService struct {
	db    *pgxpool.Pool
	users *repository.UserRepository
}

// NewProfileService builds a ProfileService.
func NewProfileService(db *pgxpool.Pool, users *repository.UserRepository) *ProfileService {
	return &ProfileService{db: db, users: users}
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
func (s *ProfileService) Update(ctx context.Context, userID uuid.UUID, fullName, email, language *string) (*models.User, error) {
	u, err := s.users.UpdateProfile(ctx, s.db, userID, fullName, email, language)
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
