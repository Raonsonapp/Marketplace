package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// CategoryRepository provides access to the categories table.
type CategoryRepository struct{}

// NewCategoryRepository builds a CategoryRepository.
func NewCategoryRepository() *CategoryRepository { return &CategoryRepository{} }

const categoryColumns = `id, parent_id, name_tj, name_ru, slug, icon_url, sort_order, is_active`

func scanCategory(row interface{ Scan(dest ...any) error }) (*models.Category, error) {
	var c models.Category
	if err := row.Scan(&c.ID, &c.ParentID, &c.NameTJ, &c.NameRU, &c.Slug, &c.IconURL, &c.SortOrder, &c.IsActive); err != nil {
		return nil, err
	}
	return &c, nil
}

// ListActive returns every active category (flat; callers build the tree
// from parent_id).
func (r *CategoryRepository) ListActive(ctx context.Context, q Querier) ([]models.Category, error) {
	rows, err := q.Query(ctx, `SELECT `+categoryColumns+` FROM categories WHERE is_active = true ORDER BY sort_order, name_tj`)
	if err != nil {
		return nil, fmt.Errorf("repository: list categories: %w", err)
	}
	defer rows.Close()
	var out []models.Category
	for rows.Next() {
		c, err := scanCategory(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan category: %w", err)
		}
		out = append(out, *c)
	}
	return out, rows.Err()
}

// GetByID returns a single active category, or ErrNotFound.
func (r *CategoryRepository) GetByID(ctx context.Context, q Querier, id uuid.UUID) (*models.Category, error) {
	row := q.QueryRow(ctx, `SELECT `+categoryColumns+` FROM categories WHERE id = $1::uuid AND is_active = true`, id)
	c, err := scanCategory(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get category: %w", err)
	}
	return c, nil
}

// DescendantIDs returns id plus every category id reachable by following
// parent_id (i.e. all subcategories), used so "products in category X"
// includes its subcategories.
func (r *CategoryRepository) DescendantIDs(ctx context.Context, q Querier, id uuid.UUID) ([]uuid.UUID, error) {
	rows, err := q.Query(ctx, `
		WITH RECURSIVE tree AS (
			SELECT id FROM categories WHERE id = $1::uuid
			UNION ALL
			SELECT c.id FROM categories c JOIN tree t ON c.parent_id = t.id
		)
		SELECT id FROM tree`, id)
	if err != nil {
		return nil, fmt.Errorf("repository: category descendants: %w", err)
	}
	defer rows.Close()
	var out []uuid.UUID
	for rows.Next() {
		var cid uuid.UUID
		if err := rows.Scan(&cid); err != nil {
			return nil, fmt.Errorf("repository: scan descendant id: %w", err)
		}
		out = append(out, cid)
	}
	return out, rows.Err()
}
