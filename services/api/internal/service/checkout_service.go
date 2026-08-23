package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"sort"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/redis/go-redis/v9"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/geo"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/repository"
)

// CheckoutConfig carries the business-rule constants documented alongside
// their use below; all are read from internal/config so they can be tuned
// without a code change.
type CheckoutConfig struct {
	LoyaltyEarnRatePercent  float64
	LoyaltyMaxRedeemPercent float64
}

// CheckoutService implements docs/SECURITY.md's server-authoritative
// money/stock rule end to end: every quote and every order re-reads
// products/inventory/promo/loyalty from the database and recomputes
// subtotal/discount/delivery fee/bonus/total from scratch inside a single
// transaction with SELECT ... FOR UPDATE on the touched inventory rows.
// Nothing the client sends for price/discount/total/bonus is ever trusted.
type CheckoutService struct {
	db        *pgxpool.Pool
	rdb       *redis.Client
	cfg       CheckoutConfig
	carts     *repository.CartRepository
	products  *repository.ProductRepository
	inventory *repository.InventoryRepository
	stores    *repository.StoreRepository
	addresses *repository.AddressRepository
	promos    *repository.PromoCodeRepository
	loyalty   *repository.LoyaltyRepository
	orders    *repository.OrderRepository
}

// NewCheckoutService builds a CheckoutService.
func NewCheckoutService(
	db *pgxpool.Pool, rdb *redis.Client, cfg CheckoutConfig,
	carts *repository.CartRepository, products *repository.ProductRepository, inventory *repository.InventoryRepository,
	stores *repository.StoreRepository, addresses *repository.AddressRepository, promos *repository.PromoCodeRepository,
	loyalty *repository.LoyaltyRepository, orders *repository.OrderRepository,
) *CheckoutService {
	return &CheckoutService{db: db, rdb: rdb, cfg: cfg, carts: carts, products: products, inventory: inventory,
		stores: stores, addresses: addresses, promos: promos, loyalty: loyalty, orders: orders}
}

// QuoteRequest is the service-level input shared by POST /checkout/quote
// and POST /orders (an order is created from the same computation quote
// uses, just inside a locking transaction that also commits it).
type QuoteRequest struct {
	AddressID      *uuid.UUID
	DeliveryMethod string
	PromoCode      *string
	BonusAmount    money.Money
}

// priceLine is one line of a priced cart, computed from a locked (or
// unlocked, for quotes) live inventory row.
type priceLine struct {
	ProductID    uuid.UUID
	Name         string
	Quantity     int
	UnitPrice    money.Money
	LineTotal    money.Money
	AvailableQty int
	InventoryID  uuid.UUID
}

// OutOfStockLine describes one cart line that cannot be fulfilled.
type OutOfStockLine struct {
	ProductID uuid.UUID
	Name      string
	Requested int
	Available int
}

// QuoteResult is the server-computed preview/commit basis for an order.
type QuoteResult struct {
	StoreID        uuid.UUID
	Lines          []priceLine
	Subtotal       money.Money
	DiscountAmount money.Money
	DeliveryFee    money.Money
	BonusApplied   money.Money
	Total          money.Money
	PromoCodeID    *uuid.UUID
}

// Quote computes a non-committing preview for POST /checkout/quote.
func (s *CheckoutService) Quote(ctx context.Context, userID uuid.UUID, req QuoteRequest) (*QuoteResult, error) {
	cart, err := s.carts.GetOrCreate(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: get cart: %w", err)
	}
	if cart.StoreID == nil {
		return nil, apperr.New(apperr.CodeCartEmpty, nil)
	}
	items, err := s.carts.Items(ctx, s.db, cart.ID)
	if err != nil {
		return nil, fmt.Errorf("service: cart items: %w", err)
	}
	if len(items) == 0 {
		return nil, apperr.New(apperr.CodeCartEmpty, nil)
	}

	lines, outOfStock, err := s.priceItems(ctx, s.db, *cart.StoreID, items)
	if err != nil {
		return nil, err
	}
	if len(outOfStock) > 0 {
		return nil, outOfStockError(outOfStock)
	}

	return s.computeQuote(ctx, s.db, userID, *cart.StoreID, lines, req)
}

func outOfStockError(lines []OutOfStockLine) *apperr.Error {
	items := make([]map[string]any, len(lines))
	for i, l := range lines {
		items[i] = map[string]any{
			"product_id": l.ProductID,
			"name":       l.Name,
			"requested":  l.Requested,
			"available":  l.Available,
		}
	}
	return apperr.New(apperr.CodeOutOfStock, map[string]any{"items": items})
}

// priceItems re-reads live inventory for every cart item (no locking — used
// by the read-only quote path).
func (s *CheckoutService) priceItems(ctx context.Context, q repository.Querier, storeID uuid.UUID, items []models.CartItem) ([]priceLine, []OutOfStockLine, error) {
	var lines []priceLine
	var oos []OutOfStockLine
	for _, item := range items {
		inv, err := s.inventory.GetByProductStore(ctx, q, item.ProductID, storeID)
		if err != nil {
			if err == repository.ErrNotFound {
				oos = append(oos, OutOfStockLine{ProductID: item.ProductID, Requested: item.Quantity, Available: 0})
				continue
			}
			return nil, nil, fmt.Errorf("service: read inventory: %w", err)
		}
		p, err := s.products.GetByID(ctx, q, item.ProductID, &storeID)
		name := item.ProductID.String()
		if err == nil {
			name = p.NameTJ
		}
		if !evaluateLine(item.Quantity, *inv) {
			oos = append(oos, OutOfStockLine{ProductID: item.ProductID, Name: name, Requested: item.Quantity, Available: inv.StockQty})
			continue
		}
		lines = append(lines, priceLine{
			ProductID: item.ProductID, Name: name, Quantity: item.Quantity,
			UnitPrice: inv.Price, LineTotal: inv.Price.MulInt(item.Quantity),
			AvailableQty: inv.StockQty, InventoryID: inv.ID,
		})
	}
	return lines, oos, nil
}

// computeQuote applies delivery-fee, promo, and bonus rules on top of
// already-priced lines. q lets the caller reuse this inside a transaction.
func (s *CheckoutService) computeQuote(ctx context.Context, q repository.Querier, userID, storeID uuid.UUID, lines []priceLine, req QuoteRequest) (*QuoteResult, error) {
	var subtotal money.Money
	for _, l := range lines {
		subtotal = subtotal.Add(l.LineTotal)
	}

	deliveryFee, err := s.resolveDeliveryFee(ctx, q, userID, storeID, req.AddressID, req.DeliveryMethod, subtotal)
	if err != nil {
		return nil, err
	}

	var discount money.Money
	var promoID *uuid.UUID
	if req.PromoCode != nil && *req.PromoCode != "" {
		d, id, err := s.validatePromo(ctx, q, *req.PromoCode, userID, storeID, subtotal, lines)
		if err != nil {
			return nil, err
		}
		discount = d
		promoID = id
	}

	afterDiscount := subtotal.Sub(discount).ClampNonNegative()

	requestedBonus := money.Zero
	if req.BonusAmount.GreaterThan(money.Zero) {
		account, err := s.loyalty.GetOrCreateAccount(ctx, q, userID)
		if err != nil {
			return nil, fmt.Errorf("service: loyalty account: %w", err)
		}
		requestedBonus = computeBonusApplied(req.BonusAmount, account.Balance, afterDiscount, s.cfg.LoyaltyMaxRedeemPercent)
	}

	total, bonusApplied := computeTotal(subtotal, discount, deliveryFee, requestedBonus)

	return &QuoteResult{
		StoreID: storeID, Lines: lines, Subtotal: subtotal, DiscountAmount: discount,
		DeliveryFee: deliveryFee, BonusApplied: bonusApplied, Total: total, PromoCodeID: promoID,
	}, nil
}

// resolveDeliveryFee implements the pickup/delivery + delivery-zone rules.
func (s *CheckoutService) resolveDeliveryFee(ctx context.Context, q repository.Querier, userID, storeID uuid.UUID, addressID *uuid.UUID, method string, subtotal money.Money) (money.Money, error) {
	store, err := s.stores.GetByID(ctx, q, storeID)
	if err != nil {
		return money.Zero, fmt.Errorf("service: get store: %w", err)
	}

	if method == models.DeliveryMethodPickup {
		if !store.IsPickupAvailable {
			return money.Zero, apperr.New(apperr.CodeValidation, map[string]any{"field": "delivery_method", "reason": "pickup_unavailable"})
		}
		return money.Zero, nil
	}

	if !store.IsDeliveryAvailable {
		return money.Zero, apperr.New(apperr.CodeValidation, map[string]any{"field": "delivery_method", "reason": "delivery_unavailable"})
	}
	if addressID == nil {
		return money.Zero, apperr.New(apperr.CodeAddressRequired, nil)
	}
	address, err := s.addresses.GetByID(ctx, q, *addressID, userID)
	if err != nil {
		if err == repository.ErrNotFound {
			return money.Zero, apperr.New(apperr.CodeAddressRequired, nil)
		}
		return money.Zero, fmt.Errorf("service: get address: %w", err)
	}

	zones, err := s.stores.Zones(ctx, q, storeID)
	if err != nil {
		return money.Zero, fmt.Errorf("service: get zones: %w", err)
	}
	if len(zones) == 0 {
		// No zones configured for this store: delivery cannot be priced.
		return money.Zero, apperr.New(apperr.CodeAddressOutOfZone, nil)
	}

	var matched *models.DeliveryZone
	if address.Lat != nil && address.Lng != nil {
		pt := geo.Point{Lat: *address.Lat, Lng: *address.Lng}
		for i := range zones {
			poly := geo.ParseGeoJSONPolygon(zones[i].Coordinates())
			if poly.Contains(pt) {
				matched = &zones[i]
				break
			}
		}
	}
	if matched == nil {
		if len(zones) == 1 {
			// A single citywide zone with no address coordinates: treat it
			// as the default rather than rejecting every order that lacks
			// precise geocoding (documented simplification).
			matched = &zones[0]
		} else {
			return money.Zero, apperr.New(apperr.CodeAddressOutOfZone, nil)
		}
	}

	minOrder, _ := money.FromString(matched.MinOrderAmount)
	if subtotal.LessThan(minOrder) {
		return money.Zero, apperr.New(apperr.CodeMinOrderNotMet, map[string]any{"min_order_amount": minOrder.String()})
	}
	fee, _ := money.FromString(matched.DeliveryFee)
	if matched.FreeDeliveryThreshold != nil {
		threshold, err := money.FromString(*matched.FreeDeliveryThreshold)
		if err == nil && !subtotal.LessThan(threshold) {
			fee = money.Zero
		}
	}
	return fee, nil
}

// validatePromo checks every promo_codes rule and returns the discount
// amount plus the promo's id (to record in orders.promo_code_id / promo_code_usage).
func (s *CheckoutService) validatePromo(ctx context.Context, q repository.Querier, code string, userID, storeID uuid.UUID, subtotal money.Money, lines []priceLine) (money.Money, *uuid.UUID, error) {
	promo, err := s.promos.GetActiveByCode(ctx, q, code)
	if err != nil {
		if err == repository.ErrNotFound {
			return money.Zero, nil, apperr.New(apperr.CodePromoInvalid, nil)
		}
		return money.Zero, nil, fmt.Errorf("service: get promo: %w", err)
	}
	now := time.Now()
	if promo.StartsAt != nil && now.Before(*promo.StartsAt) {
		return money.Zero, nil, apperr.New(apperr.CodePromoInvalid, nil)
	}
	if promo.EndsAt != nil && now.After(*promo.EndsAt) {
		return money.Zero, nil, apperr.New(apperr.CodePromoExpired, nil)
	}
	if subtotal.LessThan(promo.MinOrderAmount) {
		return money.Zero, nil, apperr.New(apperr.CodePromoMinOrder, map[string]any{"min_order_amount": promo.MinOrderAmount.String()})
	}
	if len(promo.ApplicableStores) > 0 && !containsUUID(promo.ApplicableStores, storeID) {
		return money.Zero, nil, apperr.New(apperr.CodePromoInvalid, nil)
	}
	if len(promo.ApplicableProducts) > 0 || len(promo.ApplicableCategories) > 0 {
		matched := false
		for _, l := range lines {
			if len(promo.ApplicableProducts) > 0 && containsUUID(promo.ApplicableProducts, l.ProductID) {
				matched = true
				break
			}
		}
		// Category matching requires each line's category id; fetched lazily
		// only when product-level matching didn't already succeed.
		if !matched && len(promo.ApplicableCategories) > 0 {
			for _, l := range lines {
				p, err := s.products.GetByID(ctx, q, l.ProductID, nil)
				if err == nil && containsUUID(promo.ApplicableCategories, p.CategoryID) {
					matched = true
					break
				}
			}
		}
		if !matched {
			return money.Zero, nil, apperr.New(apperr.CodePromoInvalid, nil)
		}
	}
	if promo.UsageLimit != nil {
		total, err := s.promos.CountUsageTotal(ctx, q, promo.ID)
		if err != nil {
			return money.Zero, nil, fmt.Errorf("service: count promo usage: %w", err)
		}
		if total >= *promo.UsageLimit {
			return money.Zero, nil, apperr.New(apperr.CodePromoLimitReached, nil)
		}
	}
	if promo.PerUserLimit > 0 {
		used, err := s.promos.CountUsageByUser(ctx, q, promo.ID, userID)
		if err != nil {
			return money.Zero, nil, fmt.Errorf("service: count user promo usage: %w", err)
		}
		if used >= promo.PerUserLimit {
			return money.Zero, nil, apperr.New(apperr.CodePromoLimitReached, nil)
		}
	}

	discount := computeDiscountAmount(promo.DiscountType, promo.DiscountValue, promo.MaxDiscountAmount, subtotal)
	id := promo.ID
	return discount, &id, nil
}

// computeDiscountAmount is the pure arithmetic behind a promo-code discount:
// a percentage of subtotal, or a fixed amount, capped by max_discount_amount
// (when set) and always capped by the subtotal itself — a discount can
// never exceed what was actually owed.
func computeDiscountAmount(discountType string, discountValue money.Money, maxDiscount *money.Money, subtotal money.Money) money.Money {
	var discount money.Money
	switch discountType {
	case models.DiscountTypePercentage:
		pct := float64(discountValue.MinorUnits()) / 100.0
		discount = subtotal.PercentOf(pct)
	default: // fixed
		discount = discountValue
	}
	if maxDiscount != nil {
		discount = money.Min(discount, *maxDiscount)
	}
	return money.Min(discount, subtotal).ClampNonNegative()
}

// computeBonusApplied caps a requested TajBonus redemption at the account's
// live balance and at LoyaltyMaxRedeemPercent of the post-discount
// subtotal, per docs/SECURITY.md ("loyalty balance ... recomputed from
// scratch", never trusting a client-requested amount outright).
func computeBonusApplied(requested, balance, afterDiscount money.Money, maxRedeemPercent float64) money.Money {
	if !requested.GreaterThan(money.Zero) {
		return money.Zero
	}
	maxByRule := afterDiscount.PercentOf(maxRedeemPercent)
	applied := money.Min(requested, money.Min(balance, maxByRule))
	return applied.ClampNonNegative()
}

// computeTotal derives the final order total from already-validated inputs,
// and returns the bonus amount actually redeemed (which can be less than
// requestedBonus if it would otherwise have driven the total negative —
// the order should never pay out more bonus than it owed).
func computeTotal(subtotal, discount, deliveryFee, requestedBonus money.Money) (total, actualBonus money.Money) {
	afterDiscount := subtotal.Sub(discount).ClampNonNegative()
	owedBeforeBonus := afterDiscount.Add(deliveryFee)
	actualBonus = money.Min(requestedBonus, owedBeforeBonus).ClampNonNegative()
	total = owedBeforeBonus.Sub(actualBonus).ClampNonNegative()
	return total, actualBonus
}

// evaluateLine reports whether a requested quantity can be fulfilled by a
// live inventory row (available and enough stock).
func evaluateLine(requestedQty int, inv models.Inventory) bool {
	return inv.IsAvailable && inv.StockQty >= requestedQty
}

func containsUUID(list []uuid.UUID, id uuid.UUID) bool {
	for _, v := range list {
		if v == id {
			return true
		}
	}
	return false
}

// PromoPreviewResult is the response for POST /promo-codes/validate: the
// discount a promo code would resolve to against the caller's current cart,
// computed without committing anything.
type PromoPreviewResult struct {
	Code           string
	Subtotal       money.Money
	DiscountAmount money.Money
}

// ValidatePromoCode previews a promo code against the caller's current
// cart, applying the exact same server-side rules Quote/CreateOrder enforce
// (docs/SECURITY.md: min_order_amount, date window, usage_limit,
// per_user_limit, applicable scope) via the shared validatePromo helper —
// nothing here is duplicated. Read-only; no promo_code_usage row is written.
func (s *CheckoutService) ValidatePromoCode(ctx context.Context, userID uuid.UUID, code string) (*PromoPreviewResult, error) {
	cart, err := s.carts.GetOrCreate(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: get cart: %w", err)
	}
	if cart.StoreID == nil {
		return nil, apperr.New(apperr.CodeCartEmpty, nil)
	}
	items, err := s.carts.Items(ctx, s.db, cart.ID)
	if err != nil {
		return nil, fmt.Errorf("service: cart items: %w", err)
	}
	if len(items) == 0 {
		return nil, apperr.New(apperr.CodeCartEmpty, nil)
	}

	lines, outOfStock, err := s.priceItems(ctx, s.db, *cart.StoreID, items)
	if err != nil {
		return nil, err
	}
	if len(outOfStock) > 0 {
		return nil, outOfStockError(outOfStock)
	}

	var subtotal money.Money
	for _, l := range lines {
		subtotal = subtotal.Add(l.LineTotal)
	}

	discount, _, err := s.validatePromo(ctx, s.db, code, userID, *cart.StoreID, subtotal, lines)
	if err != nil {
		return nil, err
	}
	return &PromoPreviewResult{Code: code, Subtotal: subtotal, DiscountAmount: discount}, nil
}

// CreateOrderRequest is the service-level input for POST /orders.
type CreateOrderRequest struct {
	QuoteRequest
	ScheduledAt   *time.Time
	PaymentMethod string
	DeliveryNote  *string
}

// idempotencyRecord is what's cached in Redis per Idempotency-Key.
type idempotencyRecord struct {
	OrderID     uuid.UUID `json:"order_id"`
	RequestHash string    `json:"request_hash"`
}

const idempotencyTTL = 24 * time.Hour

// CreateOrder computes the final quote inside a locking transaction and
// commits it as a new order, per docs/SECURITY.md. idempotencyKey must be
// non-empty (docs/API_SPEC.md requires the Idempotency-Key header on
// POST /orders); a repeated key with the same request body returns the
// original order instead of creating a second one.
func (s *CheckoutService) CreateOrder(ctx context.Context, userID uuid.UUID, req CreateOrderRequest, idempotencyKey string) (*models.Order, error) {
	if idempotencyKey == "" {
		return nil, apperr.New(apperr.CodeIdempotencyRequired, nil)
	}
	reqHash := hashRequest(userID, req)
	redisKey := "idem:order:" + userID.String() + ":" + idempotencyKey

	if existing, err := s.rdb.Get(ctx, redisKey).Result(); err == nil {
		var rec idempotencyRecord
		if json.Unmarshal([]byte(existing), &rec) == nil {
			if rec.RequestHash != reqHash {
				return nil, apperr.New(apperr.CodeIdempotencyConflict, nil)
			}
			return s.orders.GetByID(ctx, s.db, rec.OrderID, userID)
		}
	} else if err != redis.Nil {
		return nil, fmt.Errorf("service: idempotency lookup: %w", err)
	}

	lockKey := redisKey + ":lock"
	acquired, err := s.rdb.SetNX(ctx, lockKey, "1", 30*time.Second).Result()
	if err != nil {
		return nil, fmt.Errorf("service: idempotency lock: %w", err)
	}
	if !acquired {
		return nil, apperr.New(apperr.CodeConflict, map[string]any{"reason": "order_creation_in_progress"})
	}
	defer s.rdb.Del(ctx, lockKey)

	order, err := s.createOrderTx(ctx, userID, req)
	if err != nil {
		return nil, err
	}

	rec := idempotencyRecord{OrderID: order.ID, RequestHash: reqHash}
	if b, mErr := json.Marshal(rec); mErr == nil {
		_ = s.rdb.Set(ctx, redisKey, b, idempotencyTTL).Err()
	}
	return order, nil
}

func hashRequest(userID uuid.UUID, req CreateOrderRequest) string {
	b, _ := json.Marshal(struct {
		UserID         uuid.UUID
		AddressID      *uuid.UUID
		DeliveryMethod string
		PromoCode      *string
		BonusAmount    string
		PaymentMethod  string
		ScheduledAt    *time.Time
	}{userID, req.AddressID, req.DeliveryMethod, req.PromoCode, req.BonusAmount.String(), req.PaymentMethod, req.ScheduledAt})
	sum := sha256.Sum256(b)
	return hex.EncodeToString(sum[:])
}

func (s *CheckoutService) createOrderTx(ctx context.Context, userID uuid.UUID, req CreateOrderRequest) (*models.Order, error) {
	cart, err := s.carts.GetOrCreate(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: get cart: %w", err)
	}
	if cart.StoreID == nil {
		return nil, apperr.New(apperr.CodeCartEmpty, nil)
	}
	items, err := s.carts.Items(ctx, s.db, cart.ID)
	if err != nil {
		return nil, fmt.Errorf("service: cart items: %w", err)
	}
	if len(items) == 0 {
		return nil, apperr.New(apperr.CodeCartEmpty, nil)
	}
	// Lock inventory rows in a deterministic order (by product id) to avoid
	// deadlocking against a concurrent order that touches an overlapping
	// set of products in a different order.
	sort.Slice(items, func(i, j int) bool { return items[i].ProductID.String() < items[j].ProductID.String() })

	tx, err := s.db.Begin(ctx)
	if err != nil {
		return nil, fmt.Errorf("service: begin tx: %w", err)
	}
	defer tx.Rollback(ctx)

	var lines []priceLine
	var oos []OutOfStockLine
	for _, item := range items {
		inv, err := s.inventory.LockForUpdate(ctx, tx, item.ProductID, *cart.StoreID)
		if err != nil {
			if err == repository.ErrNotFound {
				oos = append(oos, OutOfStockLine{ProductID: item.ProductID, Requested: item.Quantity, Available: 0})
				continue
			}
			return nil, fmt.Errorf("service: lock inventory: %w", err)
		}
		p, perr := s.products.GetByID(ctx, tx, item.ProductID, cart.StoreID)
		name := item.ProductID.String()
		if perr == nil {
			name = p.NameTJ
		}
		if !evaluateLine(item.Quantity, *inv) {
			oos = append(oos, OutOfStockLine{ProductID: item.ProductID, Name: name, Requested: item.Quantity, Available: inv.StockQty})
			continue
		}
		lines = append(lines, priceLine{
			ProductID: item.ProductID, Name: name, Quantity: item.Quantity,
			UnitPrice: inv.Price, LineTotal: inv.Price.MulInt(item.Quantity),
			AvailableQty: inv.StockQty, InventoryID: inv.ID,
		})
	}
	if len(oos) > 0 {
		return nil, outOfStockError(oos)
	}

	quote, err := s.computeQuote(ctx, tx, userID, *cart.StoreID, lines, req.QuoteRequest)
	if err != nil {
		return nil, err
	}

	for _, l := range lines {
		ok, err := s.inventory.DecrementStock(ctx, tx, l.InventoryID, l.Quantity)
		if err != nil {
			return nil, fmt.Errorf("service: decrement stock: %w", err)
		}
		if !ok {
			return nil, outOfStockError([]OutOfStockLine{{ProductID: l.ProductID, Name: l.Name, Requested: l.Quantity, Available: 0}})
		}
	}

	orderNumber, err := repository.GenerateOrderNumber()
	if err != nil {
		return nil, fmt.Errorf("service: generate order number: %w", err)
	}
	bonusEarned := quote.Total.PercentOf(s.cfg.LoyaltyEarnRatePercent)

	order := &models.Order{
		OrderNumber:    orderNumber,
		UserID:         userID,
		StoreID:        quote.StoreID,
		AddressID:      req.AddressID,
		DeliveryMethod: req.DeliveryMethod,
		Status:         models.OrderStatusPending,
		PaymentMethod:  req.PaymentMethod,
		PaymentStatus:  models.PaymentStatusPending,
		Subtotal:       quote.Subtotal,
		DiscountAmount: quote.DiscountAmount,
		DeliveryFee:    quote.DeliveryFee,
		BonusUsed:      quote.BonusApplied,
		BonusEarned:    bonusEarned,
		PromoCodeID:    quote.PromoCodeID,
		Total:          quote.Total,
		ScheduledAt:    req.ScheduledAt,
		DeliveryNote:   req.DeliveryNote,
	}
	if err := s.orders.Create(ctx, tx, order); err != nil {
		return nil, fmt.Errorf("service: create order: %w", err)
	}

	orderItems := make([]models.OrderItem, len(lines))
	for i, l := range lines {
		orderItems[i] = models.OrderItem{
			ProductID: l.ProductID, NameSnapshot: l.Name, UnitPrice: l.UnitPrice,
			Quantity: l.Quantity, TotalPrice: l.LineTotal,
		}
	}
	if err := s.orders.InsertItems(ctx, tx, order.ID, orderItems); err != nil {
		return nil, fmt.Errorf("service: insert order items: %w", err)
	}
	order.Items = orderItems

	if err := s.orders.InsertStatusHistory(ctx, tx, order.ID, models.OrderStatusPending, nil, nil); err != nil {
		return nil, fmt.Errorf("service: insert status history: %w", err)
	}

	if quote.PromoCodeID != nil {
		if err := s.promos.InsertUsage(ctx, tx, *quote.PromoCodeID, userID, order.ID); err != nil {
			return nil, fmt.Errorf("service: insert promo usage: %w", err)
		}
	}

	if quote.BonusApplied.GreaterThan(money.Zero) || bonusEarned.GreaterThan(money.Zero) {
		account, err := s.loyalty.LockAccountForUpdate(ctx, tx, userID)
		if err == repository.ErrNotFound {
			account, err = s.loyalty.GetOrCreateAccount(ctx, tx, userID)
		}
		if err != nil {
			return nil, fmt.Errorf("service: lock loyalty account: %w", err)
		}
		if quote.BonusApplied.GreaterThan(money.Zero) {
			if account.Balance.LessThan(quote.BonusApplied) {
				return nil, apperr.New(apperr.CodeInsufficientBonus, nil)
			}
			if _, err := s.loyalty.ApplyDelta(ctx, tx, account, &order.ID, models.LoyaltyTxSpend, quote.BonusApplied.Neg(), "Order "+order.OrderNumber); err != nil {
				return nil, fmt.Errorf("service: apply bonus spend: %w", err)
			}
		}
		if bonusEarned.GreaterThan(money.Zero) {
			if _, err := s.loyalty.ApplyDelta(ctx, tx, account, &order.ID, models.LoyaltyTxEarn, bonusEarned, "Order "+order.OrderNumber+" cashback"); err != nil {
				return nil, fmt.Errorf("service: apply bonus earn: %w", err)
			}
		}
	}

	if err := s.carts.Clear(ctx, tx, cart.ID); err != nil {
		return nil, fmt.Errorf("service: clear cart: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, fmt.Errorf("service: commit order tx: %w", err)
	}
	return order, nil
}

// ensure pgx.Tx satisfies repository.Querier at compile time.
var _ repository.Querier = (pgx.Tx)(nil)
