// Package dto holds the HTTP request/response shapes for every endpoint in
// docs/API_SPEC.md, plus the field-level validation docs/SECURITY.md
// requires before anything reaches the service layer.
package dto

import (
	"regexp"

	"github.com/google/uuid"
)

// phoneRegex matches the Tajikistan phone format required by
// docs/SECURITY.md: "+992XXXXXXXXX" (a '+', country code 992, 9 digits).
var phoneRegex = regexp.MustCompile(`^\+992\d{9}$`)

// ValidPhone reports whether phone matches the required +992XXXXXXXXX shape.
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
