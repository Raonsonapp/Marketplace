package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// DiscountRepository provides access to the discounts table (the
// personal/category/product/campaign offers behind GET /promotions).
type DiscountRepository struct{}

// NewDiscountRepository builds a DiscountRepository.
func NewDiscountRepository() *DiscountRepository { return &DiscountRepository{} }

const discountColumns = `id, name, scope, user_id, category_id, product_id, discount_type, discount_value::text,
	starts_at, ends_at, is_active, created_at`

func scanDiscount(row interface{ Scan(dest ...any) error }) (*models.Discount, error) {
	var d models.Discount
	var value string
	if err := row.Scan(&d.ID, &d.Name, &d.Scope, &d.UserID, &d.CategoryID, &d.ProductID, &d.DiscountType, &value,
		&d.StartsAt, &d.EndsAt, &d.IsActive, &d.CreatedAt); err != nil {
		return nil, err
	}
	d.DiscountValue, _ = money.FromString(value)
	return &d, nil
}

// ListActiveForUser returns currently-active discounts visible to userID:
// campaign-scope rows (visible to everyone) plus user-scope rows targeted
// at exactly this user. now()-bounded by starts_at/ends_at, most recent first.
func (r *DiscountRepository) ListActiveForUser(ctx context.Context, q Querier, userID uuid.UUID, limit, offset int) ([]models.Discount, error) {
	rows, err := q.Query(ctx, `
		SELECT `+discountColumns+` FROM discounts
		WHERE is_active = true
		  AND (starts_at IS NULL OR starts_at <= now())
		  AND (ends_at IS NULL OR ends_at >= now())
		  AND (scope = 'campaign' OR (scope = 'user' AND user_id = $1::uuid))
		ORDER BY created_at DESC LIMIT $2 OFFSET $3`, userID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("repository: list active discounts for user: %w", err)
	}
	defer rows.Close()
	return scanDiscounts(rows)
}

// ListActiveCampaigns returns currently-active campaign-scope discounts
// only, for anonymous callers (no user to personalize for).
func (r *DiscountRepository) ListActiveCampaigns(ctx context.Context, q Querier, limit, offset int) ([]models.Discount, error) {
	rows, err := q.Query(ctx, `
		SELECT `+discountColumns+` FROM discounts
		WHERE is_active = true
		  AND (starts_at IS NULL OR starts_at <= now())
		  AND (ends_at IS NULL OR ends_at >= now())
		  AND scope = 'campaign'
		ORDER BY created_at DESC LIMIT $1 OFFSET $2`, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("repository: list active campaign discounts: %w", err)
	}
	defer rows.Close()
	return scanDiscounts(rows)
}

func scanDiscounts(rows interface {
	Next() bool
	Scan(dest ...any) error
	Err() error
}) ([]models.Discount, error) {
	var out []models.Discount
	for rows.Next() {
		d, err := scanDiscount(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan discount: %w", err)
		}
		out = append(out, *d)
	}
	return out, rows.Err()
}
