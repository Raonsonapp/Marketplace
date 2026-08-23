package auth

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/otp"
)

// Rate-limit quotas from docs/SECURITY.md.
const (
	sendLimitPerPhonePerHour = 5
	sendLimitPerIPPerHour    = 20
	verifyLimitPerPhone      = 5
	verifyWindow             = 15 * time.Minute
)

// OTPStore is the persistence dependency OTPManager needs from
// internal/repository.
type OTPStore interface {
	Insert(ctx context.Context, o *models.OTPCode) error
	InvalidateActive(ctx context.Context, phone string) error
	LatestActive(ctx context.Context, phone string) (*models.OTPCode, error)
	IncrementAttempts(ctx context.Context, id uuid.UUID) error
	Consume(ctx context.Context, id uuid.UUID) error
}

// OTPManager issues and verifies OTP codes per docs/SECURITY.md: bcrypt
// hash at rest, 5-minute expiry, max 5 verify attempts, one active code per
// phone, 60s resend cooldown, Redis-backed rate limiting.
type OTPManager struct {
	store      OTPStore
	sender     otp.Sender
	limiter    *Limiter
	ttl        time.Duration
	resendCD   time.Duration
	bcryptCost int
}

// NewOTPManager builds an OTPManager.
func NewOTPManager(store OTPStore, sender otp.Sender, limiter *Limiter, ttl, resendCD time.Duration, bcryptCost int) *OTPManager {
	return &OTPManager{store: store, sender: sender, limiter: limiter, ttl: ttl, resendCD: resendCD, bcryptCost: bcryptCost}
}

// SendOTP generates and delivers a new code, enforcing cooldown and rate
// limits. It returns the number of seconds the client should wait before
// the next send is accepted.
func (m *OTPManager) SendOTP(ctx context.Context, phone, clientIP string) (retryAfterSeconds int, err error) {
	if allowed, retryAfter, err := m.limiter.Cooldown(ctx, "otp:cooldown:"+phone, m.resendCD); err != nil {
		return 0, fmt.Errorf("otp: cooldown check: %w", err)
	} else if !allowed {
		return int(retryAfter.Seconds()), apperr.New(apperr.CodeOTPCooldown, map[string]any{"retry_after_seconds": int(retryAfter.Seconds())})
	}

	if allowed, retryAfter, err := m.limiter.Allow(ctx, "otp:rl:phone:"+phone, sendLimitPerPhonePerHour, time.Hour); err != nil {
		return 0, fmt.Errorf("otp: phone rate limit: %w", err)
	} else if !allowed {
		return int(retryAfter.Seconds()), apperr.New(apperr.CodeRateLimited, map[string]any{"retry_after_seconds": int(retryAfter.Seconds())})
	}

	if clientIP != "" {
		if allowed, retryAfter, err := m.limiter.Allow(ctx, "otp:rl:ip:"+clientIP, sendLimitPerIPPerHour, time.Hour); err != nil {
			return 0, fmt.Errorf("otp: ip rate limit: %w", err)
		} else if !allowed {
			return int(retryAfter.Seconds()), apperr.New(apperr.CodeRateLimited, map[string]any{"retry_after_seconds": int(retryAfter.Seconds())})
		}
	}

	code, err := otp.Generate()
	if err != nil {
		return 0, fmt.Errorf("otp: generate: %w", err)
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(code), m.bcryptCost)
	if err != nil {
		return 0, fmt.Errorf("otp: hash: %w", err)
	}

	// Only one active OTP per phone: invalidate any still-pending codes.
	if err := m.store.InvalidateActive(ctx, phone); err != nil {
		return 0, fmt.Errorf("otp: invalidate previous: %w", err)
	}

	row := &models.OTPCode{
		ID:          uuid.New(),
		Phone:       phone,
		CodeHash:    string(hash),
		Purpose:     models.OTPPurposeLogin,
		MaxAttempts: 5,
		ExpiresAt:   time.Now().Add(m.ttl),
	}
	if err := m.store.Insert(ctx, row); err != nil {
		return 0, fmt.Errorf("otp: insert: %w", err)
	}

	if err := m.sender.Send(ctx, phone, code); err != nil {
		return 0, fmt.Errorf("otp: send: %w", err)
	}

	return int(m.resendCD.Seconds()), nil
}

// VerifyOTP validates a submitted code against the latest active OTP for
// phone, enforcing the verify-attempt rate limit and per-code attempt cap.
func (m *OTPManager) VerifyOTP(ctx context.Context, phone, code string) error {
	if allowed, _, err := m.limiter.Allow(ctx, "otp:verify:"+phone, verifyLimitPerPhone, verifyWindow); err != nil {
		return fmt.Errorf("otp: verify rate limit: %w", err)
	} else if !allowed {
		return apperr.New(apperr.CodeRateLimited, nil)
	}

	row, err := m.store.LatestActive(ctx, phone)
	if err != nil {
		return fmt.Errorf("otp: lookup: %w", err)
	}
	if row == nil {
		return apperr.New(apperr.CodeOTPInvalid, nil)
	}
	if time.Now().After(row.ExpiresAt) {
		return apperr.New(apperr.CodeOTPExpired, nil)
	}
	if row.Attempts >= row.MaxAttempts {
		return apperr.New(apperr.CodeOTPMaxAttempts, nil)
	}

	if bcryptErr := bcrypt.CompareHashAndPassword([]byte(row.CodeHash), []byte(code)); bcryptErr != nil {
		if !errors.Is(bcryptErr, bcrypt.ErrMismatchedHashAndPassword) {
			return fmt.Errorf("otp: compare: %w", bcryptErr)
		}
		if incErr := m.store.IncrementAttempts(ctx, row.ID); incErr != nil {
			return fmt.Errorf("otp: increment attempts: %w", incErr)
		}
		return apperr.New(apperr.CodeOTPInvalid, nil)
	}

	if err := m.store.Consume(ctx, row.ID); err != nil {
		return fmt.Errorf("otp: consume: %w", err)
	}
	return nil
}
