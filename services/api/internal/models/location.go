package models

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"

	"tajikshop/api/internal/pkg/money"
)

// Address mirrors the addresses table.
type Address struct {
	ID        uuid.UUID
	UserID    uuid.UUID
	Country   string
	City      string
	Street    string
	House     *string
	Apartment *string
	Entrance  *string
	Floor     *string
	Intercom  *string
	Comment   *string
	Lat       *float64
	Lng       *float64
	IsDefault bool
	CreatedAt time.Time
	UpdatedAt time.Time
}

// Store mirrors the stores table.
type Store struct {
	ID                  uuid.UUID
	Name                string
	Slug                string
	LogoURL             *string
	Address             *string
	Country             string
	City                string
	Lat                 *float64
	Lng                 *float64
	Phone               *string
	IsDeliveryAvailable bool
	IsPickupAvailable   bool
	IsActive            bool
	CreatedAt           time.Time
	UpdatedAt           time.Time
}

// StoreHours mirrors store_hours.
type StoreHours struct {
	ID        uuid.UUID
	StoreID   uuid.UUID
	DayOfWeek int16
	OpensAt   *string
	ClosesAt  *string
	IsClosed  bool
}

// DeliveryZone mirrors delivery_zones. Polygon holds the raw GeoJSON
// "Polygon" geometry JSON as stored in the jsonb column.
type DeliveryZone struct {
	ID                    uuid.UUID
	StoreID               uuid.UUID
	Name                  string
	Polygon               json.RawMessage
	DeliveryFee           string // money string, e.g. "15.00"
	MinOrderAmount        string
	FreeDeliveryThreshold *string
	EstimatedMinutesMin   *int
	EstimatedMinutesMax   *int
	IsActive              bool
}

// Coordinates decodes the polygon's GeoJSON "coordinates" array, ready for
// internal/pkg/geo.ParseGeoJSONPolygon. Malformed/missing geometry decodes
// to nil rather than erroring, so a zone with bad data simply never matches.
func (z DeliveryZone) Coordinates() any {
	if len(z.Polygon) == 0 {
		return nil
	}
	var doc struct {
		Coordinates any `json:"coordinates"`
	}
	if err := json.Unmarshal(z.Polygon, &doc); err != nil {
		return nil
	}
	return doc.Coordinates
}

// Country is one of the markets YouShop operates in (currently Tajikistan
// and Russia). It carries everything the client needs to localise money,
// phone input and the address map without shipping a new build when a
// market is added.
type Country struct {
	Code         string
	NameTG       string
	NameRU       string
	NameEN       string
	CurrencyCode string
	CurrencyTG   string
	CurrencyRU   string
	CurrencyEN   string
	DialCode     string
	CenterLat    float64
	CenterLng    float64
	SortOrder    int
}

// City is a delivery city inside a Country. Lat/Lng is the city centre, used
// to position the address map before the user drags the pin.
type City struct {
	ID          uuid.UUID
	CountryCode string
	NameTG      string
	NameRU      string
	NameEN      string
	Lat         float64
	Lng         float64
	SortOrder   int
}

// CargoTariff is the parcel-forwarding offer for one destination country:
// where in China to ship, what a kilo costs, and how long it takes.
// Inactive until an operator has filled it in, so the app never quotes a
// price of zero.
type CargoTariff struct {
	Destination      string
	RatePerKg        money.Money
	WarehouseAddress string
	ContactPhone     string
	EstimatedDaysMin *int
	EstimatedDaysMax *int
	IsActive         bool
	UpdatedAt        time.Time
}

// CargoShipment is one parcel a user registered for forwarding.
type CargoShipment struct {
	ID          uuid.UUID
	UserID      uuid.UUID
	TrackCode   *string
	ProductLink *string
	Description string
	Destination string
	// WeightKg and Cost stay zero until the operator weighs the parcel at
	// the China warehouse.
	WeightKg  float64
	Cost      money.Money
	Status    string
	Note      *string
	CreatedAt time.Time
	UpdatedAt time.Time
}

// Cargo statuses, in the order a parcel moves through them.
const (
	CargoStatusNew       = "new"
	CargoStatusReceived  = "received"
	CargoStatusShipped   = "shipped"
	CargoStatusArrived   = "arrived"
	CargoStatusDelivered = "delivered"
	CargoStatusCancelled = "cancelled"
)

// ValidCargoStatus reports whether s is one of the statuses the database
// CHECK constraint accepts.
func ValidCargoStatus(s string) bool {
	switch s {
	case CargoStatusNew, CargoStatusReceived, CargoStatusShipped,
		CargoStatusArrived, CargoStatusDelivered, CargoStatusCancelled:
		return true
	}
	return false
}
