package repository

import (
	"context"
	"crypto/rand"
	"fmt"
	"math/big"
	"time"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// OrderRepository provides access to orders, order_items, and order_status_history.
type OrderRepository struct{}

// NewOrderRepository builds an OrderRepository.
func NewOrderRepository() *OrderRepository { return &OrderRepository{} }

// GenerateOrderNumber returns a human-facing order number, e.g.
// "TS260823482913" (TS + YYMMDD + 6 random digits), well within the
// orders.order_number varchar(20) limit.
func GenerateOrderNumber() (string, error) {
	max := big.NewInt(1000000)
	n, err := rand.Int(rand.Reader, max)
	if err != nil {
		return "", fmt.Errorf("repository: generate order number: %w", err)
	}
	return fmt.Sprintf("TS%s%06d", time.Now().Format("060102"), n.Int64()), nil
}

// Create inserts a new order row. Every money field on o must already be
// server-computed — callers must never persist a client-submitted total.
func (r *OrderRepository) Create(ctx context.Context, q Querier, o *models.Order) error {
	row := q.QueryRow(ctx, `
		INSERT INTO orders (order_number, user_id, store_id, address_id, delivery_method, status, payment_method,
			payment_status, subtotal, discount_amount, delivery_fee, bonus_used, bonus_earned, promo_code_id, total,
			scheduled_at, delivery_note)
		VALUES ($1, $2::uuid, $3::uuid, $4::uuid, $5, $6, $7, $8, $9::numeric, $10::numeric, $11::numeric, $12::numeric,
			$13::numeric, $14::uuid, $15::numeric, $16, $17)
		RETURNING id, created_at, updated_at`,
		o.OrderNumber, o.UserID, o.StoreID, o.AddressID, o.DeliveryMethod, o.Status, o.PaymentMethod,
		o.PaymentStatus, o.Subtotal.String(), o.DiscountAmount.String(), o.DeliveryFee.String(), o.BonusUsed.String(),
		o.BonusEarned.String(), o.PromoCodeID, o.Total.String(), o.ScheduledAt, o.DeliveryNote)
	if err := row.Scan(&o.ID, &o.CreatedAt, &o.UpdatedAt); err != nil {
		return fmt.Errorf("repository: create order: %w", err)
	}
	return nil
}

// InsertItems bulk-inserts order line items (name/price snapshot at order time).
func (r *OrderRepository) InsertItems(ctx context.Context, q Querier, orderID uuid.UUID, items []models.OrderItem) error {
	for i := range items {
		items[i].OrderID = orderID
		row := q.QueryRow(ctx, `
			INSERT INTO order_items (order_id, product_id, name_snapshot, unit_price, quantity, total_price)
			VALUES ($1::uuid, $2::uuid, $3, $4::numeric, $5, $6::numeric)
			RETURNING id`, orderID, items[i].ProductID, items[i].NameSnapshot, items[i].UnitPrice.String(), items[i].Quantity, items[i].TotalPrice.String())
		if err := row.Scan(&items[i].ID); err != nil {
			return fmt.Errorf("repository: insert order item: %w", err)
		}
	}
	return nil
}

// InsertStatusHistory appends a row to order_status_history.
func (r *OrderRepository) InsertStatusHistory(ctx context.Context, q Querier, orderID uuid.UUID, status string, note *string, changedBy *uuid.UUID) error {
	if _, err := q.Exec(ctx, `
		INSERT INTO order_status_history (order_id, status, note, changed_by) VALUES ($1::uuid, $2, $3, $4::uuid)`,
		orderID, status, note, changedBy); err != nil {
		return fmt.Errorf("repository: insert order status history: %w", err)
	}
	return nil
}

const orderColumns = `id, order_number, user_id, store_id, address_id, delivery_method, status, payment_method, payment_status,
	subtotal::text, discount_amount::text, delivery_fee::text, bonus_used::text, bonus_earned::text, promo_code_id, total::text,
	scheduled_at, courier_id, delivery_note, cancelled_reason, created_at, updated_at`

func scanOrder(row interface{ Scan(dest ...any) error }) (*models.Order, error) {
	var o models.Order
	var subtotal, discount, deliveryFee, bonusUsed, bonusEarned, total string
	if err := row.Scan(&o.ID, &o.OrderNumber, &o.UserID, &o.StoreID, &o.AddressID, &o.DeliveryMethod, &o.Status, &o.PaymentMethod, &o.PaymentStatus,
		&subtotal, &discount, &deliveryFee, &bonusUsed, &bonusEarned, &o.PromoCodeID, &total,
		&o.ScheduledAt, &o.CourierID, &o.DeliveryNote, &o.CancelledReason, &o.CreatedAt, &o.UpdatedAt); err != nil {
		return nil, err
	}
	o.Subtotal, _ = money.FromString(subtotal)
	o.DiscountAmount, _ = money.FromString(discount)
	o.DeliveryFee, _ = money.FromString(deliveryFee)
	o.BonusUsed, _ = money.FromString(bonusUsed)
	o.BonusEarned, _ = money.FromString(bonusEarned)
	o.Total, _ = money.FromString(total)
	return &o, nil
}

// GetByID returns an order owned by userID (with items), or ErrNotFound.
func (r *OrderRepository) GetByID(ctx context.Context, q Querier, id, userID uuid.UUID) (*models.Order, error) {
	row := q.QueryRow(ctx, `SELECT `+orderColumns+` FROM orders WHERE id = $1::uuid AND user_id = $2::uuid`, id, userID)
	o, err := scanOrder(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get order: %w", err)
	}
	items, err := r.GetItems(ctx, q, o.ID)
	if err != nil {
		return nil, err
	}
	o.Items = items
	return o, nil
}

// GetItems returns the line items for an order.
func (r *OrderRepository) GetItems(ctx context.Context, q Querier, orderID uuid.UUID) ([]models.OrderItem, error) {
	rows, err := q.Query(ctx, `
		SELECT id, order_id, product_id, name_snapshot, unit_price::text, quantity, total_price::text
		FROM order_items WHERE order_id = $1::uuid ORDER BY id`, orderID)
	if err != nil {
		return nil, fmt.Errorf("repository: get order items: %w", err)
	}
	defer rows.Close()
	var out []models.OrderItem
	for rows.Next() {
		var it models.OrderItem
		var unitPrice, totalPrice string
		if err := rows.Scan(&it.ID, &it.OrderID, &it.ProductID, &it.NameSnapshot, &unitPrice, &it.Quantity, &totalPrice); err != nil {
			return nil, fmt.Errorf("repository: scan order item: %w", err)
		}
		it.UnitPrice, _ = money.FromString(unitPrice)
		it.TotalPrice, _ = money.FromString(totalPrice)
		out = append(out, it)
	}
	return out, rows.Err()
}

// ListByUser returns a user's orders, optionally filtered by a coarse
// status bucket ("active"|"completed"|"cancelled", per docs/API_SPEC.md).
func (r *OrderRepository) ListByUser(ctx context.Context, q Querier, userID uuid.UUID, statusFilter string, limit, offset int) ([]models.Order, error) {
	sqlStr := `SELECT ` + orderColumns + ` FROM orders WHERE user_id = $1::uuid`
	args := []any{userID}
	switch statusFilter {
	case "active":
		sqlStr += ` AND status NOT IN ('delivered','cancelled')`
	case "completed":
		sqlStr += ` AND status = 'delivered'`
	case "cancelled":
		sqlStr += ` AND status = 'cancelled'`
	}
	sqlStr += fmt.Sprintf(" ORDER BY created_at DESC LIMIT $%d OFFSET $%d", len(args)+1, len(args)+2)
	args = append(args, limit, offset)

	rows, err := q.Query(ctx, sqlStr, args...)
	if err != nil {
		return nil, fmt.Errorf("repository: list orders: %w", err)
	}
	defer rows.Close()
	var out []models.Order
	for rows.Next() {
		o, err := scanOrder(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan order: %w", err)
		}
		out = append(out, *o)
	}
	return out, rows.Err()
}

// Cancel transitions an order to cancelled with a reason. Callers must have
// already verified the order is in a cancelable status.
func (r *OrderRepository) Cancel(ctx context.Context, q Querier, id uuid.UUID, reason string) error {
	tag, err := q.Exec(ctx, `UPDATE orders SET status = 'cancelled', cancelled_reason = $2, updated_at = now() WHERE id = $1::uuid`, id, reason)
	if err != nil {
		return fmt.Errorf("repository: cancel order: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

// GetForUpdate re-reads an order row with SELECT ... FOR UPDATE, for use
// inside the cancel transaction to avoid a status race.
func (r *OrderRepository) GetForUpdate(ctx context.Context, q Querier, id, userID uuid.UUID) (*models.Order, error) {
	row := q.QueryRow(ctx, `SELECT `+orderColumns+` FROM orders WHERE id = $1::uuid AND user_id = $2::uuid FOR UPDATE`, id, userID)
	o, err := scanOrder(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: lock order: %w", err)
	}
	items, err := r.GetItems(ctx, q, o.ID)
	if err != nil {
		return nil, err
	}
	o.Items = items
	return o, nil
}
