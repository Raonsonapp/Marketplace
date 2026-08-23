package dto

import (
	"time"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/service"
)

// PromoCodeValidateRequest is the body for POST /promo-codes/validate.
type PromoCodeValidateRequest struct {
	Code string `json:"code" binding:"required"`
}

// PromoCodeValidateResponse is the response for POST /promo-codes/validate:
// the resolved discount, previewed against the caller's current cart.
type PromoCodeValidateResponse struct {
	Code           string      `json:"code"`
	Valid          bool        `json:"valid"`
	Subtotal       money.Money `json:"subtotal"`
	DiscountAmount money.Money `json:"discount_amount"`
}

// NewPromoCodeValidateResponse converts a service.PromoPreviewResult.
func NewPromoCodeValidateResponse(r *service.PromoPreviewResult) PromoCodeValidateResponse {
	return PromoCodeValidateResponse{Code: r.Code, Valid: true, Subtotal: r.Subtotal, DiscountAmount: r.DiscountAmount}
}

// DiscountResponse mirrors one models.Discount ("promotion" the mobile home
// screen surfaces as a campaign/personal-offer card).
type DiscountResponse struct {
	ID            string      `json:"id"`
	Name          string      `json:"name"`
	Scope         string      `json:"scope"`
	DiscountType  string      `json:"discount_type"`
	DiscountValue money.Money `json:"discount_value"`
	StartsAt      *time.Time  `json:"starts_at,omitempty"`
	EndsAt        *time.Time  `json:"ends_at,omitempty"`
}

// NewDiscountResponse converts a models.Discount.
func NewDiscountResponse(d models.Discount) DiscountResponse {
	return DiscountResponse{
		ID: d.ID.String(), Name: d.Name, Scope: d.Scope, DiscountType: d.DiscountType,
		DiscountValue: d.DiscountValue, StartsAt: d.StartsAt, EndsAt: d.EndsAt,
	}
}

// PromoCodeSummaryResponse mirrors one publicly-discoverable promo code.
type PromoCodeSummaryResponse struct {
	Code              string       `json:"code"`
	DiscountType      string       `json:"discount_type"`
	DiscountValue     money.Money  `json:"discount_value"`
	MinOrderAmount    money.Money  `json:"min_order_amount"`
	MaxDiscountAmount *money.Money `json:"max_discount_amount,omitempty"`
	EndsAt            *time.Time   `json:"ends_at,omitempty"`
}

// NewPromoCodeSummaryResponse converts a models.PromoCode.
func NewPromoCodeSummaryResponse(p models.PromoCode) PromoCodeSummaryResponse {
	return PromoCodeSummaryResponse{
		Code: p.Code, DiscountType: p.DiscountType, DiscountValue: p.DiscountValue,
		MinOrderAmount: p.MinOrderAmount, MaxDiscountAmount: p.MaxDiscountAmount, EndsAt: p.EndsAt,
	}
}

// PromotionsResponse is the data payload for GET /promotions.
type PromotionsResponse struct {
	Discounts  []DiscountResponse         `json:"discounts"`
	PromoCodes []PromoCodeSummaryResponse `json:"promo_codes"`
}

// NewPromotionsResponse converts a service.Promotions.
func NewPromotionsResponse(p *service.Promotions) PromotionsResponse {
	out := PromotionsResponse{Discounts: []DiscountResponse{}, PromoCodes: []PromoCodeSummaryResponse{}}
	for _, d := range p.Discounts {
		out.Discounts = append(out.Discounts, NewDiscountResponse(d))
	}
	for _, pc := range p.PromoCodes {
		out.PromoCodes = append(out.PromoCodes, NewPromoCodeSummaryResponse(pc))
	}
	return out
}
