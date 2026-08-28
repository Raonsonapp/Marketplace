package dto

import (
	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/service"
)

// CategoryResponse mirrors a category, with children nested for GET /categories.
type CategoryResponse struct {
	ID        string             `json:"id"`
	ParentID  *string            `json:"parent_id,omitempty"`
	Name      string             `json:"name"`
	Slug      string             `json:"slug"`
	IconURL   *string            `json:"icon_url,omitempty"`
	SortOrder int                `json:"sort_order"`
	Children  []CategoryResponse `json:"children,omitempty"`
}

// NewCategoryResponse converts a category (without children).
func NewCategoryResponse(c models.Category, lang string) CategoryResponse {
	var parentID *string
	if c.ParentID != nil {
		s := c.ParentID.String()
		parentID = &s
	}
	return CategoryResponse{ID: c.ID.String(), ParentID: parentID, Name: c.DisplayName(lang), Slug: c.Slug, IconURL: c.IconURL, SortOrder: c.SortOrder}
}

// NewCategoryTreeResponse converts a full CategoryNode tree.
func NewCategoryTreeResponse(nodes []*service.CategoryNode, lang string) []CategoryResponse {
	out := make([]CategoryResponse, len(nodes))
	for i, n := range nodes {
		r := NewCategoryResponse(n.Category, lang)
		if len(n.Children) > 0 {
			r.Children = NewCategoryTreeResponse(n.Children, lang)
		}
		out[i] = r
	}
	return out
}

// ProductResponse mirrors a product for API responses.
type ProductResponse struct {
	ID          string       `json:"id"`
	SKU         string       `json:"sku"`
	Barcode     *string      `json:"barcode,omitempty"`
	BrandID     *string      `json:"brand_id,omitempty"`
	BrandName   *string      `json:"brand_name,omitempty"`
	CategoryID  string       `json:"category_id"`
	Name        string       `json:"name"`
	Description string       `json:"description,omitempty"`
	Unit        string       `json:"unit"`
	Price       money.Money  `json:"price"`
	OldPrice    *money.Money `json:"old_price,omitempty"`
	Tags        []string     `json:"tags,omitempty"`
	RatingAvg   string       `json:"rating_avg"`
	RatingCount int          `json:"rating_count"`
	Images      []string     `json:"images,omitempty"`
}

// NewProductResponse converts a product.
func NewProductResponse(p models.Product, lang string) ProductResponse {
	var brandID *string
	if p.BrandID != nil {
		s := p.BrandID.String()
		brandID = &s
	}
	return ProductResponse{
		ID: p.ID.String(), SKU: p.SKU, Barcode: p.Barcode, BrandID: brandID, BrandName: p.BrandName,
		CategoryID: p.CategoryID.String(), Name: p.DisplayName(lang), Description: p.DisplayDescription(lang),
		Unit: p.Unit, Price: p.BasePrice, OldPrice: p.OldPrice, Tags: p.Tags,
		RatingAvg: p.RatingAvg, RatingCount: p.RatingCount, Images: p.Images,
	}
}

// NewProductListResponse converts a slice of products.
func NewProductListResponse(products []models.Product, lang string) []ProductResponse {
	out := make([]ProductResponse, len(products))
	for i, p := range products {
		out[i] = NewProductResponse(p, lang)
	}
	return out
}

// ProductDetailResponse is the response for GET /products/:id.
type ProductDetailResponse struct {
	ProductResponse
	Related []ProductResponse `json:"related,omitempty"`
}

// StoreResponse mirrors a store.
type StoreResponse struct {
	ID                  string   `json:"id"`
	Name                string   `json:"name"`
	Slug                string   `json:"slug"`
	LogoURL             *string  `json:"logo_url,omitempty"`
	Address             *string  `json:"address,omitempty"`
	Country             string   `json:"country"`
	City                string   `json:"city"`
	Lat                 *float64 `json:"lat,omitempty"`
	Lng                 *float64 `json:"lng,omitempty"`
	Phone               *string  `json:"phone,omitempty"`
	IsDeliveryAvailable bool     `json:"is_delivery_available"`
	IsPickupAvailable   bool     `json:"is_pickup_available"`
	DistanceKM          *float64 `json:"distance_km,omitempty"`
}

// NewStoreResponse converts a store (optionally with distance).
func NewStoreResponse(sd service.StoreWithDistance) StoreResponse {
	s := sd.Store
	return StoreResponse{
		ID: s.ID.String(), Name: s.Name, Slug: s.Slug, LogoURL: s.LogoURL, Address: s.Address,
		Country: s.Country, City: s.City,
		Lat: s.Lat, Lng: s.Lng, Phone: s.Phone, IsDeliveryAvailable: s.IsDeliveryAvailable,
		IsPickupAvailable: s.IsPickupAvailable, DistanceKM: sd.DistanceKM,
	}
}

// StoreHoursResponse mirrors one day's opening hours.
type StoreHoursResponse struct {
	DayOfWeek int16   `json:"day_of_week"`
	OpensAt   *string `json:"opens_at,omitempty"`
	ClosesAt  *string `json:"closes_at,omitempty"`
	IsClosed  bool    `json:"is_closed"`
}

// DeliveryZoneResponse mirrors one delivery zone (geometry omitted from the API).
type DeliveryZoneResponse struct {
	Name                  string  `json:"name"`
	DeliveryFee           string  `json:"delivery_fee"`
	MinOrderAmount        string  `json:"min_order_amount"`
	FreeDeliveryThreshold *string `json:"free_delivery_threshold,omitempty"`
	EstimatedMinutesMin   *int    `json:"estimated_minutes_min,omitempty"`
	EstimatedMinutesMax   *int    `json:"estimated_minutes_max,omitempty"`
}

// StoreDetailResponse is the response for GET /stores/:id.
type StoreDetailResponse struct {
	StoreResponse
	Hours []StoreHoursResponse   `json:"hours"`
	Zones []DeliveryZoneResponse `json:"delivery_zones"`
}

// NewStoreDetailResponse converts a service.StoreDetail.
func NewStoreDetailResponse(d *service.StoreDetail) StoreDetailResponse {
	resp := StoreDetailResponse{StoreResponse: NewStoreResponse(service.StoreWithDistance{Store: d.Store})}
	for _, h := range d.Hours {
		resp.Hours = append(resp.Hours, StoreHoursResponse{DayOfWeek: h.DayOfWeek, OpensAt: h.OpensAt, ClosesAt: h.ClosesAt, IsClosed: h.IsClosed})
	}
	for _, z := range d.Zones {
		resp.Zones = append(resp.Zones, DeliveryZoneResponse{
			Name: z.Name, DeliveryFee: z.DeliveryFee, MinOrderAmount: z.MinOrderAmount,
			FreeDeliveryThreshold: z.FreeDeliveryThreshold, EstimatedMinutesMin: z.EstimatedMinutesMin, EstimatedMinutesMax: z.EstimatedMinutesMax,
		})
	}
	return resp
}

// BrandResponse mirrors a brand.
type BrandResponse struct {
	ID      string  `json:"id"`
	Name    string  `json:"name"`
	LogoURL *string `json:"logo_url,omitempty"`
}

// NewBrandResponse converts a brand.
func NewBrandResponse(b models.Brand) BrandResponse {
	return BrandResponse{ID: b.ID.String(), Name: b.Name, LogoURL: b.LogoURL}
}

// HomeResponse is the response for GET /home. Per docs/API_SPEC.md, each
// section is independently computed and omitted (nil/absent) when empty.
type HomeResponse struct {
	Categories     []CategoryResponse `json:"categories,omitempty"`
	Popular        []ProductResponse  `json:"popular,omitempty"`
	Discounted     []ProductResponse  `json:"discounted,omitempty"`
	NearbyStores   []StoreResponse    `json:"nearby_stores,omitempty"`
	FeaturedBrands []BrandResponse    `json:"featured_brands,omitempty"`
	BuyAgain       []ProductResponse  `json:"buy_again,omitempty"`
}
