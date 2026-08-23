package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// InventoryRepository provides access to the inventory table — the
// authoritative per-store price/stock source for cart and checkout, per
// docs/DATABASE_SCHEMA.md.
type InventoryRepository struct{}

// NewInventoryRepository builds an InventoryRepository.
func NewInventoryRepository() *InventoryRepository { return &InventoryRepository{} }

func scanInventory(row interface{ Scan(dest ...any) error }) (*models.Inventory, error) {
	var inv models.Inventory
	var price, oldPrice *string
	if err := row.Scan(&inv.ID, &inv.ProductID, &inv.StoreID, &price, &oldPrice, &inv.StockQty, &inv.IsAvailable, &inv.UpdatedAt); err != nil {
		return nil, err
	}
	if price != nil {
		if p, err := money.FromString(*price); err == nil {
			inv.Price = p
		}
	}
	if oldPrice != nil {
		if p, err := money.FromString(*oldPrice); err == nil {
			inv.OldPrice = &p
		}
	}
	return &inv, nil
}

const inventoryColumns = `id, product_id, store_id, price::text, old_price::text, stock_qty, is_available, updated_at`

// GetByProductStore returns the live price/stock row for a product at a
// store, or ErrNotFound if the product isn't carried there.
func (r *InventoryRepository) GetByProductStore(ctx context.Context, q Querier, productID, storeID uuid.UUID) (*models.Inventory, error) {
	row := q.QueryRow(ctx, `SELECT `+inventoryColumns+` FROM inventory WHERE product_id = $1::uuid AND store_id = $2::uuid`, productID, storeID)
	inv, err := scanInventory(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get inventory: %w", err)
	}
	return inv, nil
}

// LockForUpdate re-reads a single inventory row with SELECT ... FOR UPDATE,
// for use inside the checkout/order transaction (docs/SECURITY.md). q must
// be a transaction.
func (r *InventoryRepository) LockForUpdate(ctx context.Context, q Querier, productID, storeID uuid.UUID) (*models.Inventory, error) {
	row := q.QueryRow(ctx, `SELECT `+inventoryColumns+` FROM inventory WHERE product_id = $1::uuid AND store_id = $2::uuid FOR UPDATE`, productID, storeID)
	inv, err := scanInventory(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: lock inventory: %w", err)
	}
	return inv, nil
}

// DecrementStock reduces stock_qty by qty, guarded by stock_qty >= qty so it
// can never go negative even under a race; returns false if the guard
// failed (caller should treat this as OUT_OF_STOCK).
func (r *InventoryRepository) DecrementStock(ctx context.Context, q Querier, id uuid.UUID, qty int) (bool, error) {
	tag, err := q.Exec(ctx, `UPDATE inventory SET stock_qty = stock_qty - $2, updated_at = now() WHERE id = $1::uuid AND stock_qty >= $2`, id, qty)
	if err != nil {
		return false, fmt.Errorf("repository: decrement stock: %w", err)
	}
	return tag.RowsAffected() > 0, nil
}

// IncrementStock restores stock_qty by qty (order cancellation compensating action).
func (r *InventoryRepository) IncrementStock(ctx context.Context, q Querier, id uuid.UUID, qty int) error {
	if _, err := q.Exec(ctx, `UPDATE inventory SET stock_qty = stock_qty + $2, updated_at = now() WHERE id = $1::uuid`, id, qty); err != nil {
		return fmt.Errorf("repository: increment stock: %w", err)
	}
	return nil
}
