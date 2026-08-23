package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/repository"
)

// LoyaltyService implements the read-only TajBonus endpoints. All mutation
// happens exclusively inside CheckoutService's order transaction — there is
// intentionally no client-facing endpoint that writes a balance directly.
type LoyaltyService struct {
	db      *pgxpool.Pool
	loyalty *repository.LoyaltyRepository
}

// NewLoyaltyService builds a LoyaltyService.
func NewLoyaltyService(db *pgxpool.Pool, loyalty *repository.LoyaltyRepository) *LoyaltyService {
	return &LoyaltyService{db: db, loyalty: loyalty}
}

// Summary returns balance/tier/lifetime_earned for GET /loyalty.
func (s *LoyaltyService) Summary(ctx context.Context, userID uuid.UUID) (*models.LoyaltyAccount, error) {
	acc, err := s.loyalty.GetOrCreateAccount(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: loyalty summary: %w", err)
	}
	return acc, nil
}

// Transactions returns the ledger for GET /loyalty/transactions.
func (s *LoyaltyService) Transactions(ctx context.Context, userID uuid.UUID, limit, offset int) ([]models.LoyaltyTransaction, error) {
	acc, err := s.loyalty.GetOrCreateAccount(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: loyalty account: %w", err)
	}
	txs, err := s.loyalty.ListTransactions(ctx, s.db, acc.ID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("service: loyalty transactions: %w", err)
	}
	return txs, nil
}
