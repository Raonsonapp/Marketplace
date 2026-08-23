package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
)

// SupportRepository provides access to support_conversations and
// support_messages.
type SupportRepository struct{}

// NewSupportRepository builds a SupportRepository.
func NewSupportRepository() *SupportRepository { return &SupportRepository{} }

const supportConvColumns = `id, user_id, order_id, status, assigned_agent_id, created_at, updated_at`

func scanConversation(row interface{ Scan(dest ...any) error }) (*models.SupportConversation, error) {
	var c models.SupportConversation
	if err := row.Scan(&c.ID, &c.UserID, &c.OrderID, &c.Status, &c.AssignedAgentID, &c.CreatedAt, &c.UpdatedAt); err != nil {
		return nil, err
	}
	return &c, nil
}

// CreateConversation inserts a new support conversation (status defaults to
// 'open' at the DB level).
func (r *SupportRepository) CreateConversation(ctx context.Context, q Querier, c *models.SupportConversation) error {
	row := q.QueryRow(ctx, `
		INSERT INTO support_conversations (user_id, order_id) VALUES ($1::uuid, $2::uuid)
		RETURNING id, status, assigned_agent_id, created_at, updated_at`, c.UserID, c.OrderID)
	if err := row.Scan(&c.ID, &c.Status, &c.AssignedAgentID, &c.CreatedAt, &c.UpdatedAt); err != nil {
		return fmt.Errorf("repository: create support conversation: %w", err)
	}
	return nil
}

// ListByUser returns a user's own conversations, most recently updated first.
func (r *SupportRepository) ListByUser(ctx context.Context, q Querier, userID uuid.UUID, limit, offset int) ([]models.SupportConversation, error) {
	rows, err := q.Query(ctx, `
		SELECT `+supportConvColumns+` FROM support_conversations
		WHERE user_id = $1::uuid ORDER BY updated_at DESC LIMIT $2 OFFSET $3`, userID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("repository: list support conversations: %w", err)
	}
	defer rows.Close()
	var out []models.SupportConversation
	for rows.Next() {
		c, err := scanConversation(rows)
		if err != nil {
			return nil, fmt.Errorf("repository: scan support conversation: %w", err)
		}
		out = append(out, *c)
	}
	return out, rows.Err()
}

// GetByID returns a conversation owned by userID, or ErrNotFound — the
// ownership check that gates both the messages endpoints and the WS upgrade.
func (r *SupportRepository) GetByID(ctx context.Context, q Querier, id, userID uuid.UUID) (*models.SupportConversation, error) {
	row := q.QueryRow(ctx, `SELECT `+supportConvColumns+` FROM support_conversations WHERE id = $1::uuid AND user_id = $2::uuid`, id, userID)
	c, err := scanConversation(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("repository: get support conversation: %w", err)
	}
	return c, nil
}

// TouchConversation bumps updated_at, called whenever a new message lands.
func (r *SupportRepository) TouchConversation(ctx context.Context, q Querier, id uuid.UUID) error {
	if _, err := q.Exec(ctx, `UPDATE support_conversations SET updated_at = now() WHERE id = $1::uuid`, id); err != nil {
		return fmt.Errorf("repository: touch support conversation: %w", err)
	}
	return nil
}

// InsertMessage appends a message to a conversation.
func (r *SupportRepository) InsertMessage(ctx context.Context, q Querier, m *models.SupportMessage) error {
	row := q.QueryRow(ctx, `
		INSERT INTO support_messages (conversation_id, sender_id, sender_role, text, image_url)
		VALUES ($1::uuid, $2::uuid, $3, $4, $5)
		RETURNING id, is_read, created_at`, m.ConversationID, m.SenderID, m.SenderRole, m.Text, m.ImageURL)
	if err := row.Scan(&m.ID, &m.IsRead, &m.CreatedAt); err != nil {
		return fmt.Errorf("repository: insert support message: %w", err)
	}
	return nil
}

// ListMessages returns a conversation's messages, oldest first (chat order),
// paginated from the most recent page backwards via limit/offset on a
// DESC-then-reverse basis to match the rest of the API's cursor scheme.
func (r *SupportRepository) ListMessages(ctx context.Context, q Querier, conversationID uuid.UUID, limit, offset int) ([]models.SupportMessage, error) {
	rows, err := q.Query(ctx, `
		SELECT id, conversation_id, sender_id, sender_role, text, image_url, is_read, created_at
		FROM support_messages WHERE conversation_id = $1::uuid
		ORDER BY created_at DESC LIMIT $2 OFFSET $3`, conversationID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("repository: list support messages: %w", err)
	}
	defer rows.Close()
	var out []models.SupportMessage
	for rows.Next() {
		var m models.SupportMessage
		if err := rows.Scan(&m.ID, &m.ConversationID, &m.SenderID, &m.SenderRole, &m.Text, &m.ImageURL, &m.IsRead, &m.CreatedAt); err != nil {
			return nil, fmt.Errorf("repository: scan support message: %w", err)
		}
		out = append(out, m)
	}
	return out, rows.Err()
}
