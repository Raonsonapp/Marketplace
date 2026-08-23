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

// FavoritesService implements the favorites endpoints.
type FavoritesService struct {
	db        *pgxpool.Pool
	favorites *repository.FavoriteRepository
	products  *repository.ProductRepository
}

// NewFavoritesService builds a FavoritesService.
func NewFavoritesService(db *pgxpool.Pool, favorites *repository.FavoriteRepository, products *repository.ProductRepository) *FavoritesService {
	return &FavoritesService{db: db, favorites: favorites, products: products}
}

// List returns a user's favorited products, most recently favorited first.
func (s *FavoritesService) List(ctx context.Context, userID uuid.UUID) ([]models.Product, error) {
	ids, err := s.favorites.ListProductIDs(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: list favorites: %w", err)
	}
	out := make([]models.Product, 0, len(ids))
	for _, id := range ids {
		p, err := s.products.GetByID(ctx, s.db, id, nil)
		if err != nil {
			continue // product deleted/deactivated since being favorited
		}
		out = append(out, *p)
	}
	return out, nil
}

// Add favorites a product.
func (s *FavoritesService) Add(ctx context.Context, userID, productID uuid.UUID) error {
	if _, err := s.products.GetByID(ctx, s.db, productID, nil); err != nil {
		if err == repository.ErrNotFound {
			return apperr.New(apperr.CodeProductNotFound, nil)
		}
		return fmt.Errorf("service: check product: %w", err)
	}
	return s.favorites.Add(ctx, s.db, userID, productID)
}

// Remove un-favorites a product.
func (s *FavoritesService) Remove(ctx context.Context, userID, productID uuid.UUID) error {
	return s.favorites.Remove(ctx, s.db, userID, productID)
}
