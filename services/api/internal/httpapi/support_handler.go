package httpapi

import (
	"encoding/json"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/pagination"
	"tajikshop/api/internal/service"
	"tajikshop/api/internal/ws"
)

// SupportHandler implements the support-chat REST endpoints. It also
// broadcasts every newly-posted message to WS clients connected on that
// conversation's room via the shared ws.Hub (the same primitive
// OrderWSHandler polls order status through), so a POST here is what makes
// the realtime WS channel (SupportWSHandler) actually live.
type SupportHandler struct {
	svc *service.SupportService
	hub *ws.Hub
}

// NewSupportHandler builds a SupportHandler.
func NewSupportHandler(svc *service.SupportService, hub *ws.Hub) *SupportHandler {
	return &SupportHandler{svc: svc, hub: hub}
}

// ListConversations handles GET /support/conversations.
func (h *SupportHandler) ListConversations(c *gin.Context) {
	limit := queryLimit(c)
	offset := queryOffset(c)
	convs, err := h.svc.ListConversations(c.Request.Context(), httpctx.MustUserID(c), limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewSupportConversationListResponse(convs), pagination.NextCursor(offset, limit, len(convs)))
}

// CreateConversation handles POST /support/conversations.
func (h *SupportHandler) CreateConversation(c *gin.Context) {
	var req dto.CreateConversationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	var orderID *uuid.UUID
	if req.OrderID != nil && *req.OrderID != "" {
		id, valid := dto.ParseUUID(*req.OrderID)
		if !valid {
			handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "order_id"}))
			return
		}
		orderID = &id
	}
	conv, err := h.svc.CreateConversation(c.Request.Context(), httpctx.MustUserID(c), orderID)
	if err != nil {
		handleErr(c, err)
		return
	}
	created(c, dto.NewSupportConversationResponse(conv))
}

// ListMessages handles GET /support/conversations/:id/messages.
func (h *SupportHandler) ListMessages(c *gin.Context) {
	convID, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	limit := queryLimit(c)
	offset := queryOffset(c)
	msgs, err := h.svc.ListMessages(c.Request.Context(), httpctx.MustUserID(c), convID, limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewSupportMessageListResponse(msgs), pagination.NextCursor(offset, limit, len(msgs)))
}

// PostMessage handles POST /support/conversations/:id/messages, and
// broadcasts the new message to any WS client currently connected on this
// conversation's room.
func (h *SupportHandler) PostMessage(c *gin.Context) {
	convID, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	var req dto.PostSupportMessageRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if (req.Text == nil || *req.Text == "") && (req.ImageURL == nil || *req.ImageURL == "") {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "text"}))
		return
	}

	msg, err := h.svc.PostMessage(c.Request.Context(), httpctx.MustUserID(c), convID, req.Text, req.ImageURL)
	if err != nil {
		handleErr(c, err)
		return
	}

	resp := dto.NewSupportMessageResponse(msg)
	if b, mErr := json.Marshal(resp); mErr == nil {
		h.hub.Broadcast(convID.String(), b)
	}
	created(c, resp)
}
