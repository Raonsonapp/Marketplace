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

// phone is COALESCEd because an email-registered account has none until the
// user adds one (migration 0006 relaxed users.phone NOT NULL). Reading it as
// "" keeps models.User.Phone a plain string for every existing caller
// instead of turning it into a pointer across the whole codebase.
const userColumns = `id, COALESCE(phone, '') AS phone, full_name, email, role, avatar_url, language, country, google_id, is_active, created_at, updated_at`

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

// GetByEmail returns the active user with the given email, or ErrNotFound.
// Email is the login identifier since OTP codes are delivered by mail
// (internal/pkg/otp/email.go); it is matched case-insensitively because
// mail addresses are, in practice, not case-sensitive and users type them
// inconsistently.
func (r *UserRepository) GetByEmail(ctx context.Context, q Querier, email string) (*models.User, error) {
	row := q.QueryRow(ctx, `SELECT `+userColumns+` FROM users WHERE lower(email) = lower($1) AND deleted_at IS NULL`, email)
	u, err := scanUser(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get user by email: %w", err)
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
// verification for a number (the Firebase phone-auth path).
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

// CreateWithEmail inserts a brand-new customer for email, used on the
// first-ever OTP verification for an address. phone stays NULL until the
// user adds one in their profile (migration 0006 relaxed its NOT NULL for
// exactly this).
func (r *UserRepository) CreateWithEmail(ctx context.Context, q Querier, email string) (*models.User, error) {
	row := q.QueryRow(ctx, `
		INSERT INTO users (email, role, language)
		VALUES (lower($1), 'customer', 'tj')
		RETURNING `+userColumns, email)
	u, err := scanUser(row)
	if err != nil {
		return nil, fmt.Errorf("repository: create user by email: %w", err)
	}
	return u, nil
}

// UpdateRole sets a user's role (e.g. promoting to 'store_manager' on
// seller-application approval).
func (r *UserRepository) UpdateRole(ctx context.Context, q Querier, id uuid.UUID, role string) error {
	tag, err := q.Exec(ctx, `UPDATE users SET role = $2, updated_at = now() WHERE id = $1::uuid AND deleted_at IS NULL`, id, role)
	if err != nil {
		return fmt.Errorf("repository: update role: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

// UpdateProfile applies a partial update (nil fields are left unchanged) to
// full_name/email/language and returns the updated row.
func (r *UserRepository) UpdateProfile(ctx context.Context, q Querier, id uuid.UUID, fullName, email, language, country *string) (*models.User, error) {
	row := q.QueryRow(ctx, `
		UPDATE users SET
			full_name = COALESCE($2, full_name),
			email = COALESCE($3, email),
			language = COALESCE($4, language),
			country = COALESCE($5, country),
			updated_at = now()
		WHERE id = $1::uuid AND deleted_at IS NULL
		RETURNING `+userColumns, id, fullName, email, language, country)
	u, err := scanUser(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		if isUniqueViolation(err) {
			return nil, ErrConflict
		}
		return nil, fmt.Errorf("repository: update profile: %w", err)
	}
	return u, nil
}
