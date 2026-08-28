// Package dto holds the HTTP request/response shapes for every endpoint in
// docs/API_SPEC.md, plus the field-level validation docs/SECURITY.md
// requires before anything reaches the service layer.
package dto

import (
	"regexp"

	"github.com/google/uuid"
)

// phoneRegex matches the two regions TajikShop serves (docs/SECURITY.md):
// Tajikistan "+992XXXXXXXXX" (9 national digits) and Russia "+7XXXXXXXXXX"
// (10 national digits, standard Russian mobile format).
var phoneRegex = regexp.MustCompile(`^\+992\d{9}$|^\+7\d{10}$`)

// ValidPhone reports whether phone matches a supported region's shape.
func ValidPhone(phone string) bool {
	return phoneRegex.MatchString(phone)
}

// emailRegex is a deliberately permissive shape check — "something@
// something.tld" with no spaces. Real validation of an address is that a
// code sent to it actually arrives, which the OTP flow already does; a
// stricter pattern here would only reject legitimate addresses.
var emailRegex = regexp.MustCompile(`^[^@\s]+@[^@\s.]+(\.[^@\s.]+)+$`)

// ValidEmail reports whether email is plausibly an address. Used by the
// login endpoints, where the address is both the login identifier and where
// the OTP code is delivered.
func ValidEmail(email string) bool {
	return len(email) <= 255 && emailRegex.MatchString(email)
}

// otpCodeRegex matches a 6-digit OTP code.
var otpCodeRegex = regexp.MustCompile(`^\d{6}$`)

// ValidOTPCode reports whether code is exactly 6 digits.
func ValidOTPCode(code string) bool {
	return otpCodeRegex.MatchString(code)
}

// ParseUUID parses s as a UUID, returning ok=false on any malformed input
// instead of a Go error, so handlers can map it directly to VALIDATION_ERROR.
func ParseUUID(s string) (uuid.UUID, bool) {
	id, err := uuid.Parse(s)
	if err != nil {
		return uuid.Nil, false
	}
	return id, true
}
