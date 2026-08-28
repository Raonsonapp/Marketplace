package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// CargoRepository provides access to cargo_tariffs and cargo_shipments
// (migration 0008 — parcel forwarding from China to TJ/RU).
type CargoRepository struct{}

// NewCargoRepository builds a CargoRepository.
func NewCargoRepository() *CargoRepository { return &CargoRepository{} }

const cargoTariffColumns = `destination, rate_per_kg, warehouse_address, contact_phone, estimated_days_min, estimated_days_max, is_active, updated_at`

func scanCargoTariff(row interface{ Scan(dest ...any) error }) (*models.CargoTariff, error) {
	var t models.CargoTariff
	if err := row.Scan(&t.Destination, &t.RatePerKg, &t.WarehouseAddress, &t.ContactPhone,
		&t.EstimatedDaysMin, &t.EstimatedDaysMax, &t.IsActive, &t.UpdatedAt); err != nil {
		return nil, err
	}
	return &t, nil
}

// ListActiveTariffs returns the destinations parcel forwarding is actually
// offered for — an operator has to fill in a warehouse address and a rate
// and flip is_active before a destination appears to shoppers.
func (r *CargoRepository) ListActiveTariffs(ctx context.Context, q Querier) ([]models.CargoTariff, error) {
	rows, err := q.Query(ctx, `SELECT `+cargoTariffColumns+` FROM cargo_tariffs WHERE is_active = true ORDER BY destination`)
	if err != nil {
		return nil, fmt.Errorf("repository: list cargo tariffs: %w", err)
	}
	defer rows.Close()
	var out []models.CargoTariff
	for rows.Next() {
		t, err := scanCargoTariff(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan cargo tariff: %w", err)
		}
		out = append(out, *t)
	}
	return out, rows.Err()
}

// GetTariff returns one destination's tariff whether or not it is active —
// admin edits and cost recalculation need the inactive rows too.
func (r *CargoRepository) GetTariff(ctx context.Context, q Querier, destination string) (*models.CargoTariff, error) {
	row := q.QueryRow(ctx, `SELECT `+cargoTariffColumns+` FROM cargo_tariffs WHERE destination = $1`, destination)
	t, err := scanCargoTariff(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get cargo tariff: %w", err)
	}
	return t, nil
}

// UpsertTariff writes a destination's tariff, creating the row if the
// country was added after migration 0008 seeded TJ and RU.
func (r *CargoRepository) UpsertTariff(ctx context.Context, q Querier, t *models.CargoTariff) error {
	row := q.QueryRow(ctx, `
		INSERT INTO cargo_tariffs (destination, rate_per_kg, warehouse_address, contact_phone, estimated_days_min, estimated_days_max, is_active, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, now())
		ON CONFLICT (destination) DO UPDATE SET
			rate_per_kg = EXCLUDED.rate_per_kg,
			warehouse_address = EXCLUDED.warehouse_address,
			contact_phone = EXCLUDED.contact_phone,
			estimated_days_min = EXCLUDED.estimated_days_min,
			estimated_days_max = EXCLUDED.estimated_days_max,
			is_active = EXCLUDED.is_active,
			updated_at = now()
		RETURNING `+cargoTariffColumns,
		t.Destination, t.RatePerKg, t.WarehouseAddress, t.ContactPhone,
		t.EstimatedDaysMin, t.EstimatedDaysMax, t.IsActive)
	updated, err := scanCargoTariff(row)
	if err != nil {
		return fmt.Errorf("repository: upsert cargo tariff: %w", err)
	}
	*t = *updated
	return nil
}

const cargoShipmentColumns = `id, user_id, track_code, product_link, description, destination, weight_kg, cost, status, note, created_at, updated_at`

func scanCargoShipment(row interface{ Scan(dest ...any) error }) (*models.CargoShipment, error) {
	var s models.CargoShipment
	if err := row.Scan(&s.ID, &s.UserID, &s.TrackCode, &s.ProductLink, &s.Description,
		&s.Destination, &s.WeightKg, &s.Cost, &s.Status, &s.Note, &s.CreatedAt, &s.UpdatedAt); err != nil {
		return nil, err
	}
	return &s, nil
}

func queryCargoShipments(ctx context.Context, q Querier, sql string, args ...any) ([]models.CargoShipment, error) {
	rows, err := q.Query(ctx, sql, args...)
	if err != nil {
		return nil, fmt.Errorf("repository: list cargo shipments: %w", err)
	}
	defer rows.Close()
	var out []models.CargoShipment
	for rows.Next() {
		s, err := scanCargoShipment(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan cargo shipment: %w", err)
		}
		out = append(out, *s)
	}
	return out, rows.Err()
}

// ListByUser returns one user's parcels, newest first.
func (r *CargoRepository) ListByUser(ctx context.Context, q Querier, userID uuid.UUID, limit, offset int) ([]models.CargoShipment, error) {
	return queryCargoShipments(ctx, q, `
		SELECT `+cargoShipmentColumns+` FROM cargo_shipments
		WHERE user_id = $1::uuid
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3`, userID, limit, offset)
}

// ListAll returns every parcel for the operator's queue, unfinished ones
// first (a delivered or cancelled parcel needs no attention), then oldest
// first within a status so nothing waits behind newer work.
func (r *CargoRepository) ListAll(ctx context.Context, q Querier, status string, limit, offset int) ([]models.CargoShipment, error) {
	sql := `SELECT ` + cargoShipmentColumns + ` FROM cargo_shipments`
	args := []any{}
	if status != "" {
		args = append(args, status)
		sql += fmt.Sprintf(` WHERE status = $%d`, len(args))
	}
	sql += `
		ORDER BY CASE status
			WHEN 'new' THEN 0 WHEN 'received' THEN 1 WHEN 'shipped' THEN 2
			WHEN 'arrived' THEN 3 ELSE 4 END, created_at`
	args = append(args, limit, offset)
	sql += fmt.Sprintf(` LIMIT $%d OFFSET $%d`, len(args)-1, len(args))
	return queryCargoShipments(ctx, q, sql, args...)
}

// GetByID returns one parcel. userID scopes it to its owner; pass
// uuid.Nil for the operator's unscoped lookup.
func (r *CargoRepository) GetByID(ctx context.Context, q Querier, id, userID uuid.UUID) (*models.CargoShipment, error) {
	sql := `SELECT ` + cargoShipmentColumns + ` FROM cargo_shipments WHERE id = $1::uuid`
	args := []any{id}
	if userID != uuid.Nil {
		args = append(args, userID)
		sql += ` AND user_id = $2::uuid`
	}
	s, err := scanCargoShipment(q.QueryRow(ctx, sql, args...))
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get cargo shipment: %w", err)
	}
	return s, nil
}

// Create registers a parcel.
func (r *CargoRepository) Create(ctx context.Context, q Querier, s *models.CargoShipment) error {
	row := q.QueryRow(ctx, `
		INSERT INTO cargo_shipments (user_id, track_code, product_link, description, destination)
		VALUES ($1::uuid, $2, $3, $4, $5)
		RETURNING `+cargoShipmentColumns,
		s.UserID, s.TrackCode, s.ProductLink, s.Description, s.Destination)
	created, err := scanCargoShipment(row)
	if err != nil {
		return fmt.Errorf("repository: create cargo shipment: %w", err)
	}
	*s = *created
	return nil
}

// CargoShipmentPatch carries the operator's edits; nil means "unchanged".
type CargoShipmentPatch struct {
	TrackCode *string
	WeightKg  *float64
	Status    *string
	Note      *string
}

// UpdateByOperator applies an operator's edits. cost is passed in already
// computed rather than derived here, so the weight × rate arithmetic stays
// in the service layer where it is unit-testable.
func (r *CargoRepository) UpdateByOperator(ctx context.Context, q Querier, id uuid.UUID, p CargoShipmentPatch, cost money.Money) (*models.CargoShipment, error) {
	row := q.QueryRow(ctx, `
		UPDATE cargo_shipments SET
			track_code = COALESCE($2, track_code),
			weight_kg  = COALESCE($3, weight_kg),
			cost       = $4,
			status     = COALESCE($5, status),
			note       = COALESCE($6, note),
			updated_at = now()
		WHERE id = $1::uuid
		RETURNING `+cargoShipmentColumns,
		id, p.TrackCode, p.WeightKg, cost, p.Status, p.Note)
	s, err := scanCargoShipment(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: update cargo shipment: %w", err)
	}
	return s, nil
}

// CancelByUser lets an owner withdraw a parcel that the warehouse has not
// touched yet. Anything past 'new' is physically in motion and only an
// operator can change it.
func (r *CargoRepository) CancelByUser(ctx context.Context, q Querier, id, userID uuid.UUID) (*models.CargoShipment, error) {
	row := q.QueryRow(ctx, `
		UPDATE cargo_shipments SET status = 'cancelled', updated_at = now()
		WHERE id = $1::uuid AND user_id = $2::uuid AND status = 'new'
		RETURNING `+cargoShipmentColumns, id, userID)
	s, err := scanCargoShipment(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: cancel cargo shipment: %w", err)
	}
	return s, nil
}
