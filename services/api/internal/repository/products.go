package repository

import (
	"context"
	"fmt"
	"strings"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// ProductRepository provides access to products, product_images, and the
// per-store inventory join used for live pricing/stock.
type ProductRepository struct{}

// NewProductRepository builds a ProductRepository.
func NewProductRepository() *ProductRepository { return &ProductRepository{} }

// ProductFilter captures every GET /products / GET /search query parameter
// from docs/API_SPEC.md.
type ProductFilter struct {
	CategoryIDs []uuid.UUID // pre-expanded via CategoryRepository.DescendantIDs
	BrandID     *uuid.UUID
	MinPrice    *money.Money
	MaxPrice    *money.Money
	MinRating   *float64
	HasDiscount *bool
	StoreID     *uuid.UUID
	InStock     *bool
	Search      string
	Sort        string // popular|price_asc|price_desc|rating|discount|newest
	Limit       int
	Offset      int
}

// List returns products matching f, using inventory price/stock when
// f.StoreID is set and the catalog-wide base_price/old_price otherwise (per
// docs/DATABASE_SCHEMA.md: inventory, not products.base_price, is what
// checkout reads — but list/browse screens may show either).
func (r *ProductRepository) List(ctx context.Context, q Querier, f ProductFilter) ([]models.Product, error) {
	var b strings.Builder
	args := []any{}
	arg := func(v any) string {
		args = append(args, v)
		return fmt.Sprintf("$%d", len(args))
	}

	priceExpr := "p.base_price"
	oldPriceExpr := "p.old_price"
	stockJoin := ""
	if f.StoreID != nil {
		priceExpr = "i.price"
		oldPriceExpr = "i.old_price"
		stockJoin = "JOIN inventory i ON i.product_id = p.id AND i.store_id = " + arg(*f.StoreID) + "::uuid"
	}

	b.WriteString(fmt.Sprintf(`
		SELECT p.id, p.sku, p.barcode, p.brand_id, br.name, p.category_id, p.name_tj, p.name_ru,
		       p.description_tj, p.description_ru, p.unit, p.weight::text, p.volume::text,
		       %s::text AS price, %s::text AS old_price, p.tags, p.rating_avg::text, p.rating_count,
		       p.is_active, p.created_at
		FROM products p
		LEFT JOIN brands br ON br.id = p.brand_id
		%s
		WHERE p.is_active = true AND p.deleted_at IS NULL`, priceExpr, oldPriceExpr, stockJoin))

	if len(f.CategoryIDs) > 0 {
		// String slice, not []uuid.UUID — see attachImages's doc comment on
		// why a bare []uuid.UUID has no text-protocol array encode plan.
		categoryIDs := make([]string, len(f.CategoryIDs))
		for i, id := range f.CategoryIDs {
			categoryIDs[i] = id.String()
		}
		b.WriteString(fmt.Sprintf(" AND p.category_id = ANY(%s::uuid[])", arg(categoryIDs)))
	}
	if f.BrandID != nil {
		b.WriteString(fmt.Sprintf(" AND p.brand_id = %s::uuid", arg(*f.BrandID)))
	}
	if f.MinPrice != nil {
		b.WriteString(fmt.Sprintf(" AND %s >= %s::numeric", priceExpr, arg(f.MinPrice.String())))
	}
	if f.MaxPrice != nil {
		b.WriteString(fmt.Sprintf(" AND %s <= %s::numeric", priceExpr, arg(f.MaxPrice.String())))
	}
	if f.MinRating != nil {
		b.WriteString(fmt.Sprintf(" AND p.rating_avg >= %s", arg(*f.MinRating)))
	}
	if f.HasDiscount != nil && *f.HasDiscount {
		b.WriteString(fmt.Sprintf(" AND %s IS NOT NULL AND %s > %s", oldPriceExpr, oldPriceExpr, priceExpr))
	}
	if f.StoreID != nil {
		b.WriteString(" AND i.is_available = true")
		if f.InStock != nil && *f.InStock {
			b.WriteString(" AND i.stock_qty > 0")
		}
	} else if f.InStock != nil && *f.InStock {
		b.WriteString(" AND EXISTS (SELECT 1 FROM inventory i2 WHERE i2.product_id = p.id AND i2.is_available = true AND i2.stock_qty > 0)")
	}
	if f.Search != "" {
		term := arg("%" + f.Search + "%")
		b.WriteString(fmt.Sprintf(" AND (p.name_tj ILIKE %s OR p.name_ru ILIKE %s OR p.sku ILIKE %s OR p.barcode ILIKE %s)", term, term, term, term))
	}

	switch f.Sort {
	case "price_asc":
		b.WriteString(fmt.Sprintf(" ORDER BY %s ASC NULLS LAST, p.id", priceExpr))
	case "price_desc":
		b.WriteString(fmt.Sprintf(" ORDER BY %s DESC NULLS LAST, p.id", priceExpr))
	case "rating":
		b.WriteString(" ORDER BY p.rating_avg DESC, p.rating_count DESC, p.id")
	case "discount":
		b.WriteString(fmt.Sprintf(" ORDER BY (CASE WHEN %s IS NOT NULL AND %s > 0 THEN (%s - %s) / %s ELSE 0 END) DESC, p.id", oldPriceExpr, oldPriceExpr, oldPriceExpr, priceExpr, oldPriceExpr))
	case "newest":
		b.WriteString(" ORDER BY p.created_at DESC, p.id")
	default: // "popular"
		b.WriteString(" ORDER BY p.rating_count DESC, p.created_at DESC, p.id")
	}

	limit := f.Limit
	if limit <= 0 {
		limit = 20
	}
	b.WriteString(fmt.Sprintf(" LIMIT %s OFFSET %s", arg(limit), arg(f.Offset)))

	rows, err := q.Query(ctx, b.String(), args...)
	if err != nil {
		return nil, fmt.Errorf("repository: list products: %w", err)
	}
	defer rows.Close()

	var out []models.Product
	for rows.Next() {
		p, priceStr, oldPriceStr, err := scanProductRow(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan product: %w", err)
		}
		if pr, err := money.FromString(priceStr); err == nil {
			p.BasePrice = pr
		}
		if oldPriceStr != nil {
			if op, err := money.FromString(*oldPriceStr); err == nil {
				p.OldPrice = &op
			}
		}
		out = append(out, *p)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	if err := r.attachImages(ctx, q, out); err != nil {
		return nil, err
	}
	return out, nil
}

func scanProductRow(row interface{ Scan(dest ...any) error }) (*models.Product, string, *string, error) {
	var p models.Product
	var priceStr string
	var oldPriceStr *string
	if err := row.Scan(&p.ID, &p.SKU, &p.Barcode, &p.BrandID, &p.BrandName, &p.CategoryID, &p.NameTJ, &p.NameRU,
		&p.DescriptionTJ, &p.DescriptionRU, &p.Unit, &p.Weight, &p.Volume,
		&priceStr, &oldPriceStr, &p.Tags, &p.RatingAvg, &p.RatingCount, &p.IsActive, &p.CreatedAt); err != nil {
		return nil, "", nil, err
	}
	return &p, priceStr, oldPriceStr, nil
}

func (r *ProductRepository) attachImages(ctx context.Context, q Querier, products []models.Product) error {
	if len(products) == 0 {
		return nil
	}
	// IDs are passed as strings, not []uuid.UUID: this pool runs in
	// simple-protocol mode (see NewPostgresPool's doc comment, worked around
	// a Supabase pooler prepared-statement collision), and pgx's
	// simple-protocol text encoder has no default array-literal encoding
	// for a bare []uuid.UUID — every string in the slice does, since
	// uuid.UUID.String() is exactly what ::uuid[] expects.
	ids := make([]string, len(products))
	idx := make(map[uuid.UUID]int, len(products))
	for i, p := range products {
		ids[i] = p.ID.String()
		idx[p.ID] = i
	}
	rows, err := q.Query(ctx, `SELECT product_id, url FROM product_images WHERE product_id = ANY($1::uuid[]) ORDER BY product_id, sort_order`, ids)
	if err != nil {
		return fmt.Errorf("repository: product images: %w", err)
	}
	defer rows.Close()
	for rows.Next() {
		var pid uuid.UUID
		var url string
		if err := rows.Scan(&pid, &url); err != nil {
			return fmt.Errorf("repository: scan product image: %w", err)
		}
		if i, ok := idx[pid]; ok {
			products[i].Images = append(products[i].Images, url)
		}
	}
	return rows.Err()
}

// GetByID returns one active product with images attached, or ErrNotFound.
func (r *ProductRepository) GetByID(ctx context.Context, q Querier, id uuid.UUID, storeID *uuid.UUID) (*models.Product, error) {
	priceExpr, oldPriceExpr, join, joinArgs := "p.base_price", "p.old_price", "", []any{}
	args := []any{id}
	if storeID != nil {
		priceExpr, oldPriceExpr = "i.price", "i.old_price"
		join = "JOIN inventory i ON i.product_id = p.id AND i.store_id = $2::uuid"
		joinArgs = append(joinArgs, *storeID)
	}
	args = append(args, joinArgs...)

	sqlStr := fmt.Sprintf(`
		SELECT p.id, p.sku, p.barcode, p.brand_id, br.name, p.category_id, p.name_tj, p.name_ru,
		       p.description_tj, p.description_ru, p.unit, p.weight::text, p.volume::text,
		       %s::text AS price, %s::text AS old_price, p.tags, p.rating_avg::text, p.rating_count,
		       p.is_active, p.created_at
		FROM products p
		LEFT JOIN brands br ON br.id = p.brand_id
		%s
		WHERE p.id = $1::uuid AND p.is_active = true AND p.deleted_at IS NULL`, priceExpr, oldPriceExpr, join)

	row := q.QueryRow(ctx, sqlStr, args...)
	p, priceStr, oldPriceStr, err := scanProductRow(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get product: %w", err)
	}
	if pr, err := money.FromString(priceStr); err == nil {
		p.BasePrice = pr
	}
	if oldPriceStr != nil {
		if op, err := money.FromString(*oldPriceStr); err == nil {
			p.OldPrice = &op
		}
	}
	one := []models.Product{*p}
	if err := r.attachImages(ctx, q, one); err != nil {
		return nil, err
	}
	return &one[0], nil
}

// GetByBarcode looks up a product by its scanned barcode.
func (r *ProductRepository) GetByBarcode(ctx context.Context, q Querier, barcode string, storeID *uuid.UUID) (*models.Product, error) {
	row := q.QueryRow(ctx, `SELECT id FROM products WHERE barcode = $1 AND is_active = true AND deleted_at IS NULL LIMIT 1`, barcode)
	var id uuid.UUID
	err := row.Scan(&id)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: barcode lookup: %w", err)
	}
	return r.GetByID(ctx, q, id, storeID)
}

// RelatedByCategory returns up to limit other active products in the same
// category as excludeProductID, for the product-detail "similar products"
// section.
func (r *ProductRepository) RelatedByCategory(ctx context.Context, q Querier, categoryID, excludeProductID uuid.UUID, limit int) ([]models.Product, error) {
	all, err := r.List(ctx, q, ProductFilter{CategoryIDs: []uuid.UUID{categoryID}, Limit: limit + 1, Sort: "popular"})
	if err != nil {
		return nil, err
	}
	out := make([]models.Product, 0, limit)
	for _, p := range all {
		if p.ID == excludeProductID {
			continue
		}
		out = append(out, p)
		if len(out) == limit {
			break
		}
	}
	return out, nil
}
