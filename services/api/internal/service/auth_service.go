// Package service implements TajikShop's business logic: every rule from
// docs/SECURITY.md and docs/API_SPEC.md that must run server-side lives
// here, never in internal/httpapi handlers directly.
package service

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/repository"
)

// AuthService wraps internal/auth's OTP/session/JWT primitives with the
// user upsert-on-first-verify business rule.
type AuthService struct {
	db         *pgxpool.Pool
	otpMgr     *auth.OTPManager
	sessionMgr *auth.SessionManager
	tokenMgr   *auth.TokenManager
	users      *repository.UserRepository
	firebase   *auth.FirebaseVerifier
}

// NewAuthService builds an AuthService. firebase may be nil-Configured() (no
// Web API key set) — FirebaseVerify then returns a clean "not configured"
// error instead of attempting a network call.
func NewAuthService(db *pgxpool.Pool, otpMgr *auth.OTPManager, sessionMgr *auth.SessionManager, tokenMgr *auth.TokenManager, users *repository.UserRepository, firebase *auth.FirebaseVerifier) *AuthService {
	return &AuthService{db: db, otpMgr: otpMgr, sessionMgr: sessionMgr, tokenMgr: tokenMgr, users: users, firebase: firebase}
}

// SendOTP issues a new OTP for email, returning the resend cooldown in
// seconds. The identifier is an email address: codes are delivered by mail
// (internal/pkg/otp/email.go), so the address both receives the code and
// keys the account.
func (s *AuthService) SendOTP(ctx context.Context, email, clientIP string) (retryAfterSeconds int, err error) {
	return s.otpMgr.SendOTP(ctx, normalizeEmail(email), clientIP)
}

// VerifyResult is returned by VerifyOTP/Refresh.
type VerifyResult struct {
	AccessToken     string
	AccessExpiresAt time.Time
	RefreshToken    string
	User            *models.User
	IsNewUser       bool
}

// VerifyOTP validates the code, then finds-or-creates the user for email
// (a brand-new address becomes a new `customer` user on first successful
// verification) and issues a fresh access+refresh token pair.
func (s *AuthService) VerifyOTP(ctx context.Context, email, code string, device auth.DeviceInfo) (*VerifyResult, error) {
	email = normalizeEmail(email)
	if err := s.otpMgr.VerifyOTP(ctx, email, code); err != nil {
		return nil, err
	}

	isNewUser := false
	user, err := s.users.GetByEmail(ctx, s.db, email)
	if err != nil {
		if err != repository.ErrNotFound {
			return nil, fmt.Errorf("service: lookup user: %w", err)
		}
		user, err = s.users.CreateWithEmail(ctx, s.db, email)
		if err != nil {
			return nil, fmt.Errorf("service: create user: %w", err)
		}
		isNewUser = true
	}

	return s.issueTokens(ctx, user, isNewUser, device)
}

// normalizeEmail lowercases and trims an address so the same account is
// found however the user typed it, and so the OTP row key matches between
// send and verify.
func normalizeEmail(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}

// FirebaseVerify is the real-SMS registration/login path: it verifies a
// Firebase Phone Auth ID token (Firebase itself sent and validated the SMS
// code on the client) and finds-or-creates the TajikShop user for the
// verified phone number, exactly like VerifyOTP does for the console-OTP
// path — the two paths converge on the same session issuance so the rest of
// the app never needs to know which one a user signed in with.
func (s *AuthService) FirebaseVerify(ctx context.Context, idToken string, fullName *string, device auth.DeviceInfo) (*VerifyResult, error) {
	phone, _, err := s.firebase.VerifyIDToken(ctx, idToken)
	if err != nil {
		switch err {
		case auth.ErrFirebaseNotConfigured:
			return nil, apperr.New(apperr.CodeFirebaseNotConfigured, nil)
		case auth.ErrFirebasePhoneMissing:
			return nil, apperr.New(apperr.CodeFirebasePhoneMissing, nil)
		case auth.ErrFirebaseTokenInvalid:
			return nil, apperr.New(apperr.CodeFirebaseTokenInvalid, nil)
		default:
			return nil, fmt.Errorf("service: verify firebase token: %w", err)
		}
	}

	isNewUser := false
	user, err := s.users.GetByPhone(ctx, s.db, phone)
	if err != nil {
		if err != repository.ErrNotFound {
			return nil, fmt.Errorf("service: lookup user: %w", err)
		}
		user, err = s.users.Create(ctx, s.db, phone)
		if err != nil {
			return nil, fmt.Errorf("service: create user: %w", err)
		}
		isNewUser = true
	}

	if isNewUser && fullName != nil && *fullName != "" {
		if updated, err := s.users.UpdateProfile(ctx, s.db, user.ID, fullName, nil, nil); err == nil {
			user = updated
		}
	}

	return s.issueTokens(ctx, user, isNewUser, device)
}

// Refresh validates and rotates a refresh token, returning a fresh pair.
func (s *AuthService) Refresh(ctx context.Context, refreshToken string, device auth.DeviceInfo) (*VerifyResult, error) {
	userID, newRefresh, err := s.sessionMgr.Rotate(ctx, refreshToken, device)
	if err != nil {
		return nil, err
	}
	user, err := s.users.GetByID(ctx, s.db, userID)
	if err != nil {
		return nil, fmt.Errorf("service: lookup user for refresh: %w", err)
	}
	access, expiresAt, err := s.tokenMgr.IssueAccessToken(user.ID, user.Role)
	if err != nil {
		return nil, fmt.Errorf("service: issue access token: %w", err)
	}
	return &VerifyResult{
		AccessToken:     access,
		AccessExpiresAt: expiresAt,
		RefreshToken:    newRefresh,
		User:            user,
	}, nil
}

// Logout revokes a single session (refresh token).
func (s *AuthService) Logout(ctx context.Context, refreshToken string) error {
	return s.sessionMgr.Revoke(ctx, refreshToken)
}

func (s *AuthService) issueTokens(ctx context.Context, user *models.User, isNewUser bool, device auth.DeviceInfo) (*VerifyResult, error) {
	access, expiresAt, err := s.tokenMgr.IssueAccessToken(user.ID, user.Role)
	if err != nil {
		return nil, fmt.Errorf("service: issue access token: %w", err)
	}
	refresh, err := s.sessionMgr.IssueSession(ctx, user.ID, device)
	if err != nil {
		return nil, fmt.Errorf("service: issue session: %w", err)
	}
	return &VerifyResult{
		AccessToken:     access,
		AccessExpiresAt: expiresAt,
		RefreshToken:    refresh,
		User:            user,
		IsNewUser:       isNewUser,
	}, nil
}
