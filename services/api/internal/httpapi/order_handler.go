package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/pagination"
	"tajikshop/api/internal/service"
)

// OrderHandler implements GET /orders*, POST /orders/:id/cancel.
type OrderHandler struct {
	svc      *service.OrderService
	checkout *service.CheckoutService
}

// NewOrderHandler builds an OrderHandler.
func NewOrderHandler(svc *service.OrderService, checkout *service.CheckoutService) *OrderHandler {
	return &OrderHandler{svc: svc, checkout: checkout}
}

// List handles GET /orders.
func (h *OrderHandler) List(c *gin.Context) {
	limit := queryLimit(c)
	offset := queryOffset(c)
	orders, err := h.svc.List(c.Request.Context(), httpctx.MustUserID(c), c.Query("status"), limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewOrderListResponse(orders), pagination.NextCursor(offset, limit, len(orders)))
}

// Get handles GET /orders/:id.
func (h *OrderHandler) Get(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	order, err := h.svc.Get(c.Request.Context(), httpctx.MustUserID(c), id)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewOrderResponse(order))
}

// Cancel handles POST /orders/:id/cancel.
func (h *OrderHandler) Cancel(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	var req dto.CancelOrderRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	order, err := h.checkout.Cancel(c.Request.Context(), httpctx.MustUserID(c), id, req.Reason)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewOrderResponse(order))
}
