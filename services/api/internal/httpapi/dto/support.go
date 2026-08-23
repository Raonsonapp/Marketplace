package dto

import (
	"time"

	"tajikshop/api/internal/models"
)

// CreateConversationRequest is the body for POST /support/conversations.
type CreateConversationRequest struct {
	OrderID *string `json:"order_id"`
}

// SupportConversationResponse mirrors one conversation.
type SupportConversationResponse struct {
	ID        string    `json:"id"`
	OrderID   *string   `json:"order_id,omitempty"`
	Status    string    `json:"status"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// NewSupportConversationResponse converts a models.SupportConversation.
func NewSupportConversationResponse(c *models.SupportConversation) SupportConversationResponse {
	var orderID *string
	if c.OrderID != nil {
		s := c.OrderID.String()
		orderID = &s
	}
	return SupportConversationResponse{
		ID: c.ID.String(), OrderID: orderID, Status: c.Status, CreatedAt: c.CreatedAt, UpdatedAt: c.UpdatedAt,
	}
}

// NewSupportConversationListResponse converts a slice of conversations.
func NewSupportConversationListResponse(convs []models.SupportConversation) []SupportConversationResponse {
	out := make([]SupportConversationResponse, len(convs))
	for i, c := range convs {
		cc := c
		out[i] = NewSupportConversationResponse(&cc)
	}
	return out
}

// PostSupportMessageRequest is the body for POST
// /support/conversations/:id/messages.
type PostSupportMessageRequest struct {
	Text     *string `json:"text"`
	ImageURL *string `json:"image_url"`
}

// SupportMessageResponse mirrors one message.
type SupportMessageResponse struct {
	ID             string    `json:"id"`
	ConversationID string    `json:"conversation_id"`
	SenderID       string    `json:"sender_id"`
	SenderRole     string    `json:"sender_role"`
	Text           *string   `json:"text,omitempty"`
	ImageURL       *string   `json:"image_url,omitempty"`
	IsRead         bool      `json:"is_read"`
	CreatedAt      time.Time `json:"created_at"`
}

// NewSupportMessageResponse converts a models.SupportMessage.
func NewSupportMessageResponse(m *models.SupportMessage) SupportMessageResponse {
	return SupportMessageResponse{
		ID: m.ID.String(), ConversationID: m.ConversationID.String(), SenderID: m.SenderID.String(),
		SenderRole: m.SenderRole, Text: m.Text, ImageURL: m.ImageURL, IsRead: m.IsRead, CreatedAt: m.CreatedAt,
	}
}

// NewSupportMessageListResponse converts a slice of messages.
func NewSupportMessageListResponse(msgs []models.SupportMessage) []SupportMessageResponse {
	out := make([]SupportMessageResponse, len(msgs))
	for i, m := range msgs {
		mc := m
		out[i] = NewSupportMessageResponse(&mc)
	}
	return out
}
