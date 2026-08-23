package models

import (
	"time"

	"github.com/google/uuid"

	"tajikshop/api/internal/pkg/money"
)

// Discount type values, matching promo_codes.discount_type / discounts.discount_type.
const (
	DiscountTypePercentage = "percentage"
	DiscountTypeFixed      = "fixed"
)

// PromoCode mirrors the promo_codes table.
type PromoCode struct {
	ID                   uuid.UUID
	Code                 string
	DiscountType         string
	DiscountValue        money.Money // percentage points as a Money-shaped number when type=percentage
	MinOrderAmount       money.Money
	MaxDiscountAmount    *money.Money
	StartsAt             *time.Time
	EndsAt               *time.Time
	UsageLimit           *int
	PerUserLimit         int
	ApplicableCategories []uuid.UUID
	ApplicableProducts   []uuid.UUID
	ApplicableStores     []uuid.UUID
	IsActive             bool
}

// LoyaltyAccount mirrors loyalty_accounts.
type LoyaltyAccount struct {
	ID             uuid.UUID
	UserID         uuid.UUID
	Balance        money.Money
	LifetimeEarned money.Money
	Tier           string
	UpdatedAt      time.Time
}

// Loyalty ledger entry types, matching loyalty_transactions.type CHECK constraint.
const (
	LoyaltyTxEarn     = "earn"
	LoyaltyTxSpend    = "spend"
	LoyaltyTxExpire   = "expire"
	LoyaltyTxAdjust   = "adjust"
	LoyaltyTxCampaign = "campaign"
)

// LoyaltyTransaction mirrors loyalty_transactions (append-only ledger).
// Invariant: BalanceAfter == priorBalance + Amount, where Amount is signed
// (positive for earn/campaign/adjust-credit, negative for spend/expire).
type LoyaltyTransaction struct {
	ID               uuid.UUID
	LoyaltyAccountID uuid.UUID
	OrderID          *uuid.UUID
	Type             string
	Amount           money.Money
	BalanceAfter     money.Money
	Description      *string
	ExpiresAt        *time.Time
	CreatedAt        time.Time
}
