package httpapi

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/service"
)

// CheckoutHandler implements POST /checkout/quote and POST /orders.
type CheckoutHandler struct {
	svc *service.CheckoutService
}

// NewCheckoutHandler builds a CheckoutHandler.
func NewCheckoutHandler(svc *service.CheckoutService) *CheckoutHandler {
	return &CheckoutHandler{svc: svc}
}

func validDeliveryMethod(m string) bool {
	return m == models.DeliveryMethodDelivery || m == models.DeliveryMethodPickup
}

func parseBonusAmount(raw *string) (money.Money, error) {
	if raw == nil || *raw == "" {
		return money.Zero, nil
	}
	m, err := money.FromString(*raw)
	if err != nil {
		return money.Zero, apperr.New(apperr.CodeValidation, map[string]any{"field": "bonus_amount"})
	}
	if m.IsNegative() {
		return money.Zero, apperr.New(apperr.CodeValidation, map[string]any{"field": "bonus_amount"})
	}
	return m, nil
}

// Quote handles POST /checkout/quote.
func (h *CheckoutHandler) Quote(c *gin.Context) {
	var req dto.CheckoutQuoteRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if !validDeliveryMethod(req.DeliveryMethod) {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "delivery_method"}))
		return
	}
	bonus, err := parseBonusAmount(req.BonusAmount)
	if err != nil {
		handleErr(c, err)
		return
	}
	var addressID *uuid.UUID
	if req.AddressID != nil {
		id, valid := dto.ParseUUID(*req.AddressID)
		if !valid {
			handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "address_id"}))
			return
		}
		addressID = &id
	}

	q, err := h.svc.Quote(c.Request.Context(), httpctx.MustUserID(c), service.QuoteRequest{
		AddressID: addressID, DeliveryMethod: req.DeliveryMethod, PromoCode: req.PromoCode, BonusAmount: bonus,
	})
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewQuoteResponse(q))
}

// CreateOrder handles POST /orders.
func (h *CheckoutHandler) CreateOrder(c *gin.Context) {
	var req dto.CreateOrderRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if !validDeliveryMethod(req.DeliveryMethod) {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "delivery_method"}))
		return
	}
	if req.PaymentMethod != models.PaymentMethodCashOnDelivery {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "payment_method"}))
		return
	}
	bonus, err := parseBonusAmount(req.BonusAmount)
	if err != nil {
		handleErr(c, err)
		return
	}
	var addressID *uuid.UUID
	if req.AddressID != nil {
		id, valid := dto.ParseUUID(*req.AddressID)
		if !valid {
			handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "address_id"}))
			return
		}
		addressID = &id
	}

	idempotencyKey := c.GetHeader("Idempotency-Key")
	order, err := h.svc.CreateOrder(c.Request.Context(), httpctx.MustUserID(c), service.CreateOrderRequest{
		QuoteRequest: service.QuoteRequest{
			AddressID: addressID, DeliveryMethod: req.DeliveryMethod, PromoCode: req.PromoCode, BonusAmount: bonus,
		},
		ScheduledAt:   req.ScheduledAt,
		PaymentMethod: req.PaymentMethod,
		DeliveryNote:  req.DeliveryNote,
	}, idempotencyKey)
	if err != nil {
		handleErr(c, err)
		return
	}
	created(c, dto.NewOrderResponse(order))
}
