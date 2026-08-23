package db

import (
	"errors"
	"strings"
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
			name:    "pooler prepared-statement collision",
			err:     errors.New(`ERROR: prepared statement "stmtcache_c5b314e01b354fbe56946bbebcdcf249ebfe1785ac66f205" already exists (SQLSTATE 42P05)`),
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

func TestToMigrateURL(t *testing.T) {
	got, err := toMigrateURL("postgresql://postgres.ref:pw@aws-0-eu-central-1.pooler.supabase.com:5432/postgres")
	if err != nil {
		t.Fatalf("toMigrateURL: %v", err)
	}
	if !strings.HasPrefix(got, "pgx5://") {
		t.Fatalf("expected pgx5:// scheme, got %q", got)
	}
	if !strings.Contains(got, "default_query_exec_mode=simple_protocol") {
		t.Fatalf("expected default_query_exec_mode=simple_protocol query param, got %q", got)
	}
	if !strings.Contains(got, "search_path=tajikshop") {
		t.Fatalf("expected search_path=tajikshop query param, got %q", got)
	}
}
