// Package config loads TajikShop API settings from environment variables
// and fails fast (with a clear error) when a required variable is missing.
//
// JWT signing: docs/SECURITY.md specifies RS256. For Phase 2 we use HS256
// with a single JWT_SECRET instead: generating/rotating an RSA keypair adds
// operational complexity (key distribution, PEM parsing, rotation) with no
// behavioral difference for a single-service backend that both signs and
// verifies its own tokens. HS256 with a strong, secret-manager-held key
// gives the same guarantees here. This is a deliberate, documented
// simplification (see PROJECT_STATE.md "known issues") — swapping to RS256
// later only touches internal/auth/jwt.go, not the rest of the codebase.
package config

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
)

// Config holds all runtime configuration for the API service.
type Config struct {
	Env  string // "development" | "production" | "test"
	Port string

	DatabaseURL string
	RedisURL    string

	JWTSecret     string
	AccessTTL     time.Duration
	RefreshTTL    time.Duration
	OTPTTL        time.Duration
	OTPResendCD   time.Duration
	BcryptCost    int
	CORSOrigins   []string
	MigrationsDir string

	// FirebaseWebAPIKey enables POST /auth/firebase-verify (Firebase Phone
	// Auth as the real-SMS registration path — see docs/FIREBASE_SETUP.md).
	// Optional: when empty, that endpoint returns FIREBASE_NOT_CONFIGURED
	// and the console-OTP flow (send-otp/verify-otp) keeps working as-is.
	FirebaseWebAPIKey string

	// LoyaltyEarnRatePercent is the percentage of order total credited back
	// as TajBonus on delivery/creation (business rule, not schema-enforced).
	LoyaltyEarnRatePercent float64
	// LoyaltyMaxRedeemPercent caps how much of a cart subtotal-after-discount
	// may be paid for using bonus balance in a single order.
	LoyaltyMaxRedeemPercent float64
}

// Load reads configuration from the environment. Required variables missing
// causes Load to return a descriptive error rather than panicking deep
// inside some other package later.
func Load() (*Config, error) {
	var missing []string
	req := func(key string) string {
		v := os.Getenv(key)
		if v == "" {
			missing = append(missing, key)
		}
		return v
	}

	cfg := &Config{
		Env:         getOr("ENV", "development"),
		Port:        getOr("PORT", "8080"),
		DatabaseURL: req("DATABASE_URL"),
		RedisURL:    req("REDIS_URL"),
		JWTSecret:   req("JWT_SECRET"),
	}

	if len(missing) > 0 {
		return nil, fmt.Errorf("config: missing required environment variable(s): %s", strings.Join(missing, ", "))
	}

	if len(cfg.JWTSecret) < 32 {
		return nil, fmt.Errorf("config: JWT_SECRET must be at least 32 characters (got %d)", len(cfg.JWTSecret))
	}

	var err error
	if cfg.AccessTTL, err = getDuration("ACCESS_TOKEN_TTL", 15*time.Minute); err != nil {
		return nil, err
	}
	if cfg.RefreshTTL, err = getDuration("REFRESH_TOKEN_TTL", 30*24*time.Hour); err != nil {
		return nil, err
	}
	otpSecs, err := getInt("OTP_TTL_SECONDS", 300)
	if err != nil {
		return nil, err
	}
	cfg.OTPTTL = time.Duration(otpSecs) * time.Second
	resendSecs, err := getInt("OTP_RESEND_COOLDOWN_SECONDS", 60)
	if err != nil {
		return nil, err
	}
	cfg.OTPResendCD = time.Duration(resendSecs) * time.Second

	if cfg.BcryptCost, err = getInt("BCRYPT_COST", 10); err != nil {
		return nil, err
	}

	cfg.MigrationsDir = getOr("MIGRATIONS_DIR", "migrations")
	cfg.FirebaseWebAPIKey = os.Getenv("FIREBASE_WEB_API_KEY")

	origins := getOr("CORS_ORIGINS", "http://localhost:3000")
	for _, o := range strings.Split(origins, ",") {
		o = strings.TrimSpace(o)
		if o != "" {
			cfg.CORSOrigins = append(cfg.CORSOrigins, o)
		}
	}

	if cfg.LoyaltyEarnRatePercent, err = getFloat("LOYALTY_EARN_RATE_PERCENT", 2.0); err != nil {
		return nil, err
	}
	if cfg.LoyaltyMaxRedeemPercent, err = getFloat("LOYALTY_MAX_REDEEM_PERCENT", 50.0); err != nil {
		return nil, err
	}

	return cfg, nil
}

func getOr(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}

func getDuration(key string, def time.Duration) (time.Duration, error) {
	v := os.Getenv(key)
	if v == "" {
		return def, nil
	}
	d, err := time.ParseDuration(v)
	if err != nil {
		return 0, fmt.Errorf("config: invalid duration for %s: %w", key, err)
	}
	return d, nil
}

func getInt(key string, def int) (int, error) {
	v := os.Getenv(key)
	if v == "" {
		return def, nil
	}
	n, err := strconv.Atoi(v)
	if err != nil {
		return 0, fmt.Errorf("config: invalid integer for %s: %w", key, err)
	}
	return n, nil
}

func getFloat(key string, def float64) (float64, error) {
	v := os.Getenv(key)
	if v == "" {
		return def, nil
	}
	f, err := strconv.ParseFloat(v, 64)
	if err != nil {
		return 0, fmt.Errorf("config: invalid float for %s: %w", key, err)
	}
	return f, nil
}
