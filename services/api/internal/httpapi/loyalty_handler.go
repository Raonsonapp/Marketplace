package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/pagination"
	"tajikshop/api/internal/service"
)

// LoyaltyHandler implements GET /loyalty, GET /loyalty/transactions.
type LoyaltyHandler struct {
	svc *service.LoyaltyService
}

// NewLoyaltyHandler builds a LoyaltyHandler.
func NewLoyaltyHandler(svc *service.LoyaltyService) *LoyaltyHandler { return &LoyaltyHandler{svc: svc} }

// Summary handles GET /loyalty.
func (h *LoyaltyHandler) Summary(c *gin.Context) {
	acc, err := h.svc.Summary(c.Request.Context(), httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewLoyaltyResponse(acc))
}

// Transactions handles GET /loyalty/transactions.
func (h *LoyaltyHandler) Transactions(c *gin.Context) {
	limit := queryLimit(c)
	offset := queryOffset(c)
	txs, err := h.svc.Transactions(c.Request.Context(), httpctx.MustUserID(c), limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewLoyaltyTransactionListResponse(txs), pagination.NextCursor(offset, limit, len(txs)))
}
