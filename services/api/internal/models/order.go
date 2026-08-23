package models

import (
	"time"

	"github.com/google/uuid"

	"tajikshop/api/internal/pkg/money"
)

// Order status values, matching orders.status CHECK constraint.
const (
	OrderStatusPending         = "pending"
	OrderStatusConfirmed       = "confirmed"
	OrderStatusPreparing       = "preparing"
	OrderStatusReady           = "ready"
	OrderStatusCourierAssigned = "courier_assigned"
	OrderStatusPickedUp        = "picked_up"
	OrderStatusDelivering      = "delivering"
	OrderStatusDelivered       = "delivered"
	OrderStatusCancelled       = "cancelled"
)

// Delivery methods, matching orders.delivery_method CHECK constraint.
const (
	DeliveryMethodDelivery = "delivery"
	DeliveryMethodPickup   = "pickup"
)

// Payment methods/status.
const (
	PaymentMethodCashOnDelivery = "cash_on_delivery"

	PaymentStatusPending  = "pending"
	PaymentStatusPaid     = "paid"
	PaymentStatusFailed   = "failed"
	PaymentStatusRefunded = "refunded"
)

// CancelableStatuses lists order statuses from which a customer may still
// cancel (business rule: once picked up for delivery, cancellation is only
// an ops/support action, out of scope for Phase 2 customer endpoints).
var CancelableStatuses = map[string]bool{
	OrderStatusPending:   true,
	OrderStatusConfirmed: true,
	OrderStatusPreparing: true,
	OrderStatusReady:     true,
}

// Order mirrors the orders table.
type Order struct {
	ID              uuid.UUID
	OrderNumber     string
	UserID          uuid.UUID
	StoreID         uuid.UUID
	AddressID       *uuid.UUID
	DeliveryMethod  string
	Status          string
	PaymentMethod   string
	PaymentStatus   string
	Subtotal        money.Money
	DiscountAmount  money.Money
	DeliveryFee     money.Money
	BonusUsed       money.Money
	BonusEarned     money.Money
	PromoCodeID     *uuid.UUID
	Total           money.Money
	ScheduledAt     *time.Time
	CourierID       *uuid.UUID
	DeliveryNote    *string
	CancelledReason *string
	CreatedAt       time.Time
	UpdatedAt       time.Time

	Items []OrderItem
}

// OrderItem mirrors order_items (price/name snapshot at order time).
type OrderItem struct {
	ID           uuid.UUID
	OrderID      uuid.UUID
	ProductID    uuid.UUID
	NameSnapshot string
	UnitPrice    money.Money
	Quantity     int
	TotalPrice   money.Money
}

// OrderStatusHistory mirrors order_status_history.
type OrderStatusHistory struct {
	ID        uuid.UUID
	OrderID   uuid.UUID
	Status    string
	Note      *string
	ChangedBy *uuid.UUID
	CreatedAt time.Time
}
