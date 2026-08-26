package dto

import (
	"time"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// CreateOrderRequest is the body for POST /orders.
type CreateOrderRequest struct {
	AddressID      *string    `json:"address_id"`
	DeliveryMethod string     `json:"delivery_method" binding:"required"`
	ScheduledAt    *time.Time `json:"scheduled_at"`
	PaymentMethod  string     `json:"payment_method" binding:"required"`
	PromoCode      *string    `json:"promo_code"`
	BonusAmount    *string    `json:"bonus_amount"`
	DeliveryNote   *string    `json:"delivery_note"`
}

// CancelOrderRequest is the body for POST /orders/:id/cancel.
type CancelOrderRequest struct {
	Reason string `json:"reason" binding:"required"`
}

// OrderItemResponse mirrors one order line (price/name snapshot). ID is
// order_items.id — the order_item_id POST /reviews requires to tie a review
// back to a real purchased line.
type OrderItemResponse struct {
	ID         string      `json:"id"`
	ProductID  string      `json:"product_id"`
	Name       string      `json:"name"`
	UnitPrice  money.Money `json:"unit_price"`
	Quantity   int         `json:"quantity"`
	TotalPrice money.Money `json:"total_price"`
}

// OrderStatusEventResponse mirrors one order_status_history row.
type OrderStatusEventResponse struct {
	Status    string    `json:"status"`
	Note      *string   `json:"note,omitempty"`
	CreatedAt time.Time `json:"created_at"`
}

// OrderResponse mirrors an order for API responses.
type OrderResponse struct {
	ID              string                     `json:"id"`
	OrderNumber     string                     `json:"order_number"`
	StoreID         string                     `json:"store_id"`
	AddressID       *string                    `json:"address_id,omitempty"`
	DeliveryMethod  string                     `json:"delivery_method"`
	Status          string                     `json:"status"`
	PaymentMethod   string                     `json:"payment_method"`
	PaymentStatus   string                     `json:"payment_status"`
	Subtotal        money.Money                `json:"subtotal"`
	DiscountAmount  money.Money                `json:"discount_amount"`
	DeliveryFee     money.Money                `json:"delivery_fee"`
	BonusUsed       money.Money                `json:"bonus_used"`
	BonusEarned     money.Money                `json:"bonus_earned"`
	Total           money.Money                `json:"total"`
	ScheduledAt     *time.Time                 `json:"scheduled_at,omitempty"`
	DeliveryNote    *string                    `json:"delivery_note,omitempty"`
	CancelledReason *string                    `json:"cancelled_reason,omitempty"`
	CreatedAt       time.Time                  `json:"created_at"`
	Items           []OrderItemResponse        `json:"items"`
	StatusHistory   []OrderStatusEventResponse `json:"status_history"`
}

// NewOrderResponse converts a models.Order.
func NewOrderResponse(o *models.Order) OrderResponse {
	var addressID *string
	if o.AddressID != nil {
		s := o.AddressID.String()
		addressID = &s
	}
	resp := OrderResponse{
		ID: o.ID.String(), OrderNumber: o.OrderNumber, StoreID: o.StoreID.String(), AddressID: addressID,
		DeliveryMethod: o.DeliveryMethod, Status: o.Status, PaymentMethod: o.PaymentMethod, PaymentStatus: o.PaymentStatus,
		Subtotal: o.Subtotal, DiscountAmount: o.DiscountAmount, DeliveryFee: o.DeliveryFee,
		BonusUsed: o.BonusUsed, BonusEarned: o.BonusEarned, Total: o.Total,
		ScheduledAt: o.ScheduledAt, DeliveryNote: o.DeliveryNote, CancelledReason: o.CancelledReason,
		CreatedAt: o.CreatedAt, Items: []OrderItemResponse{}, StatusHistory: []OrderStatusEventResponse{},
	}
	for _, it := range o.Items {
		resp.Items = append(resp.Items, OrderItemResponse{
			ID: it.ID.String(), ProductID: it.ProductID.String(), Name: it.NameSnapshot, UnitPrice: it.UnitPrice,
			Quantity: it.Quantity, TotalPrice: it.TotalPrice,
		})
	}
	for _, h := range o.StatusHistory {
		resp.StatusHistory = append(resp.StatusHistory, OrderStatusEventResponse{
			Status: h.Status, Note: h.Note, CreatedAt: h.CreatedAt,
		})
	}
	return resp
}

// NewOrderListResponse converts a slice of orders (without forcing item fetches).
func NewOrderListResponse(orders []models.Order) []OrderResponse {
	out := make([]OrderResponse, len(orders))
	for i, o := range orders {
		oc := o
		out[i] = NewOrderResponse(&oc)
	}
	return out
}
