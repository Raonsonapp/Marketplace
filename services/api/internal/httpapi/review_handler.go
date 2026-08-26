package httpapi

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/pagination"
	"tajikshop/api/internal/service"
)

// ReviewHandler implements GET/POST /reviews.
type ReviewHandler struct {
	svc *service.ReviewService
}

// NewReviewHandler builds a ReviewHandler.
func NewReviewHandler(svc *service.ReviewService) *ReviewHandler { return &ReviewHandler{svc: svc} }

// List handles GET /reviews?product_id=.
func (h *ReviewHandler) List(c *gin.Context) {
	productID, valid := dto.ParseUUID(c.Query("product_id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "product_id"}))
		return
	}
	limit := queryLimit(c)
	offset := queryOffset(c)
	var viewerID *uuid.UUID
	if uid, ok := httpctx.UserID(c); ok {
		viewerID = &uid
	}
	revs, err := h.svc.List(c.Request.Context(), productID, viewerID, limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewReviewListResponse(revs), pagination.NextCursor(offset, limit, len(revs)))
}

// SetHelpful handles POST /reviews/:id/helpful (mark helpful) and
// DELETE /reviews/:id/helpful (withdraw). It returns the review's new
// helpful count so the client can reconcile its optimistic update.
func (h *ReviewHandler) SetHelpful(c *gin.Context, helpful bool) {
	reviewID, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	count, err := h.svc.SetHelpful(c.Request.Context(), httpctx.MustUserID(c), reviewID, helpful)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.ReviewHelpfulResponse{HelpfulCount: count, ViewerVoted: helpful})
}

// MarkHelpful handles POST /reviews/:id/helpful.
func (h *ReviewHandler) MarkHelpful(c *gin.Context) { h.SetHelpful(c, true) }

// UnmarkHelpful handles DELETE /reviews/:id/helpful.
func (h *ReviewHandler) UnmarkHelpful(c *gin.Context) { h.SetHelpful(c, false) }

// Create handles POST /reviews.
func (h *ReviewHandler) Create(c *gin.Context) {
	var req dto.CreateReviewRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	productID, valid := dto.ParseUUID(req.ProductID)
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "product_id"}))
		return
	}
	orderItemID, valid := dto.ParseUUID(req.OrderItemID)
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "order_item_id"}))
		return
	}

	rev, err := h.svc.Create(c.Request.Context(), httpctx.MustUserID(c), service.CreateReviewInput{
		ProductID: productID, OrderItemID: orderItemID, Rating: req.Rating, Text: req.Text, Images: req.Images,
	})
	if err != nil {
		handleErr(c, err)
		return
	}
	created(c, dto.NewReviewResponse(rev))
}
