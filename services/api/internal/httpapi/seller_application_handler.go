package httpapi

import (
	"time"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/service"
)

// SellerApplicationHandler implements POST /seller-applications and
// GET /seller-applications/me.
type SellerApplicationHandler struct {
	svc *service.SellerApplicationService
}

// NewSellerApplicationHandler builds a SellerApplicationHandler.
func NewSellerApplicationHandler(svc *service.SellerApplicationService) *SellerApplicationHandler {
	return &SellerApplicationHandler{svc: svc}
}

// Create handles POST /seller-applications.
func (h *SellerApplicationHandler) Create(c *gin.Context) {
	var req dto.CreateSellerApplicationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	birthDate, err := time.Parse("2006-01-02", req.BirthDate)
	if err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "birth_date"}))
		return
	}

	app, err := h.svc.Create(c.Request.Context(), httpctx.MustUserID(c), service.CreateSellerApplicationInput{
		BirthDate:             birthDate,
		StoreLat:              req.StoreLat,
		StoreLng:              req.StoreLng,
		StoreWebsite:          req.StoreWebsite,
		StoreInstagram:        req.StoreInstagram,
		StoreTelegram:         req.StoreTelegram,
		StoreWhatsapp:         req.StoreWhatsapp,
		PassportFrontKey:      req.PassportFrontKey,
		PassportBackKey:       req.PassportBackKey,
		SelfieWithPassportKey: req.SelfieWithPassportKey,
		LiveSelfieKey:         req.LiveSelfieKey,
		LivenessPassed:        req.LivenessPassed,
		FaceMatchScore:        req.FaceMatchScore,
	})
	if err != nil {
		handleErr(c, err)
		return
	}
	created(c, dto.NewSellerApplicationResponse(app))
}

// GetMine handles GET /seller-applications/me.
func (h *SellerApplicationHandler) GetMine(c *gin.Context) {
	app, err := h.svc.GetMine(c.Request.Context(), httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewSellerApplicationResponse(app))
}
