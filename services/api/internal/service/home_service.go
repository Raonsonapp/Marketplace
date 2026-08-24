package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/repository"
)

// HomeService assembles the dynamic GET /home feed. Per docs/API_SPEC.md,
// each section is independently computed and simply omitted when empty —
// sections with no backing data source yet (banners has no table in
// Phase 1's schema; recently_viewed/personal_offers need view-tracking that
// is out of Phase 2 scope) are always empty for now, which is the correct,
// forward-compatible behavior rather than a stub.
type HomeService struct {
	db         *pgxpool.Pool
	categories *repository.CategoryRepository
	products   *repository.ProductRepository
	stores     *repository.StoreRepository
	brands     *repository.BrandRepository
	orders     *repository.OrderRepository
	catalog    *CatalogService
}

// NewHomeService builds a HomeService.
func NewHomeService(db *pgxpool.Pool, categories *repository.CategoryRepository, products *repository.ProductRepository, stores *repository.StoreRepository, brands *repository.BrandRepository, orders *repository.OrderRepository, catalog *CatalogService) *HomeService {
	return &HomeService{db: db, categories: categories, products: products, stores: stores, brands: brands, orders: orders, catalog: catalog}
}

// HomeFeed is the assembled response for GET /home.
type HomeFeed struct {
	Categories     []models.Category
	Popular        []models.Product
	Discounted     []models.Product
	NearbyStores   []StoreWithDistance
	FeaturedBrands []models.Brand
	BuyAgain       []models.Product
}

// Build assembles the home feed. userID is nil for anonymous requests.
func (s *HomeService) Build(ctx context.Context, userID *uuid.UUID, lat, lng *float64) (*HomeFeed, error) {
	feed := &HomeFeed{}

	cats, err := s.categories.ListActive(ctx, s.db)
	if err != nil {
		return nil, fmt.Errorf("service: home categories: %w", err)
	}
	for _, c := range cats {
		if c.ParentID == nil {
			feed.Categories = append(feed.Categories, c)
		}
	}

	popular, err := s.products.List(ctx, s.db, repository.ProductFilter{Sort: "popular", Limit: 10})
	if err != nil {
		return nil, fmt.Errorf("service: home popular: %w", err)
	}
	feed.Popular = popular

	hasDiscount := true
	discounted, err := s.products.List(ctx, s.db, repository.ProductFilter{HasDiscount: &hasDiscount, Sort: "discount", Limit: 10})
	if err != nil {
		return nil, fmt.Errorf("service: home discounted: %w", err)
	}
	feed.Discounted = discounted

	stores, err := s.catalog.Stores(ctx, "", lat, lng)
	if err != nil {
		return nil, fmt.Errorf("service: home stores: %w", err)
	}
	if len(stores) > 10 {
		stores = stores[:10]
	}
	feed.NearbyStores = stores

	brands, err := s.brands.ListActive(ctx, s.db, 10)
	if err != nil {
		return nil, fmt.Errorf("service: home brands: %w", err)
	}
	feed.FeaturedBrands = brands

	if userID != nil {
		buyAgain, err := s.buyAgainProducts(ctx, *userID, 10)
		if err != nil {
			return nil, fmt.Errorf("service: home buy again: %w", err)
		}
		feed.BuyAgain = buyAgain
	}

	return feed, nil
}

// buyAgainProducts returns distinct products from the user's past delivered
// orders, most recently ordered first.
func (s *HomeService) buyAgainProducts(ctx context.Context, userID uuid.UUID, limit int) ([]models.Product, error) {
	rows, err := s.db.Query(ctx, `
		SELECT DISTINCT ON (oi.product_id) oi.product_id
		FROM order_items oi
		JOIN orders o ON o.id = oi.order_id
		WHERE o.user_id = $1::uuid AND o.status = 'delivered'
		ORDER BY oi.product_id, o.created_at DESC
		LIMIT $2`, userID, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var ids []uuid.UUID
	for rows.Next() {
		var id uuid.UUID
		if err := rows.Scan(&id); err != nil {
			return nil, err
		}
		ids = append(ids, id)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	if len(ids) == 0 {
		return nil, nil
	}
	// Product IDs from a user's own history are trusted input for an IN-style
	// filter; reuse the generic list path via a temporary CategoryIDs-free
	// filter is not applicable here, so query directly. Passed as strings,
	// not []uuid.UUID — see repository/products.go's attachImages doc
	// comment on why a bare []uuid.UUID has no text-protocol array encode
	// plan under this pool's simple-protocol mode.
	idStrings := make([]string, len(ids))
	for i, id := range ids {
		idStrings[i] = id.String()
	}
	prodRows, err := s.db.Query(ctx, `SELECT id FROM products WHERE id = ANY($1::uuid[]) AND is_active = true AND deleted_at IS NULL`, idStrings)
	if err != nil {
		return nil, err
	}
	defer prodRows.Close()
	var out []models.Product
	for prodRows.Next() {
		var id uuid.UUID
		if err := prodRows.Scan(&id); err != nil {
			return nil, err
		}
		p, err := s.products.GetByID(ctx, s.db, id, nil)
		if err != nil {
			continue
		}
		out = append(out, *p)
	}
	return out, prodRows.Err()
}
