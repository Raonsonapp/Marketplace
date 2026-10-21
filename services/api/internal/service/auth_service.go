// Package service implements business logic for authentication.
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

// AuthService wraps OTP, Google/Firebase identity verification, session and JWT primitives.
type AuthService struct {
	db         *pgxpool.Pool
	otpMgr     *auth.OTPManager
	sessionMgr *auth.SessionManager
	tokenMgr   *auth.TokenManager
	users      *repository.UserRepository
	firebase   *auth.FirebaseVerifier
	google     *auth.GoogleVerifier
}

// NewAuthService builds an AuthService. Google and Firebase may be unconfigured;
// their endpoints return explicit configuration errors without affecting other sign-in methods.
func NewAuthService(db *pgxpool.Pool, otpMgr *auth.OTPManager, sessionMgr *auth.SessionManager, tokenMgr *auth.TokenManager, users *repository.UserRepository, firebase *auth.FirebaseVerifier, google *auth.GoogleVerifier) *AuthService {
	return &AuthService{db: db, otpMgr: otpMgr, sessionMgr: sessionMgr, tokenMgr: tokenMgr, users: users, firebase: firebase, google: google}
}

func (s *AuthService) SendOTP(ctx context.Context, email, clientIP string) (int, error) {
	return s.otpMgr.SendOTP(ctx, normalizeEmail(email), clientIP)
}

type VerifyResult struct {
	AccessToken     string
	AccessExpiresAt time.Time
	RefreshToken    string
	User            *models.User
	IsNewUser       bool
}

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

func normalizeEmail(email string) string { return strings.ToLower(strings.TrimSpace(email)) }

// GoogleVerify validates the Google ID token, finds or creates the user by its
// verified email, and issues the usual TajikShop session. It refuses to silently
// link a Google identity to a separate existing account with a conflicting Google subject.
func (s *AuthService) GoogleVerify(ctx context.Context, idToken string, device auth.DeviceInfo) (*VerifyResult, error) {
	identity, err := s.google.VerifyIDToken(ctx, idToken)
	if err != nil {
		switch err {
		case auth.ErrGoogleNotConfigured:
			return nil, fmt.Errorf("google sign-in not configured: %w", err)
		case auth.ErrGoogleTokenInvalid:
			return nil, fmt.Errorf("invalid Google ID token: %w", err)
		default:
			return nil, fmt.Errorf("verify Google ID token: %w", err)
		}
	}

	isNewUser := false
	user, err := s.users.GetByGoogleID(ctx, s.db, identity.Subject)
	if err != nil && err != repository.ErrNotFound {
		return nil, fmt.Errorf("service: lookup Google user: %w", err)
	}
	if err == repository.ErrNotFound {
		// If the verified email already belongs to an account, require an explicit
		// account-link flow rather than silently attaching a Google identity.
		_, emailErr := s.users.GetByEmail(ctx, s.db, identity.Email)
		if emailErr == nil {
			return nil, apperr.New(apperr.CodeConflict, map[string]any{"field": "email", "reason": "account_link_required"})
		}
		if emailErr != repository.ErrNotFound {
			return nil, fmt.Errorf("service: lookup email for Google account: %w", emailErr)
		}
		user, err = s.users.CreateWithGoogle(ctx, s.db, identity.Email, identity.Subject, identity.Name, identity.Picture)
		if err != nil {
			return nil, fmt.Errorf("service: create Google user: %w", err)
		}
		isNewUser = true
	} else {
		if err := s.users.UpdateGoogleIdentity(ctx, s.db, user.ID, identity.Subject, identity.Name, identity.Picture); err != nil {
			return nil, fmt.Errorf("service: update Google identity: %w", err)
		}
		user, err = s.users.GetByID(ctx, s.db, user.ID)
		if err != nil {
			return nil, fmt.Errorf("service: reload Google user: %w", err)
		}
	}
	return s.issueTokens(ctx, user, isNewUser, device)
}

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
		if updated, err := s.users.UpdateProfile(ctx, s.db, user.ID, fullName, nil, nil, nil); err == nil {
			user = updated
		}
	}
	return s.issueTokens(ctx, user, isNewUser, device)
}

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
	return &VerifyResult{AccessToken: access, AccessExpiresAt: expiresAt, RefreshToken: newRefresh, User: user}, nil
}

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
	return &VerifyResult{AccessToken: access, AccessExpiresAt: expiresAt, RefreshToken: refresh, User: user, IsNewUser: isNewUser}, nil
}
