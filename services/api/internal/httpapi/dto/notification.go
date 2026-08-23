package dto

import (
	"time"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/service"
)

// NotificationResponse mirrors one notification.
type NotificationResponse struct {
	ID        string         `json:"id"`
	Type      string         `json:"type"`
	Title     string         `json:"title"`
	Body      *string        `json:"body,omitempty"`
	Data      map[string]any `json:"data"`
	IsRead    bool           `json:"is_read"`
	CreatedAt time.Time      `json:"created_at"`
}

// NewNotificationResponse converts a models.Notification.
func NewNotificationResponse(n models.Notification) NotificationResponse {
	data := n.Data
	if data == nil {
		data = map[string]any{}
	}
	return NotificationResponse{
		ID: n.ID.String(), Type: n.Type, Title: n.Title, Body: n.Body, Data: data, IsRead: n.IsRead, CreatedAt: n.CreatedAt,
	}
}

// NewNotificationListResponse converts a slice of notifications.
func NewNotificationListResponse(notifs []models.Notification) []NotificationResponse {
	out := make([]NotificationResponse, len(notifs))
	for i, n := range notifs {
		out[i] = NewNotificationResponse(n)
	}
	return out
}

// NotificationPreferencesRequest is the body for PATCH
// /notifications/preferences. Every field is optional — only the ones
// present are changed (nil keeps the current value).
type NotificationPreferencesRequest struct {
	Orders         *bool `json:"orders"`
	Promotions     *bool `json:"promotions"`
	PersonalOffers *bool `json:"personal_offers"`
	BonusUpdates   *bool `json:"bonus_updates"`
	NewProducts    *bool `json:"new_products"`
}

// ToServiceInput converts the request to a service.UpdatePreferencesInput.
func (r NotificationPreferencesRequest) ToServiceInput() service.UpdatePreferencesInput {
	return service.UpdatePreferencesInput{
		Orders: r.Orders, Promotions: r.Promotions, PersonalOffers: r.PersonalOffers,
		BonusUpdates: r.BonusUpdates, NewProducts: r.NewProducts,
	}
}

// NotificationPreferencesResponse mirrors notification_preferences.
type NotificationPreferencesResponse struct {
	Orders         bool `json:"orders"`
	Promotions     bool `json:"promotions"`
	PersonalOffers bool `json:"personal_offers"`
	BonusUpdates   bool `json:"bonus_updates"`
	NewProducts    bool `json:"new_products"`
}

// NewNotificationPreferencesResponse converts a models.NotificationPreferences.
func NewNotificationPreferencesResponse(p *models.NotificationPreferences) NotificationPreferencesResponse {
	return NotificationPreferencesResponse{
		Orders: p.Orders, Promotions: p.Promotions, PersonalOffers: p.PersonalOffers,
		BonusUpdates: p.BonusUpdates, NewProducts: p.NewProducts,
	}
}

// RegisterDeviceRequest is the body for POST /devices.
type RegisterDeviceRequest struct {
	FCMToken string `json:"fcm_token" binding:"required"`
	Platform string `json:"platform" binding:"required"`
}
