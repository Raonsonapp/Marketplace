package httpapi

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/service"
)

// PromotionHandler implements GET /promotions and POST
// /promo-codes/validate.
type PromotionHandler struct {
	promotions *service.PromotionService
	checkout   *service.CheckoutService
}

// NewPromotionHandler builds a PromotionHandler.
func NewPromotionHandler(promotions *service.PromotionService, checkout *service.CheckoutService) *PromotionHandler {
	return &PromotionHandler{promotions: promotions, checkout: checkout}
}

// List handles GET /promotions (auth optional — personalizes to the caller
// when a token is present, otherwise returns the public campaign feed).
func (h *PromotionHandler) List(c *gin.Context) {
	limit := queryLimit(c)
	offset := queryOffset(c)
	var userID *uuid.UUID
	if id, ok := httpctx.UserID(c); ok {
		userID = &id
	}
	promos, err := h.promotions.List(c.Request.Context(), userID, limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, gin.H{"data": dto.NewPromotionsResponse(promos)})
}

// Validate handles POST /promo-codes/validate.
func (h *PromotionHandler) Validate(c *gin.Context) {
	var req dto.PromoCodeValidateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	result, err := h.checkout.ValidatePromoCode(c.Request.Context(), httpctx.MustUserID(c), req.Code)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewPromoCodeValidateResponse(result))
}
