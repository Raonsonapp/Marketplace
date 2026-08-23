package repository

import (
	"context"
	"fmt"

	"tajikshop/api/internal/models"
)

// BrandRepository provides access to the brands table (used by the home
// feed's "featured_brands" section and product brand names).
type BrandRepository struct{}

// NewBrandRepository builds a BrandRepository.
func NewBrandRepository() *BrandRepository { return &BrandRepository{} }

// ListActive returns up to limit active brands.
func (r *BrandRepository) ListActive(ctx context.Context, q Querier, limit int) ([]models.Brand, error) {
	rows, err := q.Query(ctx, `SELECT id, name, logo_url, is_active FROM brands WHERE is_active = true ORDER BY name LIMIT $1`, limit)
	if err != nil {
		return nil, fmt.Errorf("repository: list brands: %w", err)
	}
	defer rows.Close()
	var out []models.Brand
	for rows.Next() {
		var b models.Brand
		if err := rows.Scan(&b.ID, &b.Name, &b.LogoURL, &b.IsActive); err != nil {
			return nil, fmt.Errorf("repository: scan brand: %w", err)
		}
		out = append(out, b)
	}
	return out, rows.Err()
}
