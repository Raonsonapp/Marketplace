package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/service"
)

// CartHandler implements GET/POST/PATCH/DELETE /cart*.
type CartHandler struct {
	svc *service.CartService
}

// NewCartHandler builds a CartHandler.
func NewCartHandler(svc *service.CartService) *CartHandler { return &CartHandler{svc: svc} }

// Get handles GET /cart.
func (h *CartHandler) Get(c *gin.Context) {
	view, err := h.svc.Get(c.Request.Context(), httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCartResponse(view, httpctx.Lang(c)))
}

// AddItem handles POST /cart/items.
func (h *CartHandler) AddItem(c *gin.Context) {
	var req dto.AddCartItemRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	productID, valid := dto.ParseUUID(req.ProductID)
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "product_id"}))
		return
	}
	if req.Quantity <= 0 {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "quantity"}))
		return
	}
	view, err := h.svc.AddItem(c.Request.Context(), httpctx.MustUserID(c), productID, req.Quantity)
	if err != nil {
		handleErr(c, err)
		return
	}
	created(c, dto.NewCartResponse(view, httpctx.Lang(c)))
}

// UpdateItem handles PATCH /cart/items/:id.
func (h *CartHandler) UpdateItem(c *gin.Context) {
	itemID, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	var req dto.UpdateCartItemRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if req.Quantity <= 0 {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "quantity"}))
		return
	}
	view, err := h.svc.UpdateItem(c.Request.Context(), httpctx.MustUserID(c), itemID, req.Quantity)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCartResponse(view, httpctx.Lang(c)))
}

// RemoveItem handles DELETE /cart/items/:id.
func (h *CartHandler) RemoveItem(c *gin.Context) {
	itemID, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	view, err := h.svc.RemoveItem(c.Request.Context(), httpctx.MustUserID(c), itemID)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCartResponse(view, httpctx.Lang(c)))
}

// Clear handles DELETE /cart.
func (h *CartHandler) Clear(c *gin.Context) {
	if err := h.svc.Clear(c.Request.Context(), httpctx.MustUserID(c)); err != nil {
		handleErr(c, err)
		return
	}
	noContent(c)
}
