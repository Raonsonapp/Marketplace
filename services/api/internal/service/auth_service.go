// Package service implements TajikShop's business logic: every rule from
// docs/SECURITY.md and docs/API_SPEC.md that must run server-side lives
// here, never in internal/httpapi handlers directly.
package service

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/models"
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
}

// NewAuthService builds an AuthService.
func NewAuthService(db *pgxpool.Pool, otpMgr *auth.OTPManager, sessionMgr *auth.SessionManager, tokenMgr *auth.TokenManager, users *repository.UserRepository) *AuthService {
	return &AuthService{db: db, otpMgr: otpMgr, sessionMgr: sessionMgr, tokenMgr: tokenMgr, users: users}
}

// SendOTP issues a new OTP for phone, returning the resend cooldown in seconds.
func (s *AuthService) SendOTP(ctx context.Context, phone, clientIP string) (retryAfterSeconds int, err error) {
	return s.otpMgr.SendOTP(ctx, phone, clientIP)
}

// VerifyResult is returned by VerifyOTP/Refresh.
type VerifyResult struct {
	AccessToken     string
	AccessExpiresAt time.Time
	RefreshToken    string
	User            *models.User
	IsNewUser       bool
}

// VerifyOTP validates the code, then finds-or-creates the user for phone
// (a brand-new phone number becomes a new `customer` user on first
// successful verification) and issues a fresh access+refresh token pair.
func (s *AuthService) VerifyOTP(ctx context.Context, phone, code string, device auth.DeviceInfo) (*VerifyResult, error) {
	if err := s.otpMgr.VerifyOTP(ctx, phone, code); err != nil {
		return nil, err
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
