package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// StoreRepository provides access to stores, store_hours, and delivery_zones.
type StoreRepository struct{}

// NewStoreRepository builds a StoreRepository.
func NewStoreRepository() *StoreRepository { return &StoreRepository{} }

const storeColumns = `id, name, slug, logo_url, address, country, city, lat, lng, phone, is_delivery_available, is_pickup_available, is_active, created_at, updated_at`

func scanStore(row interface{ Scan(dest ...any) error }) (*models.Store, error) {
	var s models.Store
	if err := row.Scan(&s.ID, &s.Name, &s.Slug, &s.LogoURL, &s.Address, &s.Country, &s.City, &s.Lat, &s.Lng, &s.Phone, &s.IsDeliveryAvailable, &s.IsPickupAvailable, &s.IsActive, &s.CreatedAt, &s.UpdatedAt); err != nil {
		return nil, err
	}
	return &s, nil
}

// ListActive returns every active store, optionally narrowed by country
// and/or city. An empty string means "don't filter on this".
func (r *StoreRepository) ListActive(ctx context.Context, q Querier, country, city string) ([]models.Store, error) {
	sql := `SELECT ` + storeColumns + ` FROM stores WHERE is_active = true AND deleted_at IS NULL`
	args := []any{}
	if country != "" {
		args = append(args, country)
		sql += fmt.Sprintf(` AND country = $%d`, len(args))
	}
	if city != "" {
		args = append(args, city)
		sql += fmt.Sprintf(` AND city = $%d`, len(args))
	}
	sql += ` ORDER BY name`
	return queryStores(ctx, q, sql, args...)
}

func queryStores(ctx context.Context, q Querier, sql string, args ...any) ([]models.Store, error) {
	rows, err := q.Query(ctx, sql, args...)
	if err != nil {
		return nil, fmt.Errorf("repository: list stores: %w", err)
	}
	defer rows.Close()
	var out []models.Store
	for rows.Next() {
		s, err := scanStore(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan store: %w", err)
		}
		out = append(out, *s)
	}
	return out, rows.Err()
}

// GetByID returns a single active store, or ErrNotFound.
func (r *StoreRepository) GetByID(ctx context.Context, q Querier, id uuid.UUID) (*models.Store, error) {
	row := q.QueryRow(ctx, `SELECT `+storeColumns+` FROM stores WHERE id = $1::uuid AND deleted_at IS NULL`, id)
	s, err := scanStore(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get store: %w", err)
	}
	return s, nil
}

// Hours returns the weekly opening hours for a store.
func (r *StoreRepository) Hours(ctx context.Context, q Querier, storeID uuid.UUID) ([]models.StoreHours, error) {
	rows, err := q.Query(ctx, `
		SELECT id, store_id, day_of_week, opens_at::text, closes_at::text, is_closed
		FROM store_hours WHERE store_id = $1::uuid ORDER BY day_of_week`, storeID)
	if err != nil {
		return nil, fmt.Errorf("repository: store hours: %w", err)
	}
	defer rows.Close()
	var out []models.StoreHours
	for rows.Next() {
		var h models.StoreHours
		if err := rows.Scan(&h.ID, &h.StoreID, &h.DayOfWeek, &h.OpensAt, &h.ClosesAt, &h.IsClosed); err != nil {
			return nil, fmt.Errorf("repository: scan store hours: %w", err)
		}
		out = append(out, h)
	}
	return out, rows.Err()
}

// Zones returns the active delivery zones for a store.
func (r *StoreRepository) Zones(ctx context.Context, q Querier, storeID uuid.UUID) ([]models.DeliveryZone, error) {
	rows, err := q.Query(ctx, `
		SELECT id, store_id, name, polygon, delivery_fee::text, min_order_amount::text, free_delivery_threshold::text,
		       estimated_minutes_min, estimated_minutes_max, is_active
		FROM delivery_zones WHERE store_id = $1::uuid AND is_active = true`, storeID)
	if err != nil {
		return nil, fmt.Errorf("repository: delivery zones: %w", err)
	}
	defer rows.Close()
	var out []models.DeliveryZone
	for rows.Next() {
		var z models.DeliveryZone
		var freeThreshold *string
		if err := rows.Scan(&z.ID, &z.StoreID, &z.Name, &z.Polygon, &z.DeliveryFee, &z.MinOrderAmount, &freeThreshold,
			&z.EstimatedMinutesMin, &z.EstimatedMinutesMax, &z.IsActive); err != nil {
			return nil, fmt.Errorf("repository: scan delivery zone: %w", err)
		}
		z.FreeDeliveryThreshold = freeThreshold
		out = append(out, z)
	}
	return out, rows.Err()
}
