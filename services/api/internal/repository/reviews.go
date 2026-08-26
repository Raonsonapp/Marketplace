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

// Create inserts a new review. Status is set to 'approved' on insert: this
// app ships no moderation panel, so a 'pending' review (the table default)
// would never become visible — reviews are shown immediately, the same as
// most marketplace apps. ErrConflict is returned when the unique
// (user_id, product_id, order_item_id) constraint is violated.
func (r *ReviewRepository) Create(ctx context.Context, q Querier, rev *models.Review) error {
	row := q.QueryRow(ctx, `
		INSERT INTO reviews (product_id, user_id, order_item_id, rating, text, status)
		VALUES ($1::uuid, $2::uuid, $3::uuid, $4, $5, 'approved')
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
	// Passed as strings, not []uuid.UUID — see products.go's attachImages
	// doc comment on why a bare []uuid.UUID breaks under this pool's
	// simple-protocol mode.
	ids := make([]string, len(reviewIDs))
	for i, id := range reviewIDs {
		ids[i] = id.String()
	}
	rows, err := q.Query(ctx, `SELECT review_id, url FROM review_images WHERE review_id = ANY($1::uuid[]) ORDER BY created_at`, ids)
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

// ListApprovedByProduct returns approved reviews for a product, most recent
// first, paginated. Each row carries the reviewer's display name (joined
// from users, falling back to empty), the helpful-vote count, and — when
// viewerID is non-nil — whether that user has voted the review helpful.
// Reviews with more helpful votes float above equally-recent ones, the way
// a "most helpful first" sort works on a real marketplace.
func (r *ReviewRepository) ListApprovedByProduct(ctx context.Context, q Querier, productID uuid.UUID, viewerID *uuid.UUID, limit, offset int) ([]models.Review, error) {
	var viewerArg any
	if viewerID != nil {
		viewerArg = viewerID.String()
	}
	rows, err := q.Query(ctx, `
		SELECT r.id, r.product_id, r.user_id, r.order_item_id, r.rating, r.text, r.status,
		       r.created_at, r.updated_at, r.helpful_count,
		       COALESCE(u.full_name, ''),
		       ($4::uuid IS NOT NULL AND EXISTS (
		           SELECT 1 FROM review_helpful_votes v
		           WHERE v.review_id = r.id AND v.user_id = $4::uuid)) AS viewer_voted
		FROM reviews r
		JOIN users u ON u.id = r.user_id
		WHERE r.product_id = $1::uuid AND r.status = 'approved'
		ORDER BY r.helpful_count DESC, r.created_at DESC
		LIMIT $2 OFFSET $3`, productID, limit, offset, viewerArg)
	if err != nil {
		return nil, fmt.Errorf("repository: list approved reviews: %w", err)
	}
	defer rows.Close()
	var out []models.Review
	for rows.Next() {
		var rev models.Review
		if err := rows.Scan(&rev.ID, &rev.ProductID, &rev.UserID, &rev.OrderItemID, &rev.Rating, &rev.Text, &rev.Status,
			&rev.CreatedAt, &rev.UpdatedAt, &rev.HelpfulCount, &rev.ReviewerName, &rev.ViewerVoted); err != nil {
			return nil, fmt.Errorf("repository: scan review: %w", err)
		}
		out = append(out, rev)
	}
	return out, rows.Err()
}

// AddHelpfulVote records userID's helpful vote for reviewID and bumps the
// denormalized counter, both inside q (a transaction). A repeat vote is a
// no-op (idempotent) and does not double-count. Returns the new count.
func (r *ReviewRepository) AddHelpfulVote(ctx context.Context, q Querier, reviewID, userID uuid.UUID) (int, error) {
	tag, err := q.Exec(ctx, `
		INSERT INTO review_helpful_votes (review_id, user_id) VALUES ($1::uuid, $2::uuid)
		ON CONFLICT (review_id, user_id) DO NOTHING`, reviewID, userID)
	if err != nil {
		return 0, fmt.Errorf("repository: add helpful vote: %w", err)
	}
	if tag.RowsAffected() > 0 {
		if _, err := q.Exec(ctx, `UPDATE reviews SET helpful_count = helpful_count + 1 WHERE id = $1::uuid`, reviewID); err != nil {
			return 0, fmt.Errorf("repository: bump helpful count: %w", err)
		}
	}
	return r.helpfulCount(ctx, q, reviewID)
}

// RemoveHelpfulVote withdraws userID's helpful vote and decrements the
// counter. Removing a vote that isn't there is a no-op. Returns the new count.
func (r *ReviewRepository) RemoveHelpfulVote(ctx context.Context, q Querier, reviewID, userID uuid.UUID) (int, error) {
	tag, err := q.Exec(ctx, `DELETE FROM review_helpful_votes WHERE review_id = $1::uuid AND user_id = $2::uuid`, reviewID, userID)
	if err != nil {
		return 0, fmt.Errorf("repository: remove helpful vote: %w", err)
	}
	if tag.RowsAffected() > 0 {
		if _, err := q.Exec(ctx, `UPDATE reviews SET helpful_count = GREATEST(helpful_count - 1, 0) WHERE id = $1::uuid`, reviewID); err != nil {
			return 0, fmt.Errorf("repository: lower helpful count: %w", err)
		}
	}
	return r.helpfulCount(ctx, q, reviewID)
}

func (r *ReviewRepository) helpfulCount(ctx context.Context, q Querier, reviewID uuid.UUID) (int, error) {
	var count int
	if err := q.QueryRow(ctx, `SELECT helpful_count FROM reviews WHERE id = $1::uuid`, reviewID).Scan(&count); err != nil {
		if isNoRows(err) {
			return 0, ErrNotFound
		}
		return 0, fmt.Errorf("repository: get helpful count: %w", err)
	}
	return count, nil
}
