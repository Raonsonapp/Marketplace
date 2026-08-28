package service

import (
	"context"
	"fmt"
	"strings"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/repository"
)

// CargoService implements parcel forwarding from China to Tajikistan and
// Russia (migration 0008): the shopper registers a parcel against YouShop's
// China warehouse address, an operator weighs it on arrival, and the price
// is weight × the destination's per-kilo rate.
type CargoService struct {
	db            *pgxpool.Pool
	cargo         *repository.CargoRepository
	notifications *repository.NotificationRepository
}

// NewCargoService builds a CargoService.
func NewCargoService(db *pgxpool.Pool, cargo *repository.CargoRepository, notifications *repository.NotificationRepository) *CargoService {
	return &CargoService{db: db, cargo: cargo, notifications: notifications}
}

// Tariffs returns the destinations forwarding is currently offered for.
// Empty is a valid answer — it means no operator has set the service up yet
// — and the client renders that as "coming soon" rather than as an error.
func (s *CargoService) Tariffs(ctx context.Context) ([]models.CargoTariff, error) {
	tariffs, err := s.cargo.ListActiveTariffs(ctx, s.db)
	if err != nil {
		return nil, fmt.Errorf("service: cargo tariffs: %w", err)
	}
	return tariffs, nil
}

// List returns the caller's own parcels.
func (s *CargoService) List(ctx context.Context, userID uuid.UUID, limit, offset int) ([]models.CargoShipment, error) {
	shipments, err := s.cargo.ListByUser(ctx, s.db, userID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("service: list cargo: %w", err)
	}
	return shipments, nil
}

// Get returns one of the caller's own parcels.
func (s *CargoService) Get(ctx context.Context, id, userID uuid.UUID) (*models.CargoShipment, error) {
	shipment, err := s.cargo.GetByID(ctx, s.db, id, userID)
	if err == repository.ErrNotFound {
		return nil, apperr.New(apperr.CodeNotFound, nil)
	}
	if err != nil {
		return nil, fmt.Errorf("service: get cargo: %w", err)
	}
	return shipment, nil
}

// Register records a new parcel. The destination must be one the operator
// has actually switched on, otherwise the shopper would be handed a
// warehouse address nobody is receiving at.
func (s *CargoService) Register(ctx context.Context, shipment *models.CargoShipment) error {
	shipment.Destination = NormalizeCountry(shipment.Destination)
	if shipment.Destination == "" {
		return apperr.New(apperr.CodeValidation, map[string]any{"field": "destination"})
	}
	shipment.Description = strings.TrimSpace(shipment.Description)
	if shipment.Description == "" {
		return apperr.New(apperr.CodeValidation, map[string]any{"field": "description"})
	}

	tariff, err := s.cargo.GetTariff(ctx, s.db, shipment.Destination)
	if err == repository.ErrNotFound {
		return apperr.New(apperr.CodeCargoUnavailable, map[string]any{"destination": shipment.Destination})
	}
	if err != nil {
		return fmt.Errorf("service: cargo tariff: %w", err)
	}
	if !tariff.IsActive {
		return apperr.New(apperr.CodeCargoUnavailable, map[string]any{"destination": shipment.Destination})
	}

	if err := s.cargo.Create(ctx, s.db, shipment); err != nil {
		return fmt.Errorf("service: register cargo: %w", err)
	}
	return nil
}

// Cancel withdraws a parcel the warehouse has not received yet.
func (s *CargoService) Cancel(ctx context.Context, id, userID uuid.UUID) (*models.CargoShipment, error) {
	shipment, err := s.cargo.CancelByUser(ctx, s.db, id, userID)
	if err == repository.ErrNotFound {
		// Either it isn't the caller's parcel, or it has already moved past
		// 'new'. Distinguish the two so the shopper is told which it is.
		if _, getErr := s.cargo.GetByID(ctx, s.db, id, userID); getErr == nil {
			return nil, apperr.New(apperr.CodeCargoNotCancelable, nil)
		}
		return nil, apperr.New(apperr.CodeNotFound, nil)
	}
	if err != nil {
		return nil, fmt.Errorf("service: cancel cargo: %w", err)
	}
	return shipment, nil
}

// AdminList returns the operator's queue, optionally filtered by status.
func (s *CargoService) AdminList(ctx context.Context, status string, limit, offset int) ([]models.CargoShipment, error) {
	if status != "" && !models.ValidCargoStatus(status) {
		return nil, apperr.New(apperr.CodeValidation, map[string]any{"field": "status"})
	}
	shipments, err := s.cargo.ListAll(ctx, s.db, status, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("service: admin list cargo: %w", err)
	}
	return shipments, nil
}

// AdminUpdate applies an operator's edits: tracking code, weighed weight,
// status and note. The price is always recomputed here from the parcel's
// final weight and its destination's current rate — never sent by the
// client — so a shopper cannot influence what they are charged.
func (s *CargoService) AdminUpdate(ctx context.Context, id uuid.UUID, patch repository.CargoShipmentPatch) (*models.CargoShipment, error) {
	if patch.Status != nil && !models.ValidCargoStatus(*patch.Status) {
		return nil, apperr.New(apperr.CodeValidation, map[string]any{"field": "status"})
	}
	if patch.WeightKg != nil && *patch.WeightKg < 0 {
		return nil, apperr.New(apperr.CodeValidation, map[string]any{"field": "weight_kg"})
	}

	current, err := s.cargo.GetByID(ctx, s.db, id, uuid.Nil)
	if err == repository.ErrNotFound {
		return nil, apperr.New(apperr.CodeNotFound, nil)
	}
	if err != nil {
		return nil, fmt.Errorf("service: get cargo: %w", err)
	}

	weight := current.WeightKg
	if patch.WeightKg != nil {
		weight = *patch.WeightKg
	}
	cost := money.Zero
	if weight > 0 {
		tariff, err := s.cargo.GetTariff(ctx, s.db, current.Destination)
		if err != nil && err != repository.ErrNotFound {
			return nil, fmt.Errorf("service: cargo tariff: %w", err)
		}
		// A destination switched off after the parcel was registered still
		// has to be priced — the parcel is physically in transit — so an
		// inactive tariff is used, and only a missing row prices at zero.
		if err == nil {
			cost = tariff.RatePerKg.MulFloat(weight)
		}
	}

	updated, err := s.cargo.UpdateByOperator(ctx, s.db, id, patch, cost)
	if err == repository.ErrNotFound {
		return nil, apperr.New(apperr.CodeNotFound, nil)
	}
	if err != nil {
		return nil, fmt.Errorf("service: update cargo: %w", err)
	}

	// Tell the owner when the parcel actually moved, not on every edit — a
	// corrected note or a re-typed tracking code is not news.
	if patch.Status != nil && *patch.Status != current.Status {
		s.notifyStatusChange(ctx, updated)
	}
	return updated, nil
}

// notifyStatusChange writes an in-app notification. Best-effort: a parcel's
// status must not fail to save because the notification insert did.
func (s *CargoService) notifyStatusChange(ctx context.Context, shipment *models.CargoShipment) {
	body := cargoStatusBody(shipment.Status)
	_ = s.notifications.Create(ctx, s.db, &models.Notification{
		UserID: shipment.UserID,
		Type:   "cargo",
		Title:  "Карго",
		Body:   &body,
		Data: map[string]any{
			"cargo_id": shipment.ID.String(),
			"status":   shipment.Status,
		},
	})
}

// cargoStatusBody is the Tajik sentence for a status. Notifications are
// stored already-rendered (the existing notifications table has no
// per-language columns), so this matches how order-status notifications are
// produced today.
func cargoStatusBody(status string) string {
	switch status {
	case models.CargoStatusNew:
		return "Дархости шумо қабул шуд"
	case models.CargoStatusReceived:
		return "Посылкаи шумо ба анбори Хитой расид"
	case models.CargoStatusShipped:
		return "Посылкаи шумо фиристода шуд"
	case models.CargoStatusArrived:
		return "Посылкаи шумо ба кишвар расид"
	case models.CargoStatusDelivered:
		return "Посылкаи шумо супорида шуд"
	case models.CargoStatusCancelled:
		return "Дархости карго бекор карда шуд"
	}
	return status
}

// AdminUpsertTariff writes a destination's forwarding offer.
func (s *CargoService) AdminUpsertTariff(ctx context.Context, tariff *models.CargoTariff) error {
	tariff.Destination = NormalizeCountry(tariff.Destination)
	if tariff.Destination == "" {
		return apperr.New(apperr.CodeValidation, map[string]any{"field": "destination"})
	}
	if tariff.RatePerKg.IsNegative() {
		return apperr.New(apperr.CodeValidation, map[string]any{"field": "rate_per_kg"})
	}
	// Switching a destination on without the two things a shopper actually
	// needs — where to ship, and what it costs — would publish a useless
	// offer, so refuse it rather than silently shipping an empty address.
	if tariff.IsActive && (strings.TrimSpace(tariff.WarehouseAddress) == "" || tariff.RatePerKg.IsZero()) {
		return apperr.New(apperr.CodeValidation, map[string]any{
			"fields": []string{"warehouse_address", "rate_per_kg"},
		})
	}
	if err := s.cargo.UpsertTariff(ctx, s.db, tariff); err != nil {
		return fmt.Errorf("service: upsert cargo tariff: %w", err)
	}
	return nil
}
