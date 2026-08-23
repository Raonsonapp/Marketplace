package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/pagination"
	"tajikshop/api/internal/service"
)

// NotificationHandler implements GET /notifications, PATCH
// /notifications/:id/read, GET/PATCH /notifications/preferences, and
// POST /devices.
type NotificationHandler struct {
	svc *service.NotificationService
}

// NewNotificationHandler builds a NotificationHandler.
func NewNotificationHandler(svc *service.NotificationService) *NotificationHandler {
	return &NotificationHandler{svc: svc}
}

// List handles GET /notifications.
func (h *NotificationHandler) List(c *gin.Context) {
	limit := queryLimit(c)
	offset := queryOffset(c)
	notifs, err := h.svc.List(c.Request.Context(), httpctx.MustUserID(c), limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewNotificationListResponse(notifs), pagination.NextCursor(offset, limit, len(notifs)))
}

// MarkRead handles PATCH /notifications/:id/read.
func (h *NotificationHandler) MarkRead(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	if err := h.svc.MarkRead(c.Request.Context(), httpctx.MustUserID(c), id); err != nil {
		handleErr(c, err)
		return
	}
	noContent(c)
}

// GetPreferences handles GET /notifications/preferences.
func (h *NotificationHandler) GetPreferences(c *gin.Context) {
	p, err := h.svc.GetPreferences(c.Request.Context(), httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewNotificationPreferencesResponse(p))
}

// UpdatePreferences handles PATCH /notifications/preferences.
func (h *NotificationHandler) UpdatePreferences(c *gin.Context) {
	var req dto.NotificationPreferencesRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	p, err := h.svc.UpdatePreferences(c.Request.Context(), httpctx.MustUserID(c), req.ToServiceInput())
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewNotificationPreferencesResponse(p))
}

// RegisterDevice handles POST /devices.
func (h *NotificationHandler) RegisterDevice(c *gin.Context) {
	var req dto.RegisterDeviceRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if err := h.svc.RegisterDevice(c.Request.Context(), httpctx.MustUserID(c), req.FCMToken, req.Platform); err != nil {
		handleErr(c, err)
		return
	}
	noContent(c)
}
