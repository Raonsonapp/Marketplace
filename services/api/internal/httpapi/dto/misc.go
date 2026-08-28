package dto

import (
	"time"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// LoyaltyResponse is the response for GET /loyalty.
type LoyaltyResponse struct {
	Balance        money.Money `json:"balance"`
	LifetimeEarned money.Money `json:"lifetime_earned"`
	Tier           string      `json:"tier"`
}

// NewLoyaltyResponse converts a models.LoyaltyAccount.
func NewLoyaltyResponse(a *models.LoyaltyAccount) LoyaltyResponse {
	return LoyaltyResponse{Balance: a.Balance, LifetimeEarned: a.LifetimeEarned, Tier: a.Tier}
}

// LoyaltyTransactionResponse mirrors one ledger entry.
type LoyaltyTransactionResponse struct {
	ID           string      `json:"id"`
	Type         string      `json:"type"`
	Amount       money.Money `json:"amount"`
	BalanceAfter money.Money `json:"balance_after"`
	Description  *string     `json:"description,omitempty"`
	OrderID      *string     `json:"order_id,omitempty"`
	CreatedAt    time.Time   `json:"created_at"`
}

// NewLoyaltyTransactionListResponse converts a slice of ledger entries.
func NewLoyaltyTransactionListResponse(txs []models.LoyaltyTransaction) []LoyaltyTransactionResponse {
	out := make([]LoyaltyTransactionResponse, len(txs))
	for i, t := range txs {
		var orderID *string
		if t.OrderID != nil {
			s := t.OrderID.String()
			orderID = &s
		}
		out[i] = LoyaltyTransactionResponse{
			ID: t.ID.String(), Type: t.Type, Amount: t.Amount, BalanceAfter: t.BalanceAfter,
			Description: t.Description, OrderID: orderID, CreatedAt: t.CreatedAt,
		}
	}
	return out
}

// AddressRequest is the body for POST /addresses and PATCH /addresses/:id.
type AddressRequest struct {
	Country   *string  `json:"country"`
	City      *string  `json:"city"`
	Street    *string  `json:"street"`
	House     *string  `json:"house"`
	Apartment *string  `json:"apartment"`
	Entrance  *string  `json:"entrance"`
	Floor     *string  `json:"floor"`
	Intercom  *string  `json:"intercom"`
	Comment   *string  `json:"comment"`
	Lat       *float64 `json:"lat"`
	Lng       *float64 `json:"lng"`
	IsDefault *bool    `json:"is_default"`
}

// AddressResponse mirrors an address.
type AddressResponse struct {
	ID        string   `json:"id"`
	Country   string   `json:"country"`
	City      string   `json:"city"`
	Street    string   `json:"street"`
	House     *string  `json:"house,omitempty"`
	Apartment *string  `json:"apartment,omitempty"`
	Entrance  *string  `json:"entrance,omitempty"`
	Floor     *string  `json:"floor,omitempty"`
	Intercom  *string  `json:"intercom,omitempty"`
	Comment   *string  `json:"comment,omitempty"`
	Lat       *float64 `json:"lat,omitempty"`
	Lng       *float64 `json:"lng,omitempty"`
	IsDefault bool     `json:"is_default"`
}

// NewAddressResponse converts a models.Address.
func NewAddressResponse(a models.Address) AddressResponse {
	return AddressResponse{
		ID: a.ID.String(), Country: a.Country, City: a.City, Street: a.Street, House: a.House, Apartment: a.Apartment,
		Entrance: a.Entrance, Floor: a.Floor, Intercom: a.Intercom, Comment: a.Comment,
		Lat: a.Lat, Lng: a.Lng, IsDefault: a.IsDefault,
	}
}

// NewAddressListResponse converts a slice of addresses.
func NewAddressListResponse(addrs []models.Address) []AddressResponse {
	out := make([]AddressResponse, len(addrs))
	for i, a := range addrs {
		out[i] = NewAddressResponse(a)
	}
	return out
}
