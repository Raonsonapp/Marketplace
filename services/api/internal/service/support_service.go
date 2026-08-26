package service

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/telegrambot"
	"tajikshop/api/internal/repository"
)

// SupportService implements the support-chat REST surface. Ownership is
// enforced the same way as orders/addresses/favorites (docs/SECURITY.md):
// every read/write filters on user_id = the authenticated caller, never a
// client-supplied id. Realtime fan-out to WS clients (ws.Hub) is a concern
// of internal/httpapi, not this service — it stays free of that dependency
// so it can be unit tested and reused from a future admin/agent surface.
type SupportService struct {
	db       *pgxpool.Pool
	support  *repository.SupportRepository
	users    *repository.UserRepository
	notifier *telegrambot.AdminNotifier // nil/disabled = no owner Telegram ping
}

// NewSupportService builds a SupportService. users/notifier may be nil — the
// owner Telegram notification on a new customer message is then skipped
// (the message is still stored and delivered in-app as before).
func NewSupportService(db *pgxpool.Pool, support *repository.SupportRepository, users *repository.UserRepository, notifier *telegrambot.AdminNotifier) *SupportService {
	return &SupportService{db: db, support: support, users: users, notifier: notifier}
}

// ListConversations returns a user's own conversations.
func (s *SupportService) ListConversations(ctx context.Context, userID uuid.UUID, limit, offset int) ([]models.SupportConversation, error) {
	return s.support.ListByUser(ctx, s.db, userID, limit, offset)
}

// CreateConversation opens a new conversation for userID, optionally linked
// to an order.
func (s *SupportService) CreateConversation(ctx context.Context, userID uuid.UUID, orderID *uuid.UUID) (*models.SupportConversation, error) {
	c := &models.SupportConversation{UserID: userID, OrderID: orderID}
	if err := s.support.CreateConversation(ctx, s.db, c); err != nil {
		return nil, fmt.Errorf("service: create support conversation: %w", err)
	}
	return c, nil
}

// GetConversation returns a conversation owned by userID, or NOT_FOUND —
// the shared ownership check used by both the messages endpoints and the
// WS upgrade handshake.
func (s *SupportService) GetConversation(ctx context.Context, userID, conversationID uuid.UUID) (*models.SupportConversation, error) {
	c, err := s.support.GetByID(ctx, s.db, conversationID, userID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: get support conversation: %w", err)
	}
	return c, nil
}

// ListMessages returns a conversation's messages, ownership-checked.
func (s *SupportService) ListMessages(ctx context.Context, userID, conversationID uuid.UUID, limit, offset int) ([]models.SupportMessage, error) {
	if _, err := s.GetConversation(ctx, userID, conversationID); err != nil {
		return nil, err
	}
	msgs, err := s.support.ListMessages(ctx, s.db, conversationID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("service: list support messages: %w", err)
	}
	return msgs, nil
}

// PostMessage appends a customer message to a conversation the caller owns.
func (s *SupportService) PostMessage(ctx context.Context, userID, conversationID uuid.UUID, text, imageURL *string) (*models.SupportMessage, error) {
	if _, err := s.GetConversation(ctx, userID, conversationID); err != nil {
		return nil, err
	}
	m := &models.SupportMessage{
		ConversationID: conversationID,
		SenderID:       userID,
		SenderRole:     models.SupportSenderCustomer,
		Text:           text,
		ImageURL:       imageURL,
	}
	if err := s.support.InsertMessage(ctx, s.db, m); err != nil {
		return nil, fmt.Errorf("service: insert support message: %w", err)
	}
	if err := s.support.TouchConversation(ctx, s.db, conversationID); err != nil {
		return nil, fmt.Errorf("service: touch support conversation: %w", err)
	}
	s.notifyOwner(userID, conversationID, text, imageURL)
	return m, nil
}

// notifyOwner pings the owner's Telegram with a new customer support
// message so it can be answered without an admin panel. Run in its own
// goroutine with a background context (the request context dies when the
// handler returns) and never blocks or fails the message post.
func (s *SupportService) notifyOwner(userID, conversationID uuid.UUID, text, imageURL *string) {
	if s.notifier == nil || !s.notifier.Enabled() {
		return
	}
	go func() {
		ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
		defer cancel()

		who := userID.String()
		if s.users != nil {
			if u, err := s.users.GetByID(ctx, s.db, userID); err == nil {
				if u.FullName != nil && *u.FullName != "" {
					who = *u.FullName
				}
				who += " (" + u.Phone + ")"
			}
		}
		body := "—"
		if text != nil && *text != "" {
			body = *text
		} else if imageURL != nil && *imageURL != "" {
			body = "[расм]"
		}
		msg := fmt.Sprintf("💬 Паёми нави дастгирӣ\nАз: %s\nГуфтугӯ: %s\n\n%s", who, conversationID, body)
		s.notifier.Notify(ctx, msg)
	}()
}
