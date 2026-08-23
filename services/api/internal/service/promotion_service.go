package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/repository"
)

// PromotionService implements GET /promotions: the active
// campaign/personal-offer feed. Promo code *validation* lives on
// CheckoutService (ValidatePromoCode) since it needs the cart-pricing
// helpers already there; this service only surfaces what's currently active.
type PromotionService struct {
	db        *pgxpool.Pool
	discounts *repository.DiscountRepository
	promos    *repository.PromoCodeRepository
}

// NewPromotionService builds a PromotionService.
func NewPromotionService(db *pgxpool.Pool, discounts *repository.DiscountRepository, promos *repository.PromoCodeRepository) *PromotionService {
	return &PromotionService{db: db, discounts: discounts, promos: promos}
}

// Promotions bundles both feeds that make up GET /promotions.
type Promotions struct {
	Discounts  []models.Discount
	PromoCodes []models.PromoCode
}

// List returns the currently-active promotions feed: campaign-scope
// discounts (and, when userID is non-nil, personal user-scope discounts
// targeted at that user) plus currently-active public promo codes.
func (s *PromotionService) List(ctx context.Context, userID *uuid.UUID, limit, offset int) (*Promotions, error) {
	var discounts []models.Discount
	var err error
	if userID != nil {
		discounts, err = s.discounts.ListActiveForUser(ctx, s.db, *userID, limit, offset)
	} else {
		discounts, err = s.discounts.ListActiveCampaigns(ctx, s.db, limit, offset)
	}
	if err != nil {
		return nil, fmt.Errorf("service: list discounts: %w", err)
	}

	promoCodes, err := s.promos.ListActivePublic(ctx, s.db, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("service: list promo codes: %w", err)
	}

	return &Promotions{Discounts: discounts, PromoCodes: promoCodes}, nil
}
