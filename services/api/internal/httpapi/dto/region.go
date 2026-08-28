package dto

import (
	"tajikshop/api/internal/models"
)

// CityResponse is one deliverable city.
type CityResponse struct {
	ID     string  `json:"id"`
	NameTG string  `json:"name_tg"`
	NameRU string  `json:"name_ru"`
	NameEN string  `json:"name_en"`
	Lat    float64 `json:"lat"`
	Lng    float64 `json:"lng"`
}

// CountryResponse is one market, with everything the client needs to
// localise money, phone input and the address map.
type CountryResponse struct {
	Code         string         `json:"code"`
	NameTG       string         `json:"name_tg"`
	NameRU       string         `json:"name_ru"`
	NameEN       string         `json:"name_en"`
	CurrencyCode string         `json:"currency_code"`
	CurrencyTG   string         `json:"currency_tg"`
	CurrencyRU   string         `json:"currency_ru"`
	CurrencyEN   string         `json:"currency_en"`
	DialCode     string         `json:"dial_code"`
	CenterLat    float64        `json:"center_lat"`
	CenterLng    float64        `json:"center_lng"`
	Cities       []CityResponse `json:"cities"`
}

// NewCityListResponse converts a slice of cities.
func NewCityListResponse(cities []models.City) []CityResponse {
	out := make([]CityResponse, len(cities))
	for i, c := range cities {
		out[i] = CityResponse{
			ID: c.ID.String(), NameTG: c.NameTG, NameRU: c.NameRU, NameEN: c.NameEN,
			Lat: c.Lat, Lng: c.Lng,
		}
	}
	return out
}

// NewCountryListResponse converts countries plus their cities, keyed by
// country code.
func NewCountryListResponse(countries []models.Country, cities map[string][]models.City) []CountryResponse {
	out := make([]CountryResponse, len(countries))
	for i, c := range countries {
		out[i] = CountryResponse{
			Code: c.Code, NameTG: c.NameTG, NameRU: c.NameRU, NameEN: c.NameEN,
			CurrencyCode: c.CurrencyCode, CurrencyTG: c.CurrencyTG,
			CurrencyRU: c.CurrencyRU, CurrencyEN: c.CurrencyEN,
			DialCode: c.DialCode, CenterLat: c.CenterLat, CenterLng: c.CenterLng,
			Cities: NewCityListResponse(cities[c.Code]),
		}
	}
	return out
}
