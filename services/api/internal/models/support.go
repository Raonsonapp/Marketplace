package models

import (
	"time"

	"github.com/google/uuid"
)

// Support conversation status values, matching support_conversations.status
// CHECK constraint.
const (
	SupportConversationOpen   = "open"
	SupportConversationClosed = "closed"
)

// Support message sender roles.
const (
	SupportSenderCustomer = "customer"
	SupportSenderAgent    = "agent"
)

// SupportConversation mirrors support_conversations.
type SupportConversation struct {
	ID              uuid.UUID
	UserID          uuid.UUID
	OrderID         *uuid.UUID
	Status          string
	AssignedAgentID *uuid.UUID
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

// SupportMessage mirrors support_messages.
type SupportMessage struct {
	ID             uuid.UUID
	ConversationID uuid.UUID
	SenderID       uuid.UUID
	SenderRole     string
	Text           *string
	ImageURL       *string
	IsRead         bool
	CreatedAt      time.Time
}
