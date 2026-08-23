package httpapi

import (
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/pkg/pagination"
	"tajikshop/api/internal/service"
)

// CatalogHandler implements GET /home, /categories*, /stores*, /products*, /search.
type CatalogHandler struct {
	catalog *service.CatalogService
	home    *service.HomeService
}

// NewCatalogHandler builds a CatalogHandler.
func NewCatalogHandler(catalog *service.CatalogService, home *service.HomeService) *CatalogHandler {
	return &CatalogHandler{catalog: catalog, home: home}
}

func optionalFloat(c *gin.Context, key string) *float64 {
	v := c.Query(key)
	if v == "" {
		return nil
	}
	f, err := strconv.ParseFloat(v, 64)
	if err != nil {
		return nil
	}
	return &f
}

func optionalMoney(c *gin.Context, key string) *money.Money {
	v := c.Query(key)
	if v == "" {
		return nil
	}
	m, err := money.FromString(v)
	if err != nil {
		return nil
	}
	return &m
}

func optionalBool(c *gin.Context, key string) *bool {
	v := c.Query(key)
	if v == "" {
		return nil
	}
	b := v == "true" || v == "1"
	return &b
}

// optionalUUID returns a pointer to the parsed UUID from query param key, or
// nil if the param is absent or malformed (malformed is treated as "no
// filter" rather than a hard error for optional query params).
func optionalUUID(c *gin.Context, key string) *uuid.UUID {
	v := c.Query(key)
	if v == "" {
		return nil
	}
	id, ok := dto.ParseUUID(v)
	if !ok {
		return nil
	}
	return &id
}

// Home handles GET /home.
func (h *CatalogHandler) Home(c *gin.Context) {
	lang := httpctx.Lang(c)
	var userIDPtr *uuid.UUID
	if uid, ok := httpctx.UserID(c); ok {
		userIDPtr = &uid
	}
	lat := optionalFloat(c, "lat")
	lng := optionalFloat(c, "lng")
	feed, err := h.home.Build(c.Request.Context(), userIDPtr, lat, lng)
	if err != nil {
		handleErr(c, err)
		return
	}
	resp := dto.HomeResponse{
		Popular:    dto.NewProductListResponse(feed.Popular, lang),
		Discounted: dto.NewProductListResponse(feed.Discounted, lang),
		BuyAgain:   dto.NewProductListResponse(feed.BuyAgain, lang),
	}
	for _, cat := range feed.Categories {
		resp.Categories = append(resp.Categories, dto.NewCategoryResponse(cat, lang))
	}
	for _, sd := range feed.NearbyStores {
		resp.NearbyStores = append(resp.NearbyStores, dto.NewStoreResponse(sd))
	}
	for _, b := range feed.FeaturedBrands {
		resp.FeaturedBrands = append(resp.FeaturedBrands, dto.NewBrandResponse(b))
	}
	ok(c, resp)
}

// Categories handles GET /categories.
func (h *CatalogHandler) Categories(c *gin.Context) {
	lang := httpctx.Lang(c)
	tree, err := h.catalog.CategoryTree(c.Request.Context())
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, gin.H{"data": dto.NewCategoryTreeResponse(tree, lang)})
}

// CategoryProducts handles GET /categories/:id/products.
func (h *CatalogHandler) CategoryProducts(c *gin.Context) {
	lang := httpctx.Lang(c)
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	storeID := optionalUUID(c, "store_id")
	limit := queryLimit(c)
	offset := queryOffset(c)
	products, err := h.catalog.CategoryProducts(c.Request.Context(), id, storeID, c.Query("sort"), limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewProductListResponse(products, lang), pagination.NextCursor(offset, limit, len(products)))
}

// Stores handles GET /stores.
func (h *CatalogHandler) Stores(c *gin.Context) {
	lat := optionalFloat(c, "lat")
	lng := optionalFloat(c, "lng")
	stores, err := h.catalog.Stores(c.Request.Context(), c.Query("city"), lat, lng)
	if err != nil {
		handleErr(c, err)
		return
	}
	out := make([]dto.StoreResponse, len(stores))
	for i, sd := range stores {
		out[i] = dto.NewStoreResponse(sd)
	}
	ok(c, gin.H{"data": out})
}

// StoreDetail handles GET /stores/:id.
func (h *CatalogHandler) StoreDetail(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	detail, err := h.catalog.StoreDetail(c.Request.Context(), id)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewStoreDetailResponse(detail))
}

func buildProductQuery(c *gin.Context) service.ProductQuery {
	qy := service.ProductQuery{
		MinPrice:    optionalMoney(c, "min_price"),
		MaxPrice:    optionalMoney(c, "max_price"),
		HasDiscount: optionalBool(c, "has_discount"),
		InStock:     optionalBool(c, "in_stock"),
		Sort:        c.Query("sort"),
		Limit:       queryLimit(c),
		Offset:      queryOffset(c),
		Search:      c.Query("q"),
		MinRating:   optionalFloat(c, "min_rating"),
		CategoryID:  optionalUUID(c, "category_id"),
		BrandID:     optionalUUID(c, "brand_id"),
		StoreID:     optionalUUID(c, "store_id"),
	}
	return qy
}

// Products handles GET /products.
func (h *CatalogHandler) Products(c *gin.Context) {
	lang := httpctx.Lang(c)
	qy := buildProductQuery(c)
	products, err := h.catalog.Products(c.Request.Context(), qy)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewProductListResponse(products, lang), pagination.NextCursor(qy.Offset, qy.Limit, len(products)))
}

// Search handles GET /search (same filter/sort/cursor contract as
// GET /products, plus the free-text `q` parameter).
func (h *CatalogHandler) Search(c *gin.Context) {
	h.Products(c)
}

// ProductDetail handles GET /products/:id.
func (h *CatalogHandler) ProductDetail(c *gin.Context) {
	lang := httpctx.Lang(c)
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	storeID := optionalUUID(c, "store_id")
	p, related, err := h.catalog.ProductDetail(c.Request.Context(), id, storeID)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.ProductDetailResponse{ProductResponse: dto.NewProductResponse(*p, lang), Related: dto.NewProductListResponse(related, lang)})
}

// ProductByBarcode handles GET /products/barcode/:code.
func (h *CatalogHandler) ProductByBarcode(c *gin.Context) {
	lang := httpctx.Lang(c)
	code := c.Param("code")
	storeID := optionalUUID(c, "store_id")
	p, err := h.catalog.ProductByBarcode(c.Request.Context(), code, storeID)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewProductResponse(*p, lang))
}
