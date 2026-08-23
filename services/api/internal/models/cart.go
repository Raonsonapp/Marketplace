package models

import (
	"time"

	"github.com/google/uuid"
)

// Cart mirrors the carts table: one active cart per user, pinned to a store.
type Cart struct {
	ID        uuid.UUID
	UserID    uuid.UUID
	StoreID   *uuid.UUID
	CreatedAt time.Time
	UpdatedAt time.Time
}

// CartItem mirrors cart_items.
type CartItem struct {
	ID            uuid.UUID
	CartID        uuid.UUID
	ProductID     uuid.UUID
	Quantity      int
	SavedForLater bool
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

// Favorite mirrors favorites.
type Favorite struct {
	ID        uuid.UUID
	UserID    uuid.UUID
	ProductID uuid.UUID
	CreatedAt time.Time
}
