package models

import (
	"time"

	"github.com/google/uuid"
)

// Review status values, matching reviews.status CHECK constraint.
const (
	ReviewStatusPending  = "pending"
	ReviewStatusApproved = "approved"
	ReviewStatusHidden   = "hidden"
)

// Review mirrors the reviews table. A review can only exist for a purchase
// the reviewing user actually made (order_item_id FK + the unique
// (user_id, product_id, order_item_id) constraint), per docs/SECURITY.md.
type Review struct {
	ID          uuid.UUID
	ProductID   uuid.UUID
	UserID      uuid.UUID
	OrderItemID uuid.UUID
	Rating      int
	Text        *string
	Status      string
	CreatedAt   time.Time
	UpdatedAt   time.Time

	Images       []string
	HelpfulCount int
	// ReviewerName is the reviewer's display name, joined from users at
	// read time (never their phone/id). ViewerVoted is whether the
	// requesting user has marked this review helpful (nil for anonymous
	// readers). Neither is a column on reviews.
	ReviewerName string
	ViewerVoted  bool
}

// ReviewImage mirrors review_images.
type ReviewImage struct {
	ID        uuid.UUID
	ReviewID  uuid.UUID
	URL       string
	CreatedAt time.Time
}

// Notification type values, matching docs/packages/shared/enums.md.
const (
	NotificationTypeOrderConfirmed  = "order_confirmed"
	NotificationTypeOrderPreparing  = "order_preparing"
	NotificationTypeCourierAssigned = "courier_assigned"
	NotificationTypeOrderDelivered  = "order_delivered"
	NotificationTypePromotion       = "promotion"
	NotificationTypePersonalOffer   = "personal_offer"
	NotificationTypeBonusUpdate     = "bonus_update"
	NotificationTypeNewProduct      = "new_product"
)

// Notification mirrors the notifications table.
type Notification struct {
	ID        uuid.UUID
	UserID    uuid.UUID
	Type      string
	Title     string
	Body      *string
	Data      map[string]any
	IsRead    bool
	CreatedAt time.Time
}

// NotificationPreferences mirrors notification_preferences (one row per
// user, all flags default true per the migration).
type NotificationPreferences struct {
	UserID         uuid.UUID
	Orders         bool
	Promotions     bool
	PersonalOffers bool
	BonusUpdates   bool
	NewProducts    bool
}

// DeviceToken mirrors device_tokens (FCM registration per device).
type DeviceToken struct {
	ID        uuid.UUID
	UserID    uuid.UUID
	FCMToken  string
	Platform  string
	CreatedAt time.Time
}
