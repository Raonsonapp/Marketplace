package db

import (
	"errors"
	"testing"
)

func TestDBHostHint(t *testing.T) {
	cases := []struct {
		name    string
		err     error
		wantHit bool
	}{
		{
			name:    "supabase direct-connection DNS failure",
			err:     errors.New(`hostname resolving error: lookup db.bmuzenfkxpeqkpatpaqz.supabase.co on 172.20.0.10:53: no such host`),
			wantHit: true,
		},
		{
			name:    "unrelated error",
			err:     errors.New("connection refused"),
			wantHit: false,
		},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			hint := dbHostHint(tc.err)
			if tc.wantHit && hint == "" {
				t.Fatalf("expected a hint, got none")
			}
			if !tc.wantHit && hint != "" {
				t.Fatalf("expected no hint, got %q", hint)
			}
		})
	}
}
