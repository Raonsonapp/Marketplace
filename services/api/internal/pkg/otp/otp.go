// Package otp generates one-time passcodes and defines the pluggable
// delivery interface described in docs/ARCHITECTURE.md and docs/SECURITY.md:
// a real SMS gateway can implement Sender in production; local development
// uses ConsoleSender, which logs the code instead of sending an SMS.
package otp

import (
	"context"
	"crypto/rand"
	"fmt"
	"log"
	"math/big"
)

// CodeLength is the number of digits in a generated code.
const CodeLength = 6

// Generate returns a cryptographically random numeric code of CodeLength
// digits, e.g. "042817". Leading zeros are preserved.
func Generate() (string, error) {
	max := big.NewInt(1)
	for i := 0; i < CodeLength; i++ {
		max.Mul(max, big.NewInt(10))
	}
	n, err := rand.Int(rand.Reader, max)
	if err != nil {
		return "", fmt.Errorf("otp: generate random: %w", err)
	}
	return fmt.Sprintf("%0*d", CodeLength, n.Int64()), nil
}

// Sender delivers an OTP code to a phone number. Production implementations
// wrap a real SMS gateway (e.g. an Oson SMS / Beeline / Megafon Tajik
// aggregator); the interface is deliberately provider-agnostic so the
// gateway can be swapped without touching auth business logic.
type Sender interface {
	Send(ctx context.Context, phone, code string) error
}

// ConsoleSender logs the OTP code via the standard logger instead of
// sending a real SMS. This is the local-development implementation wired in
// when no production SMS provider is configured.
type ConsoleSender struct{}

// NewConsoleSender constructs a ConsoleSender.
func NewConsoleSender() *ConsoleSender { return &ConsoleSender{} }

// Send implements Sender by logging the code.
func (c *ConsoleSender) Send(_ context.Context, phone, code string) error {
	log.Printf("[otp:console] OTP for %s: %s", phone, code)
	return nil
}
