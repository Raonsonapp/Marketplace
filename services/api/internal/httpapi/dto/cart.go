package dto

import (
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/service"
)

// AddCartItemRequest is the body for POST /cart/items.
type AddCartItemRequest struct {
	ProductID string `json:"product_id" binding:"required"`
	Quantity  int    `json:"quantity" binding:"required"`
}

// UpdateCartItemRequest is the body for PATCH /cart/items/:id.
type UpdateCartItemRequest struct {
	Quantity int `json:"quantity" binding:"required"`
}

// CartItemResponse is one priced cart line.
type CartItemResponse struct {
	ID        string          `json:"id"`
	Product   ProductResponse `json:"product"`
	Quantity  int             `json:"quantity"`
	UnitPrice money.Money     `json:"unit_price"`
	LineTotal money.Money     `json:"line_total"`
	Available bool            `json:"available"`
	StockQty  int             `json:"stock_qty"`
	Adjusted  bool            `json:"adjusted,omitempty"`
}

// CartResponse is the response for GET /cart and every cart mutation.
type CartResponse struct {
	StoreID  *string            `json:"store_id"`
	Items    []CartItemResponse `json:"items"`
	Subtotal money.Money        `json:"subtotal"`
}

// NewCartResponse converts a service.CartView.
func NewCartResponse(v *service.CartView, lang string) CartResponse {
	var storeID *string
	if v.Cart.StoreID != nil {
		s := v.Cart.StoreID.String()
		storeID = &s
	}
	resp := CartResponse{StoreID: storeID, Subtotal: v.Subtotal, Items: []CartItemResponse{}}
	for _, l := range v.Lines {
		resp.Items = append(resp.Items, CartItemResponse{
			ID: l.Item.ID.String(), Product: NewProductResponse(l.Product, lang), Quantity: l.Item.Quantity,
			UnitPrice: l.UnitPrice, LineTotal: l.LineTotal, Available: l.Available, StockQty: l.StockQty, Adjusted: l.Adjusted,
		})
	}
	return resp
}

// CheckoutQuoteRequest is the body for POST /checkout/quote and (embedded
// alongside order-only fields) POST /orders.
type CheckoutQuoteRequest struct {
	AddressID      *string `json:"address_id"`
	DeliveryMethod string  `json:"delivery_method" binding:"required"`
	PromoCode      *string `json:"promo_code"`
	BonusAmount    *string `json:"bonus_amount"`
}

// QuoteResponse is the response for POST /checkout/quote.
type QuoteResponse struct {
	Subtotal       money.Money `json:"subtotal"`
	DiscountAmount money.Money `json:"discount_amount"`
	DeliveryFee    money.Money `json:"delivery_fee"`
	BonusApplied   money.Money `json:"bonus_applied"`
	Total          money.Money `json:"total"`
}

// NewQuoteResponse converts a service.QuoteResult.
func NewQuoteResponse(q *service.QuoteResult) QuoteResponse {
	return QuoteResponse{
		Subtotal: q.Subtotal, DiscountAmount: q.DiscountAmount, DeliveryFee: q.DeliveryFee,
		BonusApplied: q.BonusApplied, Total: q.Total,
	}
}
