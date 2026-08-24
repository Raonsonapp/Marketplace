package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// SellerApplicationRepository provides access to seller_applications.
type SellerApplicationRepository struct{}

// NewSellerApplicationRepository builds a SellerApplicationRepository.
func NewSellerApplicationRepository() *SellerApplicationRepository {
	return &SellerApplicationRepository{}
}

const sellerApplicationColumns = `
	id, user_id, birth_date, store_lat, store_lng, store_website, store_instagram,
	store_telegram, store_whatsapp, passport_front_key, passport_back_key,
	selfie_with_passport_key, live_selfie_key, liveness_passed, face_match_score,
	status, rejection_reason, reviewed_at, created_at, updated_at`

func scanSellerApplication(row interface {
	Scan(dest ...any) error
}) (*models.SellerApplication, error) {
	var a models.SellerApplication
	if err := row.Scan(
		&a.ID, &a.UserID, &a.BirthDate, &a.StoreLat, &a.StoreLng, &a.StoreWebsite, &a.StoreInstagram,
		&a.StoreTelegram, &a.StoreWhatsapp, &a.PassportFrontKey, &a.PassportBackKey,
		&a.SelfieWithPassportKey, &a.LiveSelfieKey, &a.LivenessPassed, &a.FaceMatchScore,
		&a.Status, &a.RejectionReason, &a.ReviewedAt, &a.CreatedAt, &a.UpdatedAt,
	); err != nil {
		return nil, err
	}
	return &a, nil
}

// Create inserts a new seller application. ErrConflict is returned when the
// user already has one (the (user_id) UNIQUE constraint) — the service maps
// that to CodeSellerApplicationExists.
func (r *SellerApplicationRepository) Create(ctx context.Context, q Querier, a *models.SellerApplication) error {
	row := q.QueryRow(ctx, `
		INSERT INTO seller_applications (
			user_id, birth_date, store_lat, store_lng, store_website, store_instagram,
			store_telegram, store_whatsapp, passport_front_key, passport_back_key,
			selfie_with_passport_key, live_selfie_key, liveness_passed, face_match_score, status
		) VALUES ($1::uuid, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
		RETURNING `+sellerApplicationColumns,
		a.UserID, a.BirthDate, a.StoreLat, a.StoreLng, a.StoreWebsite, a.StoreInstagram,
		a.StoreTelegram, a.StoreWhatsapp, a.PassportFrontKey, a.PassportBackKey,
		a.SelfieWithPassportKey, a.LiveSelfieKey, a.LivenessPassed, a.FaceMatchScore, a.Status,
	)
	saved, err := scanSellerApplication(row)
	if err != nil {
		if isUniqueViolation(err) {
			return ErrConflict
		}
		return fmt.Errorf("repository: create seller application: %w", err)
	}
	*a = *saved
	return nil
}

// GetByUserID returns the given user's seller application, or ErrNotFound.
func (r *SellerApplicationRepository) GetByUserID(ctx context.Context, q Querier, userID uuid.UUID) (*models.SellerApplication, error) {
	row := q.QueryRow(ctx, `SELECT `+sellerApplicationColumns+` FROM seller_applications WHERE user_id = $1::uuid`, userID)
	a, err := scanSellerApplication(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get seller application: %w", err)
	}
	return a, nil
}
