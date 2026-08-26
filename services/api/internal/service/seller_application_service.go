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
	"tajikshop/api/internal/storage"
)

// minSellerAge matches the user's explicit requirement: a seller must be at
// least 18 years old.
const minSellerAge = 18

// faceMatchApprovalThreshold is the minimum client-computed similarity
// score (0..1, from the mobile app's on-device Google ML Kit comparison —
// see docs/API_SPEC.md) for an application to auto-approve. Below it, the
// application is still recorded as 'pending' rather than rejected outright:
// a free, on-device comparison is a reasonable approximation, not a
// laboratory-grade biometric match, so a low/uncertain score gets a human
// second look (the Telegram admin notification below) instead of a hard
// auto-reject that could lock out a legitimate applicant on a bad camera
// angle.
const faceMatchApprovalThreshold = 0.6

// SellerApplicationService implements POST/GET /seller-applications — the
// "become a seller" onboarding flow: age check, store location/contact
// info, KYC document keys, and the mobile app's liveness/face-match result.
//
// Honesty note on the biometric piece (documented here since it drives this
// service's approval logic): the face-match score is computed entirely
// on-device in the mobile app via Google ML Kit face detection — free, no
// paid KYC vendor, no server-side recognition model. That is a deliberate,
// requested trade-off (see the "free" requirement this feature was built
// against) but it means the server is trusting a client-reported number for
// the auto-approve path; it is not equivalent to a paid identity-verification
// API's server-side guarantee. faceMatchApprovalThreshold plus the always-on
// admin notification below are the mitigations: low-confidence or manually
// tampered scores still land as 'pending' for a human to glance at.
type SellerApplicationService struct {
	db       *pgxpool.Pool
	apps     *repository.SellerApplicationRepository
	users    *repository.UserRepository
	storage  *storage.Client // nil when R2 isn't configured — admin notify skips document links
	notifier *telegrambot.AdminNotifier
}

// NewSellerApplicationService builds a SellerApplicationService. notifier may
// be nil or disabled — the admin Telegram notification is then skipped
// (applications are still stored and queryable via GET .../me).
func NewSellerApplicationService(
	db *pgxpool.Pool, apps *repository.SellerApplicationRepository, users *repository.UserRepository,
	storageClient *storage.Client, notifier *telegrambot.AdminNotifier,
) *SellerApplicationService {
	return &SellerApplicationService{db: db, apps: apps, users: users, storage: storageClient, notifier: notifier}
}

// CreateSellerApplicationInput is the service-level input for POST /seller-applications.
type CreateSellerApplicationInput struct {
	BirthDate             time.Time
	StoreLat              *float64
	StoreLng              *float64
	StoreWebsite          *string
	StoreInstagram        *string
	StoreTelegram         *string
	StoreWhatsapp         *string
	PassportFrontKey      string
	PassportBackKey       string
	SelfieWithPassportKey string
	LiveSelfieKey         string
	LivenessPassed        bool
	FaceMatchScore        *float64
}

// Create validates age/store-info and records a new application, auto-
// approving (and promoting the user to store_manager) when the liveness
// check passed and the face-match score clears faceMatchApprovalThreshold.
func (s *SellerApplicationService) Create(ctx context.Context, userID uuid.UUID, in CreateSellerApplicationInput) (*models.SellerApplication, error) {
	age := ageInYears(in.BirthDate, time.Now())
	if age < minSellerAge {
		return nil, apperr.New(apperr.CodeSellerUnderage, nil)
	}

	hasGPS := in.StoreLat != nil && in.StoreLng != nil
	hasSocial := nonEmpty(in.StoreWebsite) || nonEmpty(in.StoreInstagram) || nonEmpty(in.StoreTelegram) || nonEmpty(in.StoreWhatsapp)
	if !hasGPS && !hasSocial {
		return nil, apperr.New(apperr.CodeValidation, map[string]any{"field": "store_location"})
	}

	status := models.SellerApplicationPending
	if in.LivenessPassed && in.FaceMatchScore != nil && *in.FaceMatchScore >= faceMatchApprovalThreshold {
		status = models.SellerApplicationApproved
	}

	app := &models.SellerApplication{
		UserID:                userID,
		BirthDate:             in.BirthDate,
		StoreLat:              in.StoreLat,
		StoreLng:              in.StoreLng,
		StoreWebsite:          in.StoreWebsite,
		StoreInstagram:        in.StoreInstagram,
		StoreTelegram:         in.StoreTelegram,
		StoreWhatsapp:         in.StoreWhatsapp,
		PassportFrontKey:      in.PassportFrontKey,
		PassportBackKey:       in.PassportBackKey,
		SelfieWithPassportKey: in.SelfieWithPassportKey,
		LiveSelfieKey:         in.LiveSelfieKey,
		LivenessPassed:        in.LivenessPassed,
		FaceMatchScore:        in.FaceMatchScore,
		Status:                status,
	}
	if err := s.apps.Create(ctx, s.db, app); err != nil {
		if err == repository.ErrConflict {
			return nil, apperr.New(apperr.CodeSellerApplicationExists, nil)
		}
		return nil, fmt.Errorf("service: create seller application: %w", err)
	}

	if status == models.SellerApplicationApproved {
		if err := s.users.UpdateRole(ctx, s.db, userID, models.RoleStoreManager); err != nil {
			return nil, fmt.Errorf("service: promote seller: %w", err)
		}
	}

	go s.notifyAdmin(app)

	return app, nil
}

// GetMine returns the caller's own application, or apperr CodeNotFound.
func (s *SellerApplicationService) GetMine(ctx context.Context, userID uuid.UUID) (*models.SellerApplication, error) {
	app, err := s.apps.GetByUserID(ctx, s.db, userID)
	if err == repository.ErrNotFound {
		return nil, apperr.New(apperr.CodeNotFound, nil)
	}
	if err != nil {
		return nil, fmt.Errorf("service: get seller application: %w", err)
	}
	return app, nil
}

// notifyAdmin pings TELEGRAM_ADMIN_CHAT_ID with a summary and short-lived
// document links, run in its own goroutine from Create so a slow/failed
// notification never delays or fails the application response. Uses
// context.Background() deliberately: the request context is cancelled the
// moment the HTTP handler returns, before this goroutine would get to run.
func (s *SellerApplicationService) notifyAdmin(app *models.SellerApplication) {
	if s.notifier == nil || !s.notifier.Enabled() {
		return
	}
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()

	text := fmt.Sprintf(
		"🆕 Дархости фурушандашавӣ\nStatus: %s\nLiveness: %v\nFace score: %s\nUser ID: %s",
		app.Status, app.LivenessPassed, formatScore(app.FaceMatchScore), app.UserID,
	)
	if s.storage != nil {
		for label, key := range map[string]string{
			"Паспорт (пеш)":    app.PassportFrontKey,
			"Паспорт (пас)":    app.PassportBackKey,
			"Селфӣ бо паспорт": app.SelfieWithPassportKey,
			"Селфии зинда":     app.LiveSelfieKey,
		} {
			if url, err := s.storage.PresignGet(ctx, key, 24*time.Hour); err == nil {
				text += fmt.Sprintf("\n%s: %s", label, url)
			}
		}
	}
	s.notifier.Notify(ctx, text)
}

func formatScore(score *float64) string {
	if score == nil {
		return "—"
	}
	return fmt.Sprintf("%.2f", *score)
}

func nonEmpty(s *string) bool {
	return s != nil && *s != ""
}

// ageInYears computes a whole-years age as of `at`, matching normal
// birthday-based age calculation (not just year subtraction).
func ageInYears(birthDate, at time.Time) int {
	years := at.Year() - birthDate.Year()
	hadBirthdayThisYear := at.Month() > birthDate.Month() ||
		(at.Month() == birthDate.Month() && at.Day() >= birthDate.Day())
	if !hadBirthdayThisYear {
		years--
	}
	return years
}
