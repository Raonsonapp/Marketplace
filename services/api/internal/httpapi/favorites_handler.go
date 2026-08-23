package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/service"
)

// FavoritesHandler implements GET/POST/DELETE /favorites*.
type FavoritesHandler struct {
	svc *service.FavoritesService
}

// NewFavoritesHandler builds a FavoritesHandler.
func NewFavoritesHandler(svc *service.FavoritesService) *FavoritesHandler {
	return &FavoritesHandler{svc: svc}
}

// List handles GET /favorites.
func (h *FavoritesHandler) List(c *gin.Context) {
	products, err := h.svc.List(c.Request.Context(), httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, gin.H{"data": dto.NewProductListResponse(products, httpctx.Lang(c))})
}

// Add handles POST /favorites/:productId.
func (h *FavoritesHandler) Add(c *gin.Context) {
	productID, valid := dto.ParseUUID(c.Param("productId"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "productId"}))
		return
	}
	if err := h.svc.Add(c.Request.Context(), httpctx.MustUserID(c), productID); err != nil {
		handleErr(c, err)
		return
	}
	noContent(c)
}

// Remove handles DELETE /favorites/:productId.
func (h *FavoritesHandler) Remove(c *gin.Context) {
	productID, valid := dto.ParseUUID(c.Param("productId"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "productId"}))
		return
	}
	if err := h.svc.Remove(c.Request.Context(), httpctx.MustUserID(c), productID); err != nil {
		handleErr(c, err)
		return
	}
	noContent(c)
}
