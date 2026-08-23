package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"
)

// FavoriteRepository provides access to the favorites table.
type FavoriteRepository struct{}

// NewFavoriteRepository builds a FavoriteRepository.
func NewFavoriteRepository() *FavoriteRepository { return &FavoriteRepository{} }

// ListProductIDs returns the product ids a user has favorited, most recent first.
func (r *FavoriteRepository) ListProductIDs(ctx context.Context, q Querier, userID uuid.UUID) ([]uuid.UUID, error) {
	rows, err := q.Query(ctx, `SELECT product_id FROM favorites WHERE user_id = $1::uuid ORDER BY created_at DESC`, userID)
	if err != nil {
		return nil, fmt.Errorf("repository: list favorites: %w", err)
	}
	defer rows.Close()
	var out []uuid.UUID
	for rows.Next() {
		var id uuid.UUID
		if err := rows.Scan(&id); err != nil {
			return nil, fmt.Errorf("repository: scan favorite: %w", err)
		}
		out = append(out, id)
	}
	return out, rows.Err()
}

// Add favorites a product for a user (idempotent).
func (r *FavoriteRepository) Add(ctx context.Context, q Querier, userID, productID uuid.UUID) error {
	if _, err := q.Exec(ctx, `
		INSERT INTO favorites (user_id, product_id) VALUES ($1::uuid, $2::uuid)
		ON CONFLICT (user_id, product_id) DO NOTHING`, userID, productID); err != nil {
		return fmt.Errorf("repository: add favorite: %w", err)
	}
	return nil
}

// Remove un-favorites a product for a user (idempotent).
func (r *FavoriteRepository) Remove(ctx context.Context, q Querier, userID, productID uuid.UUID) error {
	if _, err := q.Exec(ctx, `DELETE FROM favorites WHERE user_id = $1::uuid AND product_id = $2::uuid`, userID, productID); err != nil {
		return fmt.Errorf("repository: remove favorite: %w", err)
	}
	return nil
}

// IsFavorite reports whether a user has favorited a product.
func (r *FavoriteRepository) IsFavorite(ctx context.Context, q Querier, userID, productID uuid.UUID) (bool, error) {
	row := q.QueryRow(ctx, `SELECT EXISTS(SELECT 1 FROM favorites WHERE user_id = $1::uuid AND product_id = $2::uuid)`, userID, productID)
	var exists bool
	if err := row.Scan(&exists); err != nil {
		return false, fmt.Errorf("repository: is favorite: %w", err)
	}
	return exists, nil
}
