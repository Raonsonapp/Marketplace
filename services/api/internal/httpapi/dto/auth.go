package dto

import (
	"time"

	"tajikshop/api/internal/models"
)

// SendOTPRequest is the body for POST /auth/send-otp. The identifier is an
// email address — codes are delivered by mail, not SMS
// (internal/pkg/otp/email.go).
type SendOTPRequest struct {
	Email string `json:"email" binding:"required"`
}

// SendOTPResponse is the response for POST /auth/send-otp.
type SendOTPResponse struct {
	RetryAfterSeconds int `json:"retry_after_seconds"`
}

// VerifyOTPRequest is the body for POST /auth/verify-otp.
type VerifyOTPRequest struct {
	Email string `json:"email" binding:"required"`
	Code  string `json:"code" binding:"required"`
}

// RefreshRequest is the body for POST /auth/refresh.
type RefreshRequest struct {
	RefreshToken string `json:"refresh_token" binding:"required"`
}

// LogoutRequest is the body for POST /auth/logout.
type LogoutRequest struct {
	RefreshToken string `json:"refresh_token" binding:"required"`
}

// FirebaseVerifyRequest is the body for POST /auth/firebase-verify — the
// real-SMS registration/login path. The mobile app sends the ID token it
// received from Firebase Phone Auth after the user entered the code
// Firebase texted to their device; the server never sees the SMS code
// itself, only this token, which it verifies with Google before issuing a
// TajikShop session.
type FirebaseVerifyRequest struct {
	IDToken  string  `json:"id_token" binding:"required"`
	FullName *string `json:"full_name"`
}

// UserResponse mirrors a user for API responses (GET /profile, verify-otp, etc).
type UserResponse struct {
	ID        string    `json:"id"`
	Phone     string    `json:"phone"`
	FullName  *string   `json:"full_name,omitempty"`
	Email     *string   `json:"email,omitempty"`
	Role      string    `json:"role"`
	AvatarURL *string   `json:"avatar_url,omitempty"`
	Language  string    `json:"language"`
	Country   string    `json:"country"`
	CreatedAt time.Time `json:"created_at"`
}

// NewUserResponse converts a models.User.
func NewUserResponse(u models.User) UserResponse {
	return UserResponse{
		ID: u.ID.String(), Phone: u.Phone, FullName: u.FullName, Email: u.Email,
		Role: u.Role, AvatarURL: u.AvatarURL, Language: u.Language, Country: u.Country,
		CreatedAt: u.CreatedAt,
	}
}

// AuthResponse is the response for POST /auth/verify-otp.
type AuthResponse struct {
	AccessToken  string       `json:"access_token"`
	RefreshToken string       `json:"refresh_token"`
	User         UserResponse `json:"user"`
	IsNewUser    bool         `json:"is_new_user"`
}

// RefreshResponse is the response for POST /auth/refresh.
type RefreshResponse struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

// ProfileUpdateRequest is the body for PATCH /profile.
type ProfileUpdateRequest struct {
	FullName *string `json:"full_name"`
	Email    *string `json:"email"`
	Language *string `json:"language"`
	Country  *string `json:"country"`
}
