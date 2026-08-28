package service

import (
	"context"
	"fmt"
	"sort"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/geo"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/repository"
)

// CatalogService implements categories/products/stores/search business logic.
type CatalogService struct {
	db         *pgxpool.Pool
	categories *repository.CategoryRepository
	products   *repository.ProductRepository
	stores     *repository.StoreRepository
	inventory  *repository.InventoryRepository
}

// NewCatalogService builds a CatalogService.
func NewCatalogService(db *pgxpool.Pool, categories *repository.CategoryRepository, products *repository.ProductRepository, stores *repository.StoreRepository, inventory *repository.InventoryRepository) *CatalogService {
	return &CatalogService{db: db, categories: categories, products: products, stores: stores, inventory: inventory}
}

// CategoryNode is a category with its children nested, for GET /categories.
type CategoryNode struct {
	Category models.Category
	Children []*CategoryNode
}

// CategoryTree returns every active category arranged into a parent/child tree.
func (s *CatalogService) CategoryTree(ctx context.Context) ([]*CategoryNode, error) {
	flat, err := s.categories.ListActive(ctx, s.db)
	if err != nil {
		return nil, fmt.Errorf("service: list categories: %w", err)
	}
	nodes := make(map[uuid.UUID]*CategoryNode, len(flat))
	for _, c := range flat {
		nodes[c.ID] = &CategoryNode{Category: c}
	}
	var roots []*CategoryNode
	for _, c := range flat {
		n := nodes[c.ID]
		if c.ParentID != nil {
			if parent, ok := nodes[*c.ParentID]; ok {
				parent.Children = append(parent.Children, n)
				continue
			}
		}
		roots = append(roots, n)
	}
	return roots, nil
}

// ProductQuery is the service-level input for GET /products, GET
// /categories/:id/products, and GET /search.
type ProductQuery struct {
	CategoryID  *uuid.UUID
	BrandID     *uuid.UUID
	MinPrice    *money.Money
	MaxPrice    *money.Money
	MinRating   *float64
	HasDiscount *bool
	StoreID     *uuid.UUID
	InStock     *bool
	Search      string
	Sort        string
	Limit       int
	Offset      int
}

// Products lists products for GET /products / GET /search, expanding a
// category filter to include its subcategories.
func (s *CatalogService) Products(ctx context.Context, qy ProductQuery) ([]models.Product, error) {
	f := repository.ProductFilter{
		BrandID:     qy.BrandID,
		MinPrice:    qy.MinPrice,
		MaxPrice:    qy.MaxPrice,
		MinRating:   qy.MinRating,
		HasDiscount: qy.HasDiscount,
		StoreID:     qy.StoreID,
		InStock:     qy.InStock,
		Search:      qy.Search,
		Sort:        qy.Sort,
		Limit:       qy.Limit,
		Offset:      qy.Offset,
	}
	if qy.CategoryID != nil {
		ids, err := s.categories.DescendantIDs(ctx, s.db, *qy.CategoryID)
		if err != nil {
			return nil, fmt.Errorf("service: category descendants: %w", err)
		}
		f.CategoryIDs = ids
	}
	products, err := s.products.List(ctx, s.db, f)
	if err != nil {
		return nil, fmt.Errorf("service: list products: %w", err)
	}
	return products, nil
}

// CategoryProducts lists products in one category (including subcategories)
// for GET /categories/:id/products.
func (s *CatalogService) CategoryProducts(ctx context.Context, categoryID uuid.UUID, storeID *uuid.UUID, sortBy string, limit, offset int) ([]models.Product, error) {
	if _, err := s.categories.GetByID(ctx, s.db, categoryID); err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: get category: %w", err)
	}
	return s.Products(ctx, ProductQuery{CategoryID: &categoryID, StoreID: storeID, Sort: sortBy, Limit: limit, Offset: offset})
}

// ProductDetail returns a product plus up to 6 related products, for GET
// /products/:id.
func (s *CatalogService) ProductDetail(ctx context.Context, id uuid.UUID, storeID *uuid.UUID) (*models.Product, []models.Product, error) {
	p, err := s.products.GetByID(ctx, s.db, id, storeID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, nil, apperr.New(apperr.CodeProductNotFound, nil)
		}
		return nil, nil, fmt.Errorf("service: get product: %w", err)
	}
	related, err := s.products.RelatedByCategory(ctx, s.db, p.CategoryID, p.ID, 6)
	if err != nil {
		return nil, nil, fmt.Errorf("service: related products: %w", err)
	}
	return p, related, nil
}

// ProductByBarcode looks up a product by scanned barcode, for GET /products/barcode/:code.
func (s *CatalogService) ProductByBarcode(ctx context.Context, code string, storeID *uuid.UUID) (*models.Product, error) {
	p, err := s.products.GetByBarcode(ctx, s.db, code, storeID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeProductNotFound, nil)
		}
		return nil, fmt.Errorf("service: get product by barcode: %w", err)
	}
	return p, nil
}

// StoreWithDistance pairs a store with its distance from the query point
// (nil when no lat/lng was supplied).
type StoreWithDistance struct {
	Store      models.Store
	DistanceKM *float64
}

// Stores lists active stores, sorted by distance when lat/lng is given.
func (s *CatalogService) Stores(ctx context.Context, country, city string, lat, lng *float64) ([]StoreWithDistance, error) {
	list, err := s.stores.ListActive(ctx, s.db, NormalizeCountry(country), city)
	if err != nil {
		return nil, fmt.Errorf("service: list stores: %w", err)
	}
	out := make([]StoreWithDistance, len(list))
	for i, st := range list {
		out[i] = StoreWithDistance{Store: st}
		if lat != nil && lng != nil && st.Lat != nil && st.Lng != nil {
			d := geo.HaversineKM(geo.Point{Lat: *lat, Lng: *lng}, geo.Point{Lat: *st.Lat, Lng: *st.Lng})
			out[i].DistanceKM = &d
		}
	}
	if lat != nil && lng != nil {
		sort.SliceStable(out, func(i, j int) bool {
			if out[i].DistanceKM == nil {
				return false
			}
			if out[j].DistanceKM == nil {
				return true
			}
			return *out[i].DistanceKM < *out[j].DistanceKM
		})
	}
	return out, nil
}

// StoreDetail bundles a store with its hours and delivery zones, for GET /stores/:id.
type StoreDetail struct {
	Store models.Store
	Hours []models.StoreHours
	Zones []models.DeliveryZone
}

// StoreDetail returns full detail for one store.
func (s *CatalogService) StoreDetail(ctx context.Context, id uuid.UUID) (*StoreDetail, error) {
	st, err := s.stores.GetByID(ctx, s.db, id)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: get store: %w", err)
	}
	hours, err := s.stores.Hours(ctx, s.db, id)
	if err != nil {
		return nil, fmt.Errorf("service: store hours: %w", err)
	}
	zones, err := s.stores.Zones(ctx, s.db, id)
	if err != nil {
		return nil, fmt.Errorf("service: store zones: %w", err)
	}
	return &StoreDetail{Store: *st, Hours: hours, Zones: zones}, nil
}
