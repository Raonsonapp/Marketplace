package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/pagination"
	"tajikshop/api/internal/repository"
	"tajikshop/api/internal/service"
)

// CargoHandler implements the parcel-forwarding endpoints (China → TJ/RU).
type CargoHandler struct {
	svc *service.CargoService
}

// NewCargoHandler builds a CargoHandler.
func NewCargoHandler(svc *service.CargoService) *CargoHandler { return &CargoHandler{svc: svc} }

// Tariffs handles GET /cargo/tariffs — public, so the service can be
// advertised before sign-in.
func (h *CargoHandler) Tariffs(c *gin.Context) {
	tariffs, err := h.svc.Tariffs(c.Request.Context())
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, gin.H{"data": dto.NewCargoTariffListResponse(tariffs)})
}

// List handles GET /cargo.
func (h *CargoHandler) List(c *gin.Context) {
	limit := queryLimit(c)
	offset := queryOffset(c)
	shipments, err := h.svc.List(c.Request.Context(), httpctx.MustUserID(c), limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewCargoShipmentListResponse(shipments), pagination.NextCursor(offset, limit, len(shipments)))
}

// Get handles GET /cargo/:id.
func (h *CargoHandler) Get(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	shipment, err := h.svc.Get(c.Request.Context(), id, httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCargoShipmentResponse(*shipment))
}

// Create handles POST /cargo.
func (h *CargoHandler) Create(c *gin.Context) {
	var req dto.CargoShipmentRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	shipment := &models.CargoShipment{
		UserID:      httpctx.MustUserID(c),
		Destination: req.Destination,
		Description: req.Description,
		TrackCode:   req.TrackCode,
		ProductLink: req.ProductLink,
	}
	if err := h.svc.Register(c.Request.Context(), shipment); err != nil {
		handleErr(c, err)
		return
	}
	created(c, dto.NewCargoShipmentResponse(*shipment))
}

// Cancel handles POST /cargo/:id/cancel.
func (h *CargoHandler) Cancel(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	shipment, err := h.svc.Cancel(c.Request.Context(), id, httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCargoShipmentResponse(*shipment))
}

// AdminList handles GET /admin/cargo.
func (h *CargoHandler) AdminList(c *gin.Context) {
	limit := queryLimit(c)
	offset := queryOffset(c)
	shipments, err := h.svc.AdminList(c.Request.Context(), c.Query("status"), limit, offset)
	if err != nil {
		handleErr(c, err)
		return
	}
	list(c, dto.NewCargoShipmentListResponse(shipments), pagination.NextCursor(offset, limit, len(shipments)))
}

// AdminUpdate handles PATCH /admin/cargo/:id.
func (h *CargoHandler) AdminUpdate(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	var req dto.CargoAdminUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	shipment, err := h.svc.AdminUpdate(c.Request.Context(), id, repository.CargoShipmentPatch{
		TrackCode: req.TrackCode, WeightKg: req.WeightKg, Status: req.Status, Note: req.Note,
	})
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCargoShipmentResponse(*shipment))
}

// AdminUpsertTariff handles PUT /admin/cargo/tariffs/:destination.
func (h *CargoHandler) AdminUpsertTariff(c *gin.Context) {
	var req dto.CargoTariffRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	tariff := &models.CargoTariff{
		Destination:      c.Param("destination"),
		RatePerKg:        req.RatePerKg,
		WarehouseAddress: req.WarehouseAddress,
		ContactPhone:     req.ContactPhone,
		EstimatedDaysMin: req.EstimatedDaysMin,
		EstimatedDaysMax: req.EstimatedDaysMax,
		IsActive:         req.IsActive,
	}
	if err := h.svc.AdminUpsertTariff(c.Request.Context(), tariff); err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCargoTariffListResponse([]models.CargoTariff{*tariff})[0])
}
