package repository

import (
	"context"
	"fmt"
)

// TelegramLinkRepository provides access to telegram_links: the mapping a
// user builds by opening the verification bot and pressing Start, which
// otp.TelegramBotSender (internal/pkg/otp/telegrambot.go) then reads to
// know which Telegram chat to deliver a phone's OTP code to.
type TelegramLinkRepository struct{}

// NewTelegramLinkRepository builds a TelegramLinkRepository.
func NewTelegramLinkRepository() *TelegramLinkRepository { return &TelegramLinkRepository{} }

// ChatIDForPhone returns the linked Telegram chat ID for phone, or
// found=false if the user hasn't opened the bot yet.
func (r *TelegramLinkRepository) ChatIDForPhone(ctx context.Context, q Querier, phone string) (chatID int64, found bool, err error) {
	row := q.QueryRow(ctx, `SELECT chat_id FROM telegram_links WHERE phone = $1`, phone)
	if err := row.Scan(&chatID); err != nil {
		if isNoRows(err) {
			return 0, false, nil
		}
		return 0, false, fmt.Errorf("repository: telegram link lookup: %w", err)
	}
	return chatID, true, nil
}

// Upsert records (or updates) which chat a phone number is linked to, e.g.
// on every `/start` the verification bot receives.
func (r *TelegramLinkRepository) Upsert(ctx context.Context, q Querier, phone string, chatID int64, username string) error {
	_, err := q.Exec(ctx, `
		INSERT INTO telegram_links (phone, chat_id, telegram_username, linked_at)
		VALUES ($1, $2, $3, now())
		ON CONFLICT (phone) DO UPDATE SET chat_id = $2, telegram_username = $3, linked_at = now()`,
		phone, chatID, username)
	if err != nil {
		return fmt.Errorf("repository: upsert telegram link: %w", err)
	}
	return nil
}

// TelegramLinkLookupAdapter binds a TelegramLinkRepository to a fixed
// Querier so it satisfies both internal/pkg/otp.ChatIDLookup (ChatIDForPhone)
// and internal/pkg/telegrambot.LinkStore (Upsert) — the read and write
// sides of the same phone<->chat_id table, used by the OTP sender and the
// bot's update poller respectively.
type TelegramLinkLookupAdapter struct {
	Repo *TelegramLinkRepository
	DB   Querier
}

// NewTelegramLinkLookupAdapter builds a TelegramLinkLookupAdapter.
func NewTelegramLinkLookupAdapter(repo *TelegramLinkRepository, db Querier) *TelegramLinkLookupAdapter {
	return &TelegramLinkLookupAdapter{Repo: repo, DB: db}
}

func (a *TelegramLinkLookupAdapter) ChatIDForPhone(ctx context.Context, phone string) (int64, bool, error) {
	return a.Repo.ChatIDForPhone(ctx, a.DB, phone)
}

func (a *TelegramLinkLookupAdapter) Upsert(ctx context.Context, phone string, chatID int64, username string) error {
	return a.Repo.Upsert(ctx, a.DB, phone, chatID, username)
}
