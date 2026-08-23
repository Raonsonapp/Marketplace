package dto

import (
	"time"

	"tajikshop/api/internal/models"
)

// CreateReviewRequest is the body for POST /reviews. Purchase-gating
// (order_item_id must belong to the caller's purchase of product_id) is
// enforced in the service layer, not here — this is shape validation only.
type CreateReviewRequest struct {
	ProductID   string   `json:"product_id" binding:"required"`
	OrderItemID string   `json:"order_item_id" binding:"required"`
	Rating      int      `json:"rating" binding:"required,min=1,max=5"`
	Text        *string  `json:"text"`
	Images      []string `json:"images"`
}

// ReviewResponse mirrors one review for API responses.
type ReviewResponse struct {
	ID          string    `json:"id"`
	ProductID   string    `json:"product_id"`
	UserID      string    `json:"user_id"`
	OrderItemID string    `json:"order_item_id"`
	Rating      int       `json:"rating"`
	Text        *string   `json:"text,omitempty"`
	Status      string    `json:"status"`
	Images      []string  `json:"images"`
	CreatedAt   time.Time `json:"created_at"`
}

// NewReviewResponse converts a models.Review.
func NewReviewResponse(r *models.Review) ReviewResponse {
	images := r.Images
	if images == nil {
		images = []string{}
	}
	return ReviewResponse{
		ID: r.ID.String(), ProductID: r.ProductID.String(), UserID: r.UserID.String(), OrderItemID: r.OrderItemID.String(),
		Rating: r.Rating, Text: r.Text, Status: r.Status, Images: images, CreatedAt: r.CreatedAt,
	}
}

// NewReviewListResponse converts a slice of reviews.
func NewReviewListResponse(revs []models.Review) []ReviewResponse {
	out := make([]ReviewResponse, len(revs))
	for i, r := range revs {
		rc := r
		out[i] = NewReviewResponse(&rc)
	}
	return out
}
