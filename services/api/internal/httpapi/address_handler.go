package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/repository"
	"tajikshop/api/internal/service"
)

// AddressHandler implements GET/POST/PATCH/DELETE /addresses*.
type AddressHandler struct {
	svc *service.AddressService
}

// NewAddressHandler builds an AddressHandler.
func NewAddressHandler(svc *service.AddressService) *AddressHandler { return &AddressHandler{svc: svc} }

// List handles GET /addresses.
func (h *AddressHandler) List(c *gin.Context) {
	addrs, err := h.svc.List(c.Request.Context(), httpctx.MustUserID(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, gin.H{"data": dto.NewAddressListResponse(addrs)})
}

// Create handles POST /addresses.
func (h *AddressHandler) Create(c *gin.Context) {
	var req dto.AddressRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if req.City == nil || *req.City == "" || req.Street == nil || *req.Street == "" {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"fields": []string{"city", "street"}}))
		return
	}
	// A client that predates two-country support sends no country at all;
	// treating that as Tajikistan matches how every existing row was written
	// (migration 0007).
	country := service.DefaultCountry
	if req.Country != nil {
		if normalized := service.NormalizeCountry(*req.Country); normalized != "" {
			country = normalized
		}
	}
	a := &models.Address{
		UserID: httpctx.MustUserID(c), Country: country, City: *req.City, Street: *req.Street,
		House: req.House, Apartment: req.Apartment, Entrance: req.Entrance, Floor: req.Floor,
		Intercom: req.Intercom, Comment: req.Comment, Lat: req.Lat, Lng: req.Lng,
	}
	if req.IsDefault != nil {
		a.IsDefault = *req.IsDefault
	}
	if err := h.svc.Create(c.Request.Context(), a); err != nil {
		handleErr(c, err)
		return
	}
	created(c, dto.NewAddressResponse(*a))
}

// Update handles PATCH /addresses/:id.
func (h *AddressHandler) Update(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	var req dto.AddressRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	patch := repository.AddressPatch{
		Country: normalizeCountryPatch(req.Country), City: req.City, Street: req.Street, House: req.House, Apartment: req.Apartment,
		Entrance: req.Entrance, Floor: req.Floor, Intercom: req.Intercom, Comment: req.Comment,
		Lat: req.Lat, Lng: req.Lng, IsDefault: req.IsDefault,
	}
	a, err := h.svc.Update(c.Request.Context(), id, httpctx.MustUserID(c), patch)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewAddressResponse(*a))
}

// Delete handles DELETE /addresses/:id.
func (h *AddressHandler) Delete(c *gin.Context) {
	id, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		handleErr(c, apperr.New(apperr.CodeValidation, map[string]any{"field": "id"}))
		return
	}
	if err := h.svc.Delete(c.Request.Context(), id, httpctx.MustUserID(c)); err != nil {
		handleErr(c, err)
		return
	}
	noContent(c)
}

// normalizeCountryPatch upper-cases a PATCH's country field, and treats a
// malformed value as "not supplied" so the stored country survives rather
// than being replaced by garbage.
func normalizeCountryPatch(raw *string) *string {
	if raw == nil {
		return nil
	}
	normalized := service.NormalizeCountry(*raw)
	if normalized == "" {
		return nil
	}
	return &normalized
}
