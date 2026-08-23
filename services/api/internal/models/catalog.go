package models

import (
	"time"

	"github.com/google/uuid"

	"tajikshop/api/internal/pkg/money"
)

// Brand mirrors the brands table.
type Brand struct {
	ID       uuid.UUID
	Name     string
	LogoURL  *string
	IsActive bool
}

// Category mirrors the categories table.
type Category struct {
	ID        uuid.UUID
	ParentID  *uuid.UUID
	NameTJ    string
	NameRU    *string
	Slug      string
	IconURL   *string
	SortOrder int
	IsActive  bool
}

// DisplayName returns name_ru when lang=="ru" and present, else name_tj.
func (c Category) DisplayName(lang string) string {
	if lang == "ru" && c.NameRU != nil && *c.NameRU != "" {
		return *c.NameRU
	}
	return c.NameTJ
}

// Product mirrors the products table.
type Product struct {
	ID            uuid.UUID
	SKU           string
	Barcode       *string
	BrandID       *uuid.UUID
	BrandName     *string
	CategoryID    uuid.UUID
	NameTJ        string
	NameRU        *string
	DescriptionTJ *string
	DescriptionRU *string
	Unit          string
	Weight        *string
	Volume        *string
	BasePrice     money.Money
	OldPrice      *money.Money
	Tags          []string
	RatingAvg     string
	RatingCount   int
	IsActive      bool
	CreatedAt     time.Time
	Images        []string
}

// DisplayName returns name_ru when lang=="ru" and present, else name_tj.
func (p Product) DisplayName(lang string) string {
	if lang == "ru" && p.NameRU != nil && *p.NameRU != "" {
		return *p.NameRU
	}
	return p.NameTJ
}

// DisplayDescription returns description_ru when lang=="ru" and present,
// else description_tj.
func (p Product) DisplayDescription(lang string) string {
	if lang == "ru" && p.DescriptionRU != nil && *p.DescriptionRU != "" {
		return *p.DescriptionRU
	}
	if p.DescriptionTJ != nil {
		return *p.DescriptionTJ
	}
	return ""
}

// Inventory mirrors the inventory table: per-store price/stock, the
// authoritative source for cart/checkout pricing (never products.base_price).
type Inventory struct {
	ID          uuid.UUID
	ProductID   uuid.UUID
	StoreID     uuid.UUID
	Price       money.Money
	OldPrice    *money.Money
	StockQty    int
	IsAvailable bool
	UpdatedAt   time.Time
}
