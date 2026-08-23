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

// NotificationService implements the notification-preferences/device-token
// CRUD surface from docs/API_SPEC.md. Sending real push notifications (FCM)
// is out of scope for this pass — see internal/jobs for where a producer of
// notification rows would hook in.
type NotificationService struct {
	db            *pgxpool.Pool
	notifications *repository.NotificationRepository
}

// NewNotificationService builds a NotificationService.
func NewNotificationService(db *pgxpool.Pool, notifications *repository.NotificationRepository) *NotificationService {
	return &NotificationService{db: db, notifications: notifications}
}

// List returns a user's notifications, most recent first.
func (s *NotificationService) List(ctx context.Context, userID uuid.UUID, limit, offset int) ([]models.Notification, error) {
	return s.notifications.ListByUser(ctx, s.db, userID, limit, offset)
}

// MarkRead marks a notification read, ownership-checked.
func (s *NotificationService) MarkRead(ctx context.Context, userID, id uuid.UUID) error {
	if err := s.notifications.MarkRead(ctx, s.db, id, userID); err != nil {
		if err == repository.ErrNotFound {
			return apperr.New(apperr.CodeNotFound, nil)
		}
		return fmt.Errorf("service: mark notification read: %w", err)
	}
	return nil
}

// GetPreferences returns a user's notification preferences, creating the
// migration's all-true default row on first access.
func (s *NotificationService) GetPreferences(ctx context.Context, userID uuid.UUID) (*models.NotificationPreferences, error) {
	p, err := s.notifications.GetOrCreatePreferences(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: get notification preferences: %w", err)
	}
	return p, nil
}

// UpdatePreferencesInput carries only the fields the caller wants to change;
// nil fields keep their current value.
type UpdatePreferencesInput struct {
	Orders         *bool
	Promotions     *bool
	PersonalOffers *bool
	BonusUpdates   *bool
	NewProducts    *bool
}

// UpdatePreferences applies a partial update on top of the user's current
// (or default) preferences.
func (s *NotificationService) UpdatePreferences(ctx context.Context, userID uuid.UUID, in UpdatePreferencesInput) (*models.NotificationPreferences, error) {
	p, err := s.notifications.GetOrCreatePreferences(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: get notification preferences: %w", err)
	}
	if in.Orders != nil {
		p.Orders = *in.Orders
	}
	if in.Promotions != nil {
		p.Promotions = *in.Promotions
	}
	if in.PersonalOffers != nil {
		p.PersonalOffers = *in.PersonalOffers
	}
	if in.BonusUpdates != nil {
		p.BonusUpdates = *in.BonusUpdates
	}
	if in.NewProducts != nil {
		p.NewProducts = *in.NewProducts
	}
	if err := s.notifications.UpdatePreferences(ctx, s.db, p); err != nil {
		return nil, fmt.Errorf("service: update notification preferences: %w", err)
	}
	return p, nil
}

// RegisterDevice upserts an FCM device token for the caller.
func (s *NotificationService) RegisterDevice(ctx context.Context, userID uuid.UUID, fcmToken, platform string) error {
	if err := s.notifications.UpsertDeviceToken(ctx, s.db, userID, fcmToken, platform); err != nil {
		return fmt.Errorf("service: register device: %w", err)
	}
	return nil
}
