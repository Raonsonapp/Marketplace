package repository

import (
	"context"
	"fmt"

	"tajikshop/api/internal/models"
)

// RegionRepository reads the countries/cities reference tables that make the
// app work in both Tajikistan and Russia (migration 0007). They are small,
// slow-changing lookup tables, so every method reads the whole active set.
type RegionRepository struct{}

// NewRegionRepository builds a RegionRepository.
func NewRegionRepository() *RegionRepository { return &RegionRepository{} }

const countryColumns = `code, name_tg, name_ru, name_en, currency_code, currency_tg, currency_ru, currency_en, dial_code, center_lat, center_lng, sort_order`

const cityColumns = `id, country_code, name_tg, name_ru, name_en, lat, lng, sort_order`

// ListCountries returns every active market, in display order.
func (r *RegionRepository) ListCountries(ctx context.Context, q Querier) ([]models.Country, error) {
	rows, err := q.Query(ctx, `SELECT `+countryColumns+` FROM countries WHERE is_active = true ORDER BY sort_order, code`)
	if err != nil {
		return nil, fmt.Errorf("repository: list countries: %w", err)
	}
	defer rows.Close()
	var out []models.Country
	for rows.Next() {
		var c models.Country
		if err := rows.Scan(&c.Code, &c.NameTG, &c.NameRU, &c.NameEN, &c.CurrencyCode,
			&c.CurrencyTG, &c.CurrencyRU, &c.CurrencyEN, &c.DialCode,
			&c.CenterLat, &c.CenterLng, &c.SortOrder); err != nil {
			return nil, fmt.Errorf("repository: scan country: %w", err)
		}
		out = append(out, c)
	}
	return out, rows.Err()
}

// ListCities returns every active city, optionally narrowed to one country.
// An empty countryCode means "all countries", which is what the client asks
// for on first launch so it can cache the whole picker in one call.
func (r *RegionRepository) ListCities(ctx context.Context, q Querier, countryCode string) ([]models.City, error) {
	sql := `SELECT ` + cityColumns + ` FROM cities WHERE is_active = true`
	args := []any{}
	if countryCode != "" {
		sql += ` AND country_code = $1`
		args = append(args, countryCode)
	}
	sql += ` ORDER BY country_code, sort_order, name_en`
	rows, err := q.Query(ctx, sql, args...)
	if err != nil {
		return nil, fmt.Errorf("repository: list cities: %w", err)
	}
	defer rows.Close()
	var out []models.City
	for rows.Next() {
		var c models.City
		if err := rows.Scan(&c.ID, &c.CountryCode, &c.NameTG, &c.NameRU, &c.NameEN,
			&c.Lat, &c.Lng, &c.SortOrder); err != nil {
			return nil, fmt.Errorf("repository: scan city: %w", err)
		}
		out = append(out, c)
	}
	return out, rows.Err()
}
