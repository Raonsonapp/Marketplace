package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// ReviewRepository provides access to reviews and review_images.
type ReviewRepository struct{}

// NewReviewRepository builds a ReviewRepository.
func NewReviewRepository() *ReviewRepository { return &ReviewRepository{} }

// OwnedOrderItem is the minimal shape needed to enforce purchase-gating: a
// row from order_items joined to orders, filtered on the owning user.
type OwnedOrderItem struct {
	OrderItemID uuid.UUID
	ProductID   uuid.UUID
}

// FindOwnedOrderItem verifies that orderItemID belongs to an order_items row
// for productID, on an order owned by userID (per docs/SECURITY.md's review
// purchase-gating rule). Returns ErrNotFound if no such row exists — the
// caller maps that to CodeReviewRequiresPurchase.
func (r *ReviewRepository) FindOwnedOrderItem(ctx context.Context, q Querier, userID, productID, orderItemID uuid.UUID) (*OwnedOrderItem, error) {
	row := q.QueryRow(ctx, `
		SELECT oi.id, oi.product_id
		FROM order_items oi
		JOIN orders o ON o.id = oi.order_id
		WHERE oi.id = $1::uuid AND oi.product_id = $2::uuid AND o.user_id = $3::uuid`,
		orderItemID, productID, userID)
	var out OwnedOrderItem
	if err := row.Scan(&out.OrderItemID, &out.ProductID); err != nil {
		if isNoRows(err) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("repository: find owned order item: %w", err)
	}
	return &out, nil
}

// Create inserts a new review (status defaults to 'pending' at the DB
// level). ErrConflict is returned when the unique
// (user_id, product_id, order_item_id) constraint is violated.
func (r *ReviewRepository) Create(ctx context.Context, q Querier, rev *models.Review) error {
	row := q.QueryRow(ctx, `
		INSERT INTO reviews (product_id, user_id, order_item_id, rating, text)
		VALUES ($1::uuid, $2::uuid, $3::uuid, $4, $5)
		RETURNING id, status, created_at, updated_at`,
		rev.ProductID, rev.UserID, rev.OrderItemID, rev.Rating, rev.Text)
	if err := row.Scan(&rev.ID, &rev.Status, &rev.CreatedAt, &rev.UpdatedAt); err != nil {
		if isUniqueViolation(err) {
			return ErrConflict
		}
		return fmt.Errorf("repository: create review: %w", err)
	}
	return nil
}

// InsertImages bulk-inserts review_images rows (URLs only, per
// docs/SECURITY.md — file upload handling is out of scope here).
func (r *ReviewRepository) InsertImages(ctx context.Context, q Querier, reviewID uuid.UUID, urls []string) error {
	for _, url := range urls {
		if _, err := q.Exec(ctx, `INSERT INTO review_images (review_id, url) VALUES ($1::uuid, $2)`, reviewID, url); err != nil {
			return fmt.Errorf("repository: insert review image: %w", err)
		}
	}
	return nil
}

// ListImages returns image URLs for a set of reviews, keyed by review id.
func (r *ReviewRepository) ListImages(ctx context.Context, q Querier, reviewIDs []uuid.UUID) (map[uuid.UUID][]string, error) {
	out := make(map[uuid.UUID][]string)
	if len(reviewIDs) == 0 {
		return out, nil
	}
	rows, err := q.Query(ctx, `SELECT review_id, url FROM review_images WHERE review_id = ANY($1::uuid[]) ORDER BY created_at`, reviewIDs)
	if err != nil {
		return nil, fmt.Errorf("repository: list review images: %w", err)
	}
	defer rows.Close()
	for rows.Next() {
		var id uuid.UUID
		var url string
		if err := rows.Scan(&id, &url); err != nil {
			return nil, fmt.Errorf("repository: scan review image: %w", err)
		}
		out[id] = append(out[id], url)
	}
	return out, rows.Err()
}

const reviewColumns = `id, product_id, user_id, order_item_id, rating, text, status, created_at, updated_at`

func scanReview(row interface{ Scan(dest ...any) error }) (*models.Review, error) {
	var rev models.Review
	if err := row.Scan(&rev.ID, &rev.ProductID, &rev.UserID, &rev.OrderItemID, &rev.Rating, &rev.Text, &rev.Status, &rev.CreatedAt, &rev.UpdatedAt); err != nil {
		return nil, err
	}
	return &rev, nil
}

// ListApprovedByProduct returns approved reviews for a product, most recent
// first, paginated.
func (r *ReviewRepository) ListApprovedByProduct(ctx context.Context, q Querier, productID uuid.UUID, limit, offset int) ([]models.Review, error) {
	rows, err := q.Query(ctx, `
		SELECT `+reviewColumns+` FROM reviews
		WHERE product_id = $1::uuid AND status = 'approved'
		ORDER BY created_at DESC LIMIT $2 OFFSET $3`, productID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("repository: list approved reviews: %w", err)
	}
	defer rows.Close()
	var out []models.Review
	for rows.Next() {
		rev, err := scanReview(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan review: %w", err)
		}
		out = append(out, *rev)
	}
	return out, rows.Err()
}
