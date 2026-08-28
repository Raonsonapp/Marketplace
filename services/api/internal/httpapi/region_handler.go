package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/service"
)

// RegionHandler implements the public reference-data endpoints that let the
// app work in both Tajikistan and Russia.
type RegionHandler struct {
	svc *service.RegionService
}

// NewRegionHandler builds a RegionHandler.
func NewRegionHandler(svc *service.RegionService) *RegionHandler { return &RegionHandler{svc: svc} }

// Countries handles GET /countries — every market with its cities inlined,
// so a cold client needs exactly one request to populate its pickers.
func (h *RegionHandler) Countries(c *gin.Context) {
	countries, cities, err := h.svc.Countries(c.Request.Context())
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCountryListResponse(countries, cities))
}

// Cities handles GET /countries/:code/cities.
func (h *RegionHandler) Cities(c *gin.Context) {
	cities, err := h.svc.Cities(c.Request.Context(), c.Param("code"))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.NewCityListResponse(cities))
}
