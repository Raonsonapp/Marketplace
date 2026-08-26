package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/repository"
)

// CartService implements the cart business rules from docs/API_SPEC.md /
// docs/DATABASE_SCHEMA.md: a cart is pinned to exactly one store, and every
// read always re-derives price/availability from live `inventory` rows —
// never from a cached price on the cart line.
//
// docs/API_SPEC.md's POST /cart/items body is `{product_id, quantity}` with
// no store_id: since a product can be carried by several stores'
// inventories, the store binding is resolved here rather than supplied by
// the client: if the cart is empty/unpinned, the first store found with
// that product in stock pins the cart; if the cart is already pinned to a
// store, the product must be available there (CART_STORE_MISMATCH
// otherwise) — the standard "single basket per store" rule most grocery
// delivery apps enforce.
type CartService struct {
	db        *pgxpool.Pool
	carts     *repository.CartRepository
	products  *repository.ProductRepository
	inventory *repository.InventoryRepository
	stores    *repository.StoreRepository
}

// NewCartService builds a CartService.
func NewCartService(db *pgxpool.Pool, carts *repository.CartRepository, products *repository.ProductRepository, inventory *repository.InventoryRepository, stores *repository.StoreRepository) *CartService {
	return &CartService{db: db, carts: carts, products: products, inventory: inventory, stores: stores}
}

// CartLine is one live-priced cart line for display.
type CartLine struct {
	Item      models.CartItem
	Product   models.Product
	UnitPrice money.Money
	LineTotal money.Money
	Available bool
	StockQty  int
	Adjusted  bool // true if quantity was capped because stock < requested
}

// CartView is the full current-cart response for GET /cart.
type CartView struct {
	Cart       models.Cart
	Lines      []CartLine
	SavedLines []CartLine
	Subtotal   money.Money
}

// Get returns the user's cart with every line re-priced from live inventory.
func (s *CartService) Get(ctx context.Context, userID uuid.UUID) (*CartView, error) {
	cart, err := s.carts.GetOrCreate(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: get cart: %w", err)
	}
	return s.buildView(ctx, cart)
}

func (s *CartService) buildView(ctx context.Context, cart *models.Cart) (*CartView, error) {
	items, err := s.carts.Items(ctx, s.db, cart.ID)
	if err != nil {
		return nil, fmt.Errorf("service: cart items: %w", err)
	}
	saved, err := s.carts.SavedItems(ctx, s.db, cart.ID)
	if err != nil {
		return nil, fmt.Errorf("service: saved cart items: %w", err)
	}
	view := &CartView{Cart: *cart}
	if cart.StoreID == nil {
		return view, nil
	}
	for _, item := range items {
		line, err := s.priceLine(ctx, item, *cart.StoreID)
		if err != nil {
			return nil, err
		}
		view.Lines = append(view.Lines, line)
		if line.Available {
			view.Subtotal = view.Subtotal.Add(line.LineTotal)
		}
	}
	for _, item := range saved {
		line, err := s.priceLine(ctx, item, *cart.StoreID)
		if err != nil {
			return nil, err
		}
		view.SavedLines = append(view.SavedLines, line)
	}
	return view, nil
}

// priceLine re-derives one cart line's live price/availability from
// inventory. A missing product/inventory row (deleted/delisted since being
// added to the cart) degrades to an "unavailable" line; any other error
// propagates and fails the whole cart read.
func (s *CartService) priceLine(ctx context.Context, item models.CartItem, storeID uuid.UUID) (CartLine, error) {
	p, err := s.products.GetByID(ctx, s.db, item.ProductID, &storeID)
	if err != nil {
		if err == repository.ErrNotFound {
			return CartLine{Item: item, Available: false}, nil
		}
		return CartLine{}, fmt.Errorf("service: cart line product: %w", err)
	}
	inv, err := s.inventory.GetByProductStore(ctx, s.db, item.ProductID, storeID)
	if err != nil {
		if err == repository.ErrNotFound {
			return CartLine{Item: item, Product: *p, Available: false}, nil
		}
		return CartLine{}, fmt.Errorf("service: cart line inventory: %w", err)
	}
	line := CartLine{Item: item, Product: *p, UnitPrice: inv.Price, StockQty: inv.StockQty, Available: inv.IsAvailable && inv.StockQty > 0}
	qty := item.Quantity
	if qty > inv.StockQty {
		qty = inv.StockQty
		line.Adjusted = true
	}
	line.LineTotal = inv.Price.MulInt(qty)
	return line, nil
}

// AddItem adds quantity of productID to the user's cart, resolving/checking
// the store binding as described in the CartService doc comment.
func (s *CartService) AddItem(ctx context.Context, userID, productID uuid.UUID, quantity int) (*CartView, error) {
	if quantity <= 0 {
		return nil, apperr.New(apperr.CodeValidation, map[string]any{"field": "quantity"})
	}
	cart, err := s.carts.GetOrCreate(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: get cart: %w", err)
	}

	targetStore, err := s.resolveStoreForAdd(ctx, cart, productID)
	if err != nil {
		return nil, err
	}
	if cart.StoreID == nil || *cart.StoreID != targetStore {
		if err := s.carts.SetStore(ctx, s.db, cart.ID, targetStore); err != nil {
			return nil, fmt.Errorf("service: pin cart store: %w", err)
		}
		cart.StoreID = &targetStore
	}

	if err := s.carts.UpsertItem(ctx, s.db, cart.ID, productID, quantity); err != nil {
		return nil, fmt.Errorf("service: upsert cart item: %w", err)
	}
	return s.buildView(ctx, cart)
}

func (s *CartService) resolveStoreForAdd(ctx context.Context, cart *models.Cart, productID uuid.UUID) (uuid.UUID, error) {
	if cart.StoreID != nil {
		inv, err := s.inventory.GetByProductStore(ctx, s.db, productID, *cart.StoreID)
		if err != nil {
			if err == repository.ErrNotFound {
				return uuid.Nil, apperr.New(apperr.CodeCartStoreMismatch, nil)
			}
			return uuid.Nil, fmt.Errorf("service: check inventory: %w", err)
		}
		if !inv.IsAvailable {
			return uuid.Nil, apperr.New(apperr.CodeOutOfStock, nil)
		}
		return *cart.StoreID, nil
	}

	rows, err := s.db.Query(ctx, `
		SELECT store_id FROM inventory
		WHERE product_id = $1::uuid AND is_available = true AND stock_qty > 0
		ORDER BY updated_at DESC LIMIT 1`, productID)
	if err != nil {
		return uuid.Nil, fmt.Errorf("service: find store for product: %w", err)
	}
	defer rows.Close()
	if !rows.Next() {
		return uuid.Nil, apperr.New(apperr.CodeOutOfStock, nil)
	}
	var storeID uuid.UUID
	if err := rows.Scan(&storeID); err != nil {
		return uuid.Nil, fmt.Errorf("service: scan store id: %w", err)
	}
	return storeID, nil
}

// UpdateItem sets an absolute quantity for a cart item the user owns.
func (s *CartService) UpdateItem(ctx context.Context, userID, itemID uuid.UUID, quantity int) (*CartView, error) {
	if quantity <= 0 {
		return nil, apperr.New(apperr.CodeValidation, map[string]any{"field": "quantity"})
	}
	item, cart, err := s.carts.GetItemByID(ctx, s.db, itemID, userID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: get cart item: %w", err)
	}
	_ = item
	if err := s.carts.UpdateItemQuantity(ctx, s.db, itemID, quantity); err != nil {
		return nil, fmt.Errorf("service: update cart item: %w", err)
	}
	return s.buildView(ctx, cart)
}

// RemoveItem deletes a cart item the user owns.
func (s *CartService) RemoveItem(ctx context.Context, userID, itemID uuid.UUID) (*CartView, error) {
	_, cart, err := s.carts.GetItemByID(ctx, s.db, itemID, userID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: get cart item: %w", err)
	}
	if err := s.carts.DeleteItem(ctx, s.db, itemID); err != nil {
		return nil, fmt.Errorf("service: delete cart item: %w", err)
	}
	return s.buildView(ctx, cart)
}

// SetSavedForLater moves a cart item the user owns between the active cart
// and the saved-for-later list.
func (s *CartService) SetSavedForLater(ctx context.Context, userID, itemID uuid.UUID, saved bool) (*CartView, error) {
	_, cart, err := s.carts.GetItemByID(ctx, s.db, itemID, userID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: get cart item: %w", err)
	}
	if err := s.carts.SetSavedForLater(ctx, s.db, itemID, saved); err != nil {
		return nil, fmt.Errorf("service: set cart item saved_for_later: %w", err)
	}
	return s.buildView(ctx, cart)
}

// Clear empties the user's cart entirely.
func (s *CartService) Clear(ctx context.Context, userID uuid.UUID) error {
	cart, err := s.carts.GetOrCreate(ctx, s.db, userID)
	if err != nil {
		return fmt.Errorf("service: get cart: %w", err)
	}
	if err := s.carts.Clear(ctx, s.db, cart.ID); err != nil {
		return fmt.Errorf("service: clear cart: %w", err)
	}
	return nil
}
