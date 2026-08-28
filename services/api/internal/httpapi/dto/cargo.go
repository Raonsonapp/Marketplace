package dto

import (
	"time"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// CargoTariffResponse is one destination's forwarding offer: where to ship
// in China, what a kilo costs, and how long it takes.
type CargoTariffResponse struct {
	Destination      string      `json:"destination"`
	RatePerKg        money.Money `json:"rate_per_kg"`
	WarehouseAddress string      `json:"warehouse_address"`
	ContactPhone     string      `json:"contact_phone"`
	EstimatedDaysMin *int        `json:"estimated_days_min,omitempty"`
	EstimatedDaysMax *int        `json:"estimated_days_max,omitempty"`
}

// NewCargoTariffListResponse converts a slice of tariffs.
func NewCargoTariffListResponse(tariffs []models.CargoTariff) []CargoTariffResponse {
	out := make([]CargoTariffResponse, len(tariffs))
	for i, t := range tariffs {
		out[i] = CargoTariffResponse{
			Destination: t.Destination, RatePerKg: t.RatePerKg,
			WarehouseAddress: t.WarehouseAddress, ContactPhone: t.ContactPhone,
			EstimatedDaysMin: t.EstimatedDaysMin, EstimatedDaysMax: t.EstimatedDaysMax,
		}
	}
	return out
}

// CargoShipmentRequest is the body for POST /cargo.
type CargoShipmentRequest struct {
	Destination string  `json:"destination"`
	Description string  `json:"description"`
	TrackCode   *string `json:"track_code"`
	ProductLink *string `json:"product_link"`
}

// CargoShipmentResponse mirrors a registered parcel.
type CargoShipmentResponse struct {
	ID          string      `json:"id"`
	TrackCode   *string     `json:"track_code,omitempty"`
	ProductLink *string     `json:"product_link,omitempty"`
	Description string      `json:"description"`
	Destination string      `json:"destination"`
	WeightKg    float64     `json:"weight_kg"`
	Cost        money.Money `json:"cost"`
	Status      string      `json:"status"`
	Note        *string     `json:"note,omitempty"`
	CreatedAt   time.Time   `json:"created_at"`
	UpdatedAt   time.Time   `json:"updated_at"`
}

// NewCargoShipmentResponse converts a parcel.
func NewCargoShipmentResponse(s models.CargoShipment) CargoShipmentResponse {
	return CargoShipmentResponse{
		ID: s.ID.String(), TrackCode: s.TrackCode, ProductLink: s.ProductLink,
		Description: s.Description, Destination: s.Destination, WeightKg: s.WeightKg,
		Cost: s.Cost, Status: s.Status, Note: s.Note,
		CreatedAt: s.CreatedAt, UpdatedAt: s.UpdatedAt,
	}
}

// NewCargoShipmentListResponse converts a slice of parcels.
func NewCargoShipmentListResponse(shipments []models.CargoShipment) []CargoShipmentResponse {
	out := make([]CargoShipmentResponse, len(shipments))
	for i, s := range shipments {
		out[i] = NewCargoShipmentResponse(s)
	}
	return out
}

// CargoAdminUpdateRequest is the body for PATCH /admin/cargo/:id. There is
// deliberately no cost field: the price is always recomputed server-side
// from the weighed weight and the destination's rate.
type CargoAdminUpdateRequest struct {
	TrackCode *string  `json:"track_code"`
	WeightKg  *float64 `json:"weight_kg"`
	Status    *string  `json:"status"`
	Note      *string  `json:"note"`
}

// CargoTariffRequest is the body for PUT /admin/cargo/tariffs/:destination.
type CargoTariffRequest struct {
	RatePerKg        money.Money `json:"rate_per_kg"`
	WarehouseAddress string      `json:"warehouse_address"`
	ContactPhone     string      `json:"contact_phone"`
	EstimatedDaysMin *int        `json:"estimated_days_min"`
	EstimatedDaysMax *int        `json:"estimated_days_max"`
	IsActive         bool        `json:"is_active"`
}
