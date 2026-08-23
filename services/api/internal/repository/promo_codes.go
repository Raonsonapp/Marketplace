package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// PromoCodeRepository provides access to promo_codes and promo_code_usage.
type PromoCodeRepository struct{}

// NewPromoCodeRepository builds a PromoCodeRepository.
func NewPromoCodeRepository() *PromoCodeRepository { return &PromoCodeRepository{} }

// scanPromoCodeRow scans one promo_codes row in the column order shared by
// GetActiveByCode and ListActivePublic.
func scanPromoCodeRow(row interface{ Scan(dest ...any) error }) (*models.PromoCode, error) {
	var pc models.PromoCode
	var discountValue, minOrder string
	var maxDiscount *string
	var categories, products, stores []uuid.UUID
	if err := row.Scan(&pc.ID, &pc.Code, &pc.DiscountType, &discountValue, &minOrder, &maxDiscount,
		&pc.StartsAt, &pc.EndsAt, &pc.UsageLimit, &pc.PerUserLimit, &categories, &products, &stores, &pc.IsActive); err != nil {
		return nil, err
	}
	pc.DiscountValue, _ = money.FromString(discountValue)
	pc.MinOrderAmount, _ = money.FromString(minOrder)
	if maxDiscount != nil {
		if m, err := money.FromString(*maxDiscount); err == nil {
			pc.MaxDiscountAmount = &m
		}
	}
	pc.ApplicableCategories = categories
	pc.ApplicableProducts = products
	pc.ApplicableStores = stores
	return &pc, nil
}

// GetActiveByCode returns an active promo code by its code (case-sensitive,
// matching the unique constraint), or ErrNotFound.
func (r *PromoCodeRepository) GetActiveByCode(ctx context.Context, q Querier, code string) (*models.PromoCode, error) {
	row := q.QueryRow(ctx, `
		SELECT id, code, discount_type, discount_value::text, min_order_amount::text, max_discount_amount::text,
		       starts_at, ends_at, usage_limit, per_user_limit, applicable_categories, applicable_products, applicable_stores, is_active
		FROM promo_codes WHERE code = $1 AND is_active = true`, code)
	pc, err := scanPromoCodeRow(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get promo code: %w", err)
	}
	return pc, nil
}

// ListActivePublic returns promo codes that are currently active and inside
// their starts_at/ends_at window, for surfacing on GET /promotions as
// "public" promo codes a customer can discover and apply themselves
// (as opposed to the personal/campaign discounts table).
func (r *PromoCodeRepository) ListActivePublic(ctx context.Context, q Querier, limit, offset int) ([]models.PromoCode, error) {
	rows, err := q.Query(ctx, `
		SELECT id, code, discount_type, discount_value::text, min_order_amount::text, max_discount_amount::text,
		       starts_at, ends_at, usage_limit, per_user_limit, applicable_categories, applicable_products, applicable_stores, is_active
		FROM promo_codes
		WHERE is_active = true
		  AND (starts_at IS NULL OR starts_at <= now())
		  AND (ends_at IS NULL OR ends_at >= now())
		ORDER BY created_at DESC LIMIT $1 OFFSET $2`, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("repository: list active promo codes: %w", err)
	}
	defer rows.Close()
	var out []models.PromoCode
	for rows.Next() {
		pc, err := scanPromoCodeRow(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan promo code: %w", err)
		}
		out = append(out, *pc)
	}
	return out, rows.Err()
}

// CountUsageTotal returns how many orders have ever redeemed a promo code.
func (r *PromoCodeRepository) CountUsageTotal(ctx context.Context, q Querier, promoID uuid.UUID) (int, error) {
	row := q.QueryRow(ctx, `SELECT count(*) FROM promo_code_usage WHERE promo_code_id = $1::uuid`, promoID)
	var n int
	if err := row.Scan(&n); err != nil {
		return 0, fmt.Errorf("repository: count promo usage: %w", err)
	}
	return n, nil
}

// CountUsageByUser returns how many times a specific user has redeemed a promo code.
func (r *PromoCodeRepository) CountUsageByUser(ctx context.Context, q Querier, promoID, userID uuid.UUID) (int, error) {
	row := q.QueryRow(ctx, `SELECT count(*) FROM promo_code_usage WHERE promo_code_id = $1::uuid AND user_id = $2::uuid`, promoID, userID)
	var n int
	if err := row.Scan(&n); err != nil {
		return 0, fmt.Errorf("repository: count user promo usage: %w", err)
	}
	return n, nil
}

// InsertUsage records a promo-code redemption (unique per promo+order,
// enforced by the DB, which is what makes checkout idempotent against
// double-applying a promo to the same order).
func (r *PromoCodeRepository) InsertUsage(ctx context.Context, q Querier, promoID, userID, orderID uuid.UUID) error {
	if _, err := q.Exec(ctx, `
		INSERT INTO promo_code_usage (promo_code_id, user_id, order_id) VALUES ($1::uuid, $2::uuid, $3::uuid)
		ON CONFLICT (promo_code_id, order_id) DO NOTHING`, promoID, userID, orderID); err != nil {
		return fmt.Errorf("repository: insert promo usage: %w", err)
	}
	return nil
}
