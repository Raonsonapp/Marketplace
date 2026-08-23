package otp

import (
	"context"
	"regexp"
	"testing"
)

var codePattern = regexp.MustCompile(`^\d{6}$`)

func TestGenerate(t *testing.T) {
	seen := map[string]bool{}
	for i := 0; i < 200; i++ {
		code, err := Generate()
		if err != nil {
			t.Fatalf("Generate() error: %v", err)
		}
		if !codePattern.MatchString(code) {
			t.Fatalf("Generate() = %q, want 6 digits", code)
		}
		seen[code] = true
	}
	// With 200 draws from 1e6 possibilities we expect meaningful variety.
	if len(seen) < 100 {
		t.Errorf("Generate() produced too few distinct codes: %d/200", len(seen))
	}
}

func TestConsoleSender(t *testing.T) {
	s := NewConsoleSender()
	if err := s.Send(context.Background(), "+992900000000", "123456"); err != nil {
		t.Fatalf("Send() error: %v", err)
	}
}
