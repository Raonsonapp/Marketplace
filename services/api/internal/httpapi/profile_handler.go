package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/service"
)

// ProfileHandler implements GET/PATCH /profile.
type ProfileHandler struct {
	svc *service.ProfileService
}

// NewProfileHandler builds a ProfileHandler.
func NewProfileHandler(svc *service.ProfileService) *ProfileHandler { return &ProfileHandler{svc: svc} }

var validLanguages = map[string]bool{"tj": true, "ru": true, "en": true}

// Get handles GET /profile.
func (h *ProfileHandler) Get(c *gin.Context) {
	u, err := h.svc.Get(c.Request.Context(), httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewUserResponse(*u))
}

// Update handles PATCH /profile.
func (h *ProfileHandler) Update(c *gin.Context) {
	var req dto.ProfileUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if req.Language != nil && !validLanguages[*req.Language] {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "language"}))
		return
	}
	u, err := h.svc.Update(c.Request.Context(), httpctx.MustUserID(c), req.FullName, req.Email, req.Language)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewUserResponse(*u))
}
