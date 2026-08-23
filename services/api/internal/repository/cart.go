package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// CartRepository provides access to carts and cart_items.
type CartRepository struct{}

// NewCartRepository builds a CartRepository.
func NewCartRepository() *CartRepository { return &CartRepository{} }

// GetOrCreate returns the user's single cart, creating an empty one
// (unpinned to any store) if it doesn't exist yet.
func (r *CartRepository) GetOrCreate(ctx context.Context, q Querier, userID uuid.UUID) (*models.Cart, error) {
	row := q.QueryRow(ctx, `
		INSERT INTO carts (user_id) VALUES ($1::uuid)
		ON CONFLICT (user_id) DO UPDATE SET user_id = EXCLUDED.user_id
		RETURNING id, user_id, store_id, created_at, updated_at`, userID)
	var c models.Cart
	if err := row.Scan(&c.ID, &c.UserID, &c.StoreID, &c.CreatedAt, &c.UpdatedAt); err != nil {
		return nil, fmt.Errorf("repository: get or create cart: %w", err)
	}
	return &c, nil
}

// SetStore pins the cart to a store (called when the first item is added to
// an empty cart, or when the cart is cleared and re-seeded from a new store).
func (r *CartRepository) SetStore(ctx context.Context, q Querier, cartID, storeID uuid.UUID) error {
	if _, err := q.Exec(ctx, `UPDATE carts SET store_id = $2::uuid, updated_at = now() WHERE id = $1::uuid`, cartID, storeID); err != nil {
		return fmt.Errorf("repository: set cart store: %w", err)
	}
	return nil
}

// Items returns the non-saved-for-later items in a cart.
func (r *CartRepository) Items(ctx context.Context, q Querier, cartID uuid.UUID) ([]models.CartItem, error) {
	rows, err := q.Query(ctx, `
		SELECT id, cart_id, product_id, quantity, saved_for_later, created_at, updated_at
		FROM cart_items WHERE cart_id = $1::uuid AND saved_for_later = false
		ORDER BY created_at`, cartID)
	if err != nil {
		return nil, fmt.Errorf("repository: cart items: %w", err)
	}
	defer rows.Close()
	var out []models.CartItem
	for rows.Next() {
		var it models.CartItem
		if err := rows.Scan(&it.ID, &it.CartID, &it.ProductID, &it.Quantity, &it.SavedForLater, &it.CreatedAt, &it.UpdatedAt); err != nil {
			return nil, fmt.Errorf("repository: scan cart item: %w", err)
		}
		out = append(out, it)
	}
	return out, rows.Err()
}

// UpsertItem adds quantity to an existing line for productID, or inserts a
// new line, per the additive semantics of POST /cart/items.
func (r *CartRepository) UpsertItem(ctx context.Context, q Querier, cartID, productID uuid.UUID, quantity int) error {
	if _, err := q.Exec(ctx, `
		INSERT INTO cart_items (cart_id, product_id, quantity)
		VALUES ($1::uuid, $2::uuid, $3)
		ON CONFLICT (cart_id, product_id) DO UPDATE
			SET quantity = cart_items.quantity + EXCLUDED.quantity, updated_at = now()`,
		cartID, productID, quantity); err != nil {
		return fmt.Errorf("repository: upsert cart item: %w", err)
	}
	return nil
}

// GetItemByID returns a single cart item together with its parent cart
// (for a user-ownership check by the caller), or ErrNotFound.
func (r *CartRepository) GetItemByID(ctx context.Context, q Querier, itemID, userID uuid.UUID) (*models.CartItem, *models.Cart, error) {
	row := q.QueryRow(ctx, `
		SELECT ci.id, ci.cart_id, ci.product_id, ci.quantity, ci.saved_for_later, ci.created_at, ci.updated_at,
		       c.id, c.user_id, c.store_id, c.created_at, c.updated_at
		FROM cart_items ci
		JOIN carts c ON c.id = ci.cart_id
		WHERE ci.id = $1::uuid AND c.user_id = $2::uuid`, itemID, userID)
	var it models.CartItem
	var c models.Cart
	err := row.Scan(&it.ID, &it.CartID, &it.ProductID, &it.Quantity, &it.SavedForLater, &it.CreatedAt, &it.UpdatedAt,
		&c.ID, &c.UserID, &c.StoreID, &c.CreatedAt, &c.UpdatedAt)
	if isNoRows(err) {
		return nil, nil, ErrNotFound
	}
	if err != nil {
		return nil, nil, fmt.Errorf("repository: get cart item: %w", err)
	}
	return &it, &c, nil
}

// UpdateItemQuantity sets an absolute quantity on a cart item (PATCH /cart/items/:id).
func (r *CartRepository) UpdateItemQuantity(ctx context.Context, q Querier, itemID uuid.UUID, quantity int) error {
	tag, err := q.Exec(ctx, `UPDATE cart_items SET quantity = $2, updated_at = now() WHERE id = $1::uuid`, itemID, quantity)
	if err != nil {
		return fmt.Errorf("repository: update cart item: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

// DeleteItem removes one cart item.
func (r *CartRepository) DeleteItem(ctx context.Context, q Querier, itemID uuid.UUID) error {
	tag, err := q.Exec(ctx, `DELETE FROM cart_items WHERE id = $1::uuid`, itemID)
	if err != nil {
		return fmt.Errorf("repository: delete cart item: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

// Clear removes every item (and unpins the store) from a cart.
func (r *CartRepository) Clear(ctx context.Context, q Querier, cartID uuid.UUID) error {
	if _, err := q.Exec(ctx, `DELETE FROM cart_items WHERE cart_id = $1::uuid`, cartID); err != nil {
		return fmt.Errorf("repository: clear cart: %w", err)
	}
	if _, err := q.Exec(ctx, `UPDATE carts SET store_id = NULL, updated_at = now() WHERE id = $1::uuid`, cartID); err != nil {
		return fmt.Errorf("repository: unpin cart store: %w", err)
	}
	return nil
}
