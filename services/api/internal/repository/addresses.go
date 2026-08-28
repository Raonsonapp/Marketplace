package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// AddressRepository provides access to the addresses table. Every method
// filters on user_id to enforce ownership (docs/SECURITY.md).
type AddressRepository struct{}

// NewAddressRepository builds an AddressRepository.
func NewAddressRepository() *AddressRepository { return &AddressRepository{} }

const addressColumns = `id, user_id, country, city, street, house, apartment, entrance, floor, intercom, comment, lat, lng, is_default, created_at, updated_at`

func scanAddress(row interface{ Scan(dest ...any) error }) (*models.Address, error) {
	var a models.Address
	if err := row.Scan(&a.ID, &a.UserID, &a.Country, &a.City, &a.Street, &a.House, &a.Apartment, &a.Entrance, &a.Floor, &a.Intercom, &a.Comment, &a.Lat, &a.Lng, &a.IsDefault, &a.CreatedAt, &a.UpdatedAt); err != nil {
		return nil, err
	}
	return &a, nil
}

// List returns all non-deleted addresses for a user, default first.
func (r *AddressRepository) List(ctx context.Context, q Querier, userID uuid.UUID) ([]models.Address, error) {
	rows, err := q.Query(ctx, `
		SELECT `+addressColumns+` FROM addresses
		WHERE user_id = $1::uuid AND deleted_at IS NULL
		ORDER BY is_default DESC, created_at DESC`, userID)
	if err != nil {
		return nil, fmt.Errorf("repository: list addresses: %w", err)
	}
	defer rows.Close()
	var out []models.Address
	for rows.Next() {
		a, err := scanAddress(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan address: %w", err)
		}
		out = append(out, *a)
	}
	return out, rows.Err()
}

// GetByID returns a single address owned by userID, or ErrNotFound.
func (r *AddressRepository) GetByID(ctx context.Context, q Querier, id, userID uuid.UUID) (*models.Address, error) {
	row := q.QueryRow(ctx, `
		SELECT `+addressColumns+` FROM addresses
		WHERE id = $1::uuid AND user_id = $2::uuid AND deleted_at IS NULL`, id, userID)
	a, err := scanAddress(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get address: %w", err)
	}
	return a, nil
}

// Create inserts a new address. When isDefault is true, or it is the user's
// first address, all other addresses are demoted first.
func (r *AddressRepository) Create(ctx context.Context, q Querier, a *models.Address) error {
	if a.IsDefault {
		if _, err := q.Exec(ctx, `UPDATE addresses SET is_default = false WHERE user_id = $1::uuid`, a.UserID); err != nil {
			return fmt.Errorf("repository: demote addresses: %w", err)
		}
	}
	row := q.QueryRow(ctx, `
		INSERT INTO addresses (user_id, country, city, street, house, apartment, entrance, floor, intercom, comment, lat, lng, is_default)
		VALUES ($1::uuid, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
		RETURNING id, created_at, updated_at`,
		a.UserID, a.Country, a.City, a.Street, a.House, a.Apartment, a.Entrance, a.Floor, a.Intercom, a.Comment, a.Lat, a.Lng, a.IsDefault)
	if err := row.Scan(&a.ID, &a.CreatedAt, &a.UpdatedAt); err != nil {
		return fmt.Errorf("repository: create address: %w", err)
	}
	return nil
}

// AddressPatch carries partial-update fields; nil means "leave unchanged".
type AddressPatch struct {
	Country   *string
	City      *string
	Street    *string
	House     *string
	Apartment *string
	Entrance  *string
	Floor     *string
	Intercom  *string
	Comment   *string
	Lat       *float64
	Lng       *float64
	IsDefault *bool
}

// Update applies a partial update, returning the updated row or ErrNotFound.
func (r *AddressRepository) Update(ctx context.Context, q Querier, id, userID uuid.UUID, p AddressPatch) (*models.Address, error) {
	if p.IsDefault != nil && *p.IsDefault {
		if _, err := q.Exec(ctx, `UPDATE addresses SET is_default = false WHERE user_id = $1::uuid`, userID); err != nil {
			return nil, fmt.Errorf("repository: demote addresses: %w", err)
		}
	}
	row := q.QueryRow(ctx, `
		UPDATE addresses SET
			country = COALESCE($3, country),
			city = COALESCE($4, city),
			street = COALESCE($5, street),
			house = COALESCE($6, house),
			apartment = COALESCE($7, apartment),
			entrance = COALESCE($8, entrance),
			floor = COALESCE($9, floor),
			intercom = COALESCE($10, intercom),
			comment = COALESCE($11, comment),
			lat = COALESCE($12, lat),
			lng = COALESCE($13, lng),
			is_default = COALESCE($14, is_default),
			updated_at = now()
		WHERE id = $1::uuid AND user_id = $2::uuid AND deleted_at IS NULL
		RETURNING `+addressColumns,
		id, userID, p.Country, p.City, p.Street, p.House, p.Apartment, p.Entrance, p.Floor, p.Intercom, p.Comment, p.Lat, p.Lng, p.IsDefault)
	a, err := scanAddress(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: update address: %w", err)
	}
	return a, nil
}

// Delete soft-deletes an address owned by userID.
func (r *AddressRepository) Delete(ctx context.Context, q Querier, id, userID uuid.UUID) error {
	tag, err := q.Exec(ctx, `UPDATE addresses SET deleted_at = now() WHERE id = $1::uuid AND user_id = $2::uuid AND deleted_at IS NULL`, id, userID)
	if err != nil {
		return fmt.Errorf("repository: delete address: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}
