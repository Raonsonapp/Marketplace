package repository

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// NotificationRepository provides access to notifications,
// notification_preferences, and device_tokens.
type NotificationRepository struct{}

// NewNotificationRepository builds a NotificationRepository.
func NewNotificationRepository() *NotificationRepository { return &NotificationRepository{} }

// ListByUser returns a user's notifications, most recent first, paginated.
func (r *NotificationRepository) ListByUser(ctx context.Context, q Querier, userID uuid.UUID, limit, offset int) ([]models.Notification, error) {
	rows, err := q.Query(ctx, `
		SELECT id, user_id, type, title, body, data, is_read, created_at
		FROM notifications WHERE user_id = $1::uuid
		ORDER BY created_at DESC LIMIT $2 OFFSET $3`, userID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("repository: list notifications: %w", err)
	}
	defer rows.Close()
	var out []models.Notification
	for rows.Next() {
		var n models.Notification
		var data []byte
		if err := rows.Scan(&n.ID, &n.UserID, &n.Type, &n.Title, &n.Body, &data, &n.IsRead, &n.CreatedAt); err != nil {
			return nil, fmt.Errorf("repository: scan notification: %w", err)
		}
		if len(data) > 0 {
			_ = json.Unmarshal(data, &n.Data)
		}
		out = append(out, n)
	}
	return out, rows.Err()
}

// MarkRead sets is_read=true on a notification owned by userID. Returns
// ErrNotFound if no matching row exists (wrong id or not owned).
func (r *NotificationRepository) MarkRead(ctx context.Context, q Querier, id, userID uuid.UUID) error {
	tag, err := q.Exec(ctx, `UPDATE notifications SET is_read = true WHERE id = $1::uuid AND user_id = $2::uuid`, id, userID)
	if err != nil {
		return fmt.Errorf("repository: mark notification read: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

// Create inserts a new notification row (used by internal/jobs when an
// order status changes, and available for future producers).
func (r *NotificationRepository) Create(ctx context.Context, q Querier, n *models.Notification) error {
	data := n.Data
	if data == nil {
		data = map[string]any{}
	}
	b, err := json.Marshal(data)
	if err != nil {
		return fmt.Errorf("repository: marshal notification data: %w", err)
	}
	row := q.QueryRow(ctx, `
		INSERT INTO notifications (user_id, type, title, body, data)
		VALUES ($1::uuid, $2, $3, $4, $5::jsonb)
		RETURNING id, is_read, created_at`, n.UserID, n.Type, n.Title, n.Body, b)
	if err := row.Scan(&n.ID, &n.IsRead, &n.CreatedAt); err != nil {
		return fmt.Errorf("repository: create notification: %w", err)
	}
	return nil
}

// GetPreferences returns a user's notification_preferences row, or
// ErrNotFound if it hasn't been created yet.
func (r *NotificationRepository) GetPreferences(ctx context.Context, q Querier, userID uuid.UUID) (*models.NotificationPreferences, error) {
	row := q.QueryRow(ctx, `
		SELECT user_id, orders, promotions, personal_offers, bonus_updates, new_products
		FROM notification_preferences WHERE user_id = $1::uuid`, userID)
	var p models.NotificationPreferences
	if err := row.Scan(&p.UserID, &p.Orders, &p.Promotions, &p.PersonalOffers, &p.BonusUpdates, &p.NewProducts); err != nil {
		if isNoRows(err) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("repository: get notification preferences: %w", err)
	}
	return &p, nil
}

// GetOrCreatePreferences returns a user's preferences row, inserting the
// migration's all-true defaults on first access.
func (r *NotificationRepository) GetOrCreatePreferences(ctx context.Context, q Querier, userID uuid.UUID) (*models.NotificationPreferences, error) {
	row := q.QueryRow(ctx, `
		INSERT INTO notification_preferences (user_id) VALUES ($1::uuid)
		ON CONFLICT (user_id) DO UPDATE SET user_id = EXCLUDED.user_id
		RETURNING user_id, orders, promotions, personal_offers, bonus_updates, new_products`, userID)
	var p models.NotificationPreferences
	if err := row.Scan(&p.UserID, &p.Orders, &p.Promotions, &p.PersonalOffers, &p.BonusUpdates, &p.NewProducts); err != nil {
		return nil, fmt.Errorf("repository: get or create notification preferences: %w", err)
	}
	return &p, nil
}

// UpdatePreferences overwrites a user's preferences row (creating it first
// if missing).
func (r *NotificationRepository) UpdatePreferences(ctx context.Context, q Querier, p *models.NotificationPreferences) error {
	row := q.QueryRow(ctx, `
		INSERT INTO notification_preferences (user_id, orders, promotions, personal_offers, bonus_updates, new_products)
		VALUES ($1::uuid, $2, $3, $4, $5, $6)
		ON CONFLICT (user_id) DO UPDATE SET
			orders = EXCLUDED.orders, promotions = EXCLUDED.promotions, personal_offers = EXCLUDED.personal_offers,
			bonus_updates = EXCLUDED.bonus_updates, new_products = EXCLUDED.new_products
		RETURNING user_id, orders, promotions, personal_offers, bonus_updates, new_products`,
		p.UserID, p.Orders, p.Promotions, p.PersonalOffers, p.BonusUpdates, p.NewProducts)
	if err := row.Scan(&p.UserID, &p.Orders, &p.Promotions, &p.PersonalOffers, &p.BonusUpdates, &p.NewProducts); err != nil {
		return fmt.Errorf("repository: update notification preferences: %w", err)
	}
	return nil
}

// UpsertDeviceToken inserts or refreshes a device's FCM token registration
// (unique on user_id+fcm_token, enforced by the DB).
func (r *NotificationRepository) UpsertDeviceToken(ctx context.Context, q Querier, userID uuid.UUID, fcmToken, platform string) error {
	if _, err := q.Exec(ctx, `
		INSERT INTO device_tokens (user_id, fcm_token, platform) VALUES ($1::uuid, $2, $3)
		ON CONFLICT (user_id, fcm_token) DO UPDATE SET platform = EXCLUDED.platform`, userID, fcmToken, platform); err != nil {
		return fmt.Errorf("repository: upsert device token: %w", err)
	}
	return nil
}
