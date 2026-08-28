package models

import (
	"time"

	"github.com/google/uuid"
)

// User roles, matching the CHECK constraint on users.role.
const (
	RoleCustomer     = "customer"
	RoleStoreManager = "store_manager"
	RoleCourier      = "courier"
	RoleSupportAgent = "support_agent"
	RoleAdmin        = "admin"
)

// User mirrors the users table.
type User struct {
	ID        uuid.UUID
	Phone     string
	FullName  *string
	Email     *string
	Role      string
	AvatarURL *string
	Language  string
	// Country is the market the account shops in ("TJ" or "RU"): it decides
	// the currency shown, the dial code prefilled and where the address map
	// opens. See migration 0007.
	Country   string
	GoogleID  *string
	IsActive  bool
	CreatedAt time.Time
	UpdatedAt time.Time
}

// Session mirrors user_sessions (one row per device/refresh token).
type Session struct {
	ID               uuid.UUID
	UserID           uuid.UUID
	RefreshTokenHash string
	DeviceID         *string
	DeviceName       *string
	IP               *string
	UserAgent        *string
	ExpiresAt        time.Time
	RevokedAt        *time.Time
	CreatedAt        time.Time
	LastUsedAt       time.Time
}

// OTPPurpose values, matching otp_codes.purpose CHECK constraint.
const (
	OTPPurposeLogin    = "login"
	OTPPurposeRegister = "register"
)

// OTPCode mirrors the otp_codes table.
type OTPCode struct {
	ID          uuid.UUID
	Phone       string
	CodeHash    string
	Purpose     string
	Attempts    int
	MaxAttempts int
	ExpiresAt   time.Time
	ConsumedAt  *time.Time
	CreatedAt   time.Time
}
