package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/money"
)

// LoyaltyRepository provides access to loyalty_accounts and
// loyalty_transactions. Per docs/DATABASE_SCHEMA.md, loyalty_transactions is
// append-only and loyalty_accounts.balance is only ever updated by
// ApplyDelta, inside the same transaction as the ledger row it writes.
type LoyaltyRepository struct{}

// NewLoyaltyRepository builds a LoyaltyRepository.
func NewLoyaltyRepository() *LoyaltyRepository { return &LoyaltyRepository{} }

// GetOrCreateAccount returns the user's loyalty account, creating a
// zero-balance one if it doesn't exist yet.
func (r *LoyaltyRepository) GetOrCreateAccount(ctx context.Context, q Querier, userID uuid.UUID) (*models.LoyaltyAccount, error) {
	row := q.QueryRow(ctx, `
		INSERT INTO loyalty_accounts (user_id) VALUES ($1::uuid)
		ON CONFLICT (user_id) DO UPDATE SET user_id = EXCLUDED.user_id
		RETURNING id, user_id, balance::text, lifetime_earned::text, tier, updated_at`, userID)
	return scanLoyaltyAccount(row)
}

// LockAccountForUpdate re-reads the loyalty account with SELECT ... FOR
// UPDATE, for use inside the order transaction. q must be a transaction.
func (r *LoyaltyRepository) LockAccountForUpdate(ctx context.Context, q Querier, userID uuid.UUID) (*models.LoyaltyAccount, error) {
	row := q.QueryRow(ctx, `
		SELECT id, user_id, balance::text, lifetime_earned::text, tier, updated_at
		FROM loyalty_accounts WHERE user_id = $1::uuid FOR UPDATE`, userID)
	acc, err := scanLoyaltyAccount(row)
	if isNoRows(err) {
		return nil, ErrNotFound
	}
	return acc, err
}

func scanLoyaltyAccount(row interface{ Scan(dest ...any) error }) (*models.LoyaltyAccount, error) {
	var acc models.LoyaltyAccount
	var balance, lifetime string
	if err := row.Scan(&acc.ID, &acc.UserID, &balance, &lifetime, &acc.Tier, &acc.UpdatedAt); err != nil {
		if isNoRows(err) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("repository: scan loyalty account: %w", err)
	}
	acc.Balance, _ = money.FromString(balance)
	acc.LifetimeEarned, _ = money.FromString(lifetime)
	return &acc, nil
}

// ApplyDelta adjusts an already-locked loyalty account's balance by amount
// (signed: positive credits, negative debits) and appends the corresponding
// ledger row in the same call. Caller must have already validated amount
// (e.g. that a debit does not exceed the current balance) — this function
// only enforces the DB-level balance >= 0 CHECK as a final backstop.
func (r *LoyaltyRepository) ApplyDelta(ctx context.Context, q Querier, account *models.LoyaltyAccount, orderID *uuid.UUID, txType string, amount money.Money, description string) (*models.LoyaltyTransaction, error) {
	newBalance := account.Balance.Add(amount)
	newLifetime := account.LifetimeEarned
	if amount.GreaterThan(money.Zero) {
		newLifetime = newLifetime.Add(amount)
	}

	row := q.QueryRow(ctx, `
		UPDATE loyalty_accounts SET balance = $2::numeric, lifetime_earned = $3::numeric, updated_at = now()
		WHERE id = $1::uuid
		RETURNING balance::text, lifetime_earned::text, updated_at`,
		account.ID, newBalance.String(), newLifetime.String())
	var balanceStr, lifetimeStr string
	if err := row.Scan(&balanceStr, &lifetimeStr, &account.UpdatedAt); err != nil {
		return nil, fmt.Errorf("repository: update loyalty balance: %w", err)
	}
	account.Balance, _ = money.FromString(balanceStr)
	account.LifetimeEarned, _ = money.FromString(lifetimeStr)

	tx := &models.LoyaltyTransaction{
		ID:               uuid.New(),
		LoyaltyAccountID: account.ID,
		OrderID:          orderID,
		Type:             txType,
		Amount:           amount,
		BalanceAfter:     account.Balance,
	}
	if description != "" {
		tx.Description = &description
	}
	insertRow := q.QueryRow(ctx, `
		INSERT INTO loyalty_transactions (id, loyalty_account_id, order_id, type, amount, balance_after, description)
		VALUES ($1::uuid, $2::uuid, $3::uuid, $4, $5::numeric, $6::numeric, $7)
		RETURNING created_at`,
		tx.ID, tx.LoyaltyAccountID, tx.OrderID, tx.Type, tx.Amount.String(), tx.BalanceAfter.String(), tx.Description)
	if err := insertRow.Scan(&tx.CreatedAt); err != nil {
		return nil, fmt.Errorf("repository: insert loyalty transaction: %w", err)
	}
	return tx, nil
}

// ListTransactions returns a user's loyalty ledger, most recent first.
func (r *LoyaltyRepository) ListTransactions(ctx context.Context, q Querier, accountID uuid.UUID, limit, offset int) ([]models.LoyaltyTransaction, error) {
	rows, err := q.Query(ctx, `
		SELECT id, loyalty_account_id, order_id, type, amount::text, balance_after::text, description, expires_at, created_at
		FROM loyalty_transactions WHERE loyalty_account_id = $1::uuid
		ORDER BY created_at DESC LIMIT $2 OFFSET $3`, accountID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("repository: list loyalty transactions: %w", err)
	}
	defer rows.Close()
	var out []models.LoyaltyTransaction
	for rows.Next() {
		var tx models.LoyaltyTransaction
		var amount, balanceAfter string
		if err := rows.Scan(&tx.ID, &tx.LoyaltyAccountID, &tx.OrderID, &tx.Type, &amount, &balanceAfter, &tx.Description, &tx.ExpiresAt, &tx.CreatedAt); err != nil {
			return nil, fmt.Errorf("repository: scan loyalty transaction: %w", err)
		}
		tx.Amount, _ = money.FromString(amount)
		tx.BalanceAfter, _ = money.FromString(balanceAfter)
		out = append(out, tx)
	}
	return out, rows.Err()
}
