package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// UserRepository provides access to the users table.
type UserRepository struct{}

// NewUserRepository builds a UserRepository.
func NewUserRepository() *UserRepository { return &UserRepository{} }

const userColumns = `id, phone, full_name, email, role, avatar_url, language, google_id, is_active, created_at, updated_at`

func scanUser(row interface {
	Scan(dest ...any) error
}) (*models.User, error) {
	var u models.User
	if err := row.Scan(&u.ID, &u.Phone, &u.FullName, &u.Email, &u.Role, &u.AvatarURL, &u.Language, &u.GoogleID, &u.IsActive, &u.CreatedAt, &u.UpdatedAt); err != nil {
		return nil, err
	}
	return &u, nil
}

// GetByPhone returns the active user with the given phone, or ErrNotFound.
func (r *UserRepository) GetByPhone(ctx context.Context, q Querier, phone string) (*models.User, error) {
	row := q.QueryRow(ctx, `SELECT `+userColumns+` FROM users WHERE phone = $1 AND deleted_at IS NULL`, phone)
	u, err := scanUser(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get user by phone: %w", err)
	}
	return u, nil
}

// GetByID returns the active user with the given id, or ErrNotFound.
func (r *UserRepository) GetByID(ctx context.Context, q Querier, id uuid.UUID) (*models.User, error) {
	row := q.QueryRow(ctx, `SELECT `+userColumns+` FROM users WHERE id = $1::uuid AND deleted_at IS NULL`, id)
	u, err := scanUser(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get user by id: %w", err)
	}
	return u, nil
}

// Create inserts a brand-new customer for phone, used on first-ever OTP
// verification for a number.
func (r *UserRepository) Create(ctx context.Context, q Querier, phone string) (*models.User, error) {
	row := q.QueryRow(ctx, `
		INSERT INTO users (phone, role, language)
		VALUES ($1, 'customer', 'tj')
		RETURNING `+userColumns, phone)
	u, err := scanUser(row)
	if err != nil {
		return nil, fmt.Errorf("repository: create user: %w", err)
	}
	return u, nil
}

// UpdateProfile applies a partial update (nil fields are left unchanged) to
// full_name/email/language and returns the updated row.
func (r *UserRepository) UpdateProfile(ctx context.Context, q Querier, id uuid.UUID, fullName, email, language *string) (*models.User, error) {
	row := q.QueryRow(ctx, `
		UPDATE users SET
			full_name = COALESCE($2, full_name),
			email = COALESCE($3, email),
			language = COALESCE($4, language),
			updated_at = now()
		WHERE id = $1::uuid AND deleted_at IS NULL
		RETURNING `+userColumns, id, fullName, email, language)
	u, err := scanUser(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: update profile: %w", err)
	}
	return u, nil
}
