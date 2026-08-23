package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/repository"
)

// OrderService implements order retrieval/listing. Cancellation is a
// compensating transaction that touches the same inventory/loyalty state
// order creation does, so it lives on CheckoutService (see Cancel below)
// rather than being duplicated here.
type OrderService struct {
	db     *pgxpool.Pool
	orders *repository.OrderRepository
}

// NewOrderService builds an OrderService.
func NewOrderService(db *pgxpool.Pool, orders *repository.OrderRepository) *OrderService {
	return &OrderService{db: db, orders: orders}
}

// Get returns one order owned by userID.
func (s *OrderService) Get(ctx context.Context, userID, orderID uuid.UUID) (*models.Order, error) {
	o, err := s.orders.GetByID(ctx, s.db, orderID, userID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: get order: %w", err)
	}
	return o, nil
}

// List returns a user's orders, optionally filtered by status bucket.
func (s *OrderService) List(ctx context.Context, userID uuid.UUID, statusFilter string, limit, offset int) ([]models.Order, error) {
	return s.orders.ListByUser(ctx, s.db, userID, statusFilter, limit, offset)
}

// Cancel transitions an order to cancelled, restoring stock and reversing
// any loyalty ledger entries the order created — a compensating transaction
// mirroring CheckoutService.createOrderTx.
func (s *CheckoutService) Cancel(ctx context.Context, userID, orderID uuid.UUID, reason string) (*models.Order, error) {
	tx, err := s.db.Begin(ctx)
	if err != nil {
		return nil, fmt.Errorf("service: begin cancel tx: %w", err)
	}
	defer tx.Rollback(ctx)

	order, err := s.orders.GetForUpdate(ctx, tx, orderID, userID)
	if err != nil {
		if err == repository.ErrNotFound {
			return nil, apperr.New(apperr.CodeNotFound, nil)
		}
		return nil, fmt.Errorf("service: lock order: %w", err)
	}
	if !models.CancelableStatuses[order.Status] {
		return nil, apperr.New(apperr.CodeOrderNotCancelable, map[string]any{"status": order.Status})
	}

	for _, item := range order.Items {
		inv, err := s.inventory.GetByProductStore(ctx, tx, item.ProductID, order.StoreID)
		if err != nil {
			if err == repository.ErrNotFound {
				continue
			}
			return nil, fmt.Errorf("service: find inventory for restock: %w", err)
		}
		if err := s.inventory.IncrementStock(ctx, tx, inv.ID, item.Quantity); err != nil {
			return nil, fmt.Errorf("service: restock: %w", err)
		}
	}

	if order.BonusUsed.GreaterThan(money.Zero) || order.BonusEarned.GreaterThan(money.Zero) {
		account, err := s.loyalty.LockAccountForUpdate(ctx, tx, userID)
		if err != nil && err != repository.ErrNotFound {
			return nil, fmt.Errorf("service: lock loyalty account: %w", err)
		}
		if account != nil {
			if order.BonusUsed.GreaterThan(money.Zero) {
				if _, err := s.loyalty.ApplyDelta(ctx, tx, account, &order.ID, models.LoyaltyTxAdjust, order.BonusUsed, "Refund: cancelled order "+order.OrderNumber); err != nil {
					return nil, fmt.Errorf("service: refund bonus: %w", err)
				}
			}
			if order.BonusEarned.GreaterThan(money.Zero) {
				debit := money.Min(order.BonusEarned, account.Balance)
				if _, err := s.loyalty.ApplyDelta(ctx, tx, account, &order.ID, models.LoyaltyTxAdjust, debit.Neg(), "Reversal: cancelled order "+order.OrderNumber); err != nil {
					return nil, fmt.Errorf("service: reverse bonus earn: %w", err)
				}
			}
		}
	}

	if err := s.orders.Cancel(ctx, tx, order.ID, reason); err != nil {
		return nil, fmt.Errorf("service: cancel order: %w", err)
	}
	if err := s.orders.InsertStatusHistory(ctx, tx, order.ID, models.OrderStatusCancelled, &reason, nil); err != nil {
		return nil, fmt.Errorf("service: insert cancel history: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, fmt.Errorf("service: commit cancel tx: %w", err)
	}

	order.Status = models.OrderStatusCancelled
	order.CancelledReason = &reason
	return order, nil
}
