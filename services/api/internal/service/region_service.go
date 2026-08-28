package service

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/repository"
)

// RegionService serves the countries/cities reference data the app needs to
// operate in both Tajikistan and Russia: which currency to print, which dial
// code to prefill, where to open the address map, and which cities can be
// delivered to.
type RegionService struct {
	db     *pgxpool.Pool
	region *repository.RegionRepository
}

// NewRegionService builds a RegionService.
func NewRegionService(db *pgxpool.Pool, region *repository.RegionRepository) *RegionService {
	return &RegionService{db: db, region: region}
}

// Countries returns every active market together with its cities, so the
// client can cache the whole picker from one request.
func (s *RegionService) Countries(ctx context.Context) ([]models.Country, map[string][]models.City, error) {
	countries, err := s.region.ListCountries(ctx, s.db)
	if err != nil {
		return nil, nil, fmt.Errorf("service: countries: %w", err)
	}
	cities, err := s.region.ListCities(ctx, s.db, "")
	if err != nil {
		return nil, nil, fmt.Errorf("service: cities: %w", err)
	}
	byCountry := make(map[string][]models.City, len(countries))
	for _, c := range cities {
		byCountry[c.CountryCode] = append(byCountry[c.CountryCode], c)
	}
	return countries, byCountry, nil
}

// Cities returns the deliverable cities of one country.
func (s *RegionService) Cities(ctx context.Context, countryCode string) ([]models.City, error) {
	cities, err := s.region.ListCities(ctx, s.db, NormalizeCountry(countryCode))
	if err != nil {
		return nil, fmt.Errorf("service: cities: %w", err)
	}
	return cities, nil
}

// NormalizeCountry upper-cases a country code and drops anything that is not
// a two-letter code, so a malformed client value degrades to "no filter"
// rather than to a query that matches nothing.
func NormalizeCountry(code string) string {
	code = strings.ToUpper(strings.TrimSpace(code))
	if len(code) != 2 {
		return ""
	}
	return code
}

// DefaultCountry is the market a row belongs to when nothing says otherwise
// — the app was Tajikistan-only before migration 0007, and every existing
// row was written under that assumption.
const DefaultCountry = "TJ"
