package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/repository"
)

// ReviewService implements GET/POST /reviews. Purchase-gating
// (docs/SECURITY.md, docs/DATABASE_SCHEMA.md) is enforced here before any
// row is written: a review may only be created for an order_item that is
// (a) for the same product_id and (b) on an order owned by the reviewing
// user — verified against the database, never trusted from the request body.
//
// db is typed as the narrower repository.Querier (which *pgxpool.Pool
// satisfies) rather than *pgxpool.Pool itself so review_service_test.go can
// exercise the purchase-gating error-mapping logic against a fake Querier
// without a live database.
type ReviewService struct {
	db      repository.Querier
	reviews *repository.ReviewRepository
}

// NewReviewService builds a ReviewService.
func NewReviewService(db *pgxpool.Pool, reviews *repository.ReviewRepository) *ReviewService {
	return &ReviewService{db: db, reviews: reviews}
}

// List returns approved reviews for a product, most recent first, with
// their images attached.
func (s *ReviewService) List(ctx context.Context, productID uuid.UUID, limit, offset int) ([]models.Review, error) {
	revs, err := s.reviews.ListApprovedByProduct(ctx, s.db, productID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("service: list reviews: %w", err)
	}
	if len(revs) == 0 {
		return revs, nil
	}
	ids := make([]uuid.UUID, len(revs))
	for i, r := range revs {
		ids[i] = r.ID
	}
	images, err := s.reviews.ListImages(ctx, s.db, ids)
	if err != nil {
		return nil, fmt.Errorf("service: list review images: %w", err)
	}
	for i := range revs {
		revs[i].Images = images[revs[i].ID]
	}
	return revs, nil
}

// CreateReviewInput is the service-level input for POST /reviews.
type CreateReviewInput struct {
	ProductID   uuid.UUID
	OrderItemID uuid.UUID
	Rating      int
	Text        *string
	Images      []string
}

// Create verifies the purchase-gating rule, then inserts a new review in
// 'pending' status (moderation queue — never auto-approved).
func (s *ReviewService) Create(ctx context.Context, userID uuid.UUID, in CreateReviewInput) (*models.Review, error) {
	if _, err := s.reviews.FindOwnedOrderItem(ctx, s.db, userID, in.ProductID, in.OrderItemID); err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeReviewRequiresPurchase, nil)
		}
		return nil, fmt.Errorf("service: verify purchase: %w", err)
	}

	rev := &models.Review{
		ProductID:   in.ProductID,
		UserID:      userID,
		OrderItemID: in.OrderItemID,
		Rating:      in.Rating,
		Text:        in.Text,
	}
	if err := s.reviews.Create(ctx, s.db, rev); err != nil {
		if err == repository.ErrConflict {
			return nil, apperr.New(apperr.CodeDuplicateReview, nil)
		}
		return nil, fmt.Errorf("service: create review: %w", err)
	}

	if len(in.Images) > 0 {
		if err := s.reviews.InsertImages(ctx, s.db, rev.ID, in.Images); err != nil {
			return nil, fmt.Errorf("service: insert review images: %w", err)
		}
		rev.Images = in.Images
	}
	return rev, nil
}
