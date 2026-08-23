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

// AddressService implements the addresses endpoints, enforcing ownership on
// every operation (docs/SECURITY.md).
type AddressService struct {
	db        *pgxpool.Pool
	addresses *repository.AddressRepository
}

// NewAddressService builds an AddressService.
func NewAddressService(db *pgxpool.Pool, addresses *repository.AddressRepository) *AddressService {
	return &AddressService{db: db, addresses: addresses}
}

// List returns all of a user's addresses.
func (s *AddressService) List(ctx context.Context, userID uuid.UUID) ([]models.Address, error) {
	return s.addresses.List(ctx, s.db, userID)
}

// Create adds a new address for a user.
func (s *AddressService) Create(ctx context.Context, a *models.Address) error {
	if err := s.addresses.Create(ctx, s.db, a); err != nil {
		return fmt.Errorf("service: create address: %w", err)
	}
	return nil
}

// Update applies a partial update to an address the user owns.
func (s *AddressService) Update(ctx context.Context, id, userID uuid.UUID, patch repository.AddressPatch) (*models.Address, error) {
	a, err := s.addresses.Update(ctx, s.db, id, userID, patch)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: update address: %w", err)
	}
	return a, nil
}

// Delete removes an address the user owns.
func (s *AddressService) Delete(ctx context.Context, id, userID uuid.UUID) error {
	if err := s.addresses.Delete(ctx, s.db, id, userID); err != nil {
		if err == repository.ErrNotFound {
			return apperr.New(apperr.CodeNotFound, nil)
		}
		return fmt.Errorf("service: delete address: %w", err)
	}
	return nil
}
