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
