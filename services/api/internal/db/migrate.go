package db

import (
	"errors"
	"fmt"
	nurl "net/url"
	"strings"

	"github.com/golang-migrate/migrate/v4"
	pgxmigrate "github.com/golang-migrate/migrate/v4/database/pgx/v5"
	"github.com/golang-migrate/migrate/v4/source/iofs"

	"tajikshop/api/migrations"
)

// RunMigrations applies every pending up-migration embedded from
// services/api/migrations (copied from infrastructure/database/migrations,
// the canonical source — see docs/ARCHITECTURE.md monorepo layout) against
// databaseURL. It is safe to call on every process start: golang-migrate
// tracks applied versions in a schema_migrations table and is a no-op when
// the schema is already current.
func RunMigrations(databaseURL string) error {
	src, err := iofs.New(migrations.FS, ".")
	if err != nil {
		return fmt.Errorf("migrate: load embedded migrations: %w", err)
	}

	migrateURL, err := toMigrateURL(databaseURL)
	if err != nil {
		return fmt.Errorf("migrate: parse DATABASE_URL: %w", err)
	}

	m, err := migrate.NewWithSourceInstance("iofs", src, migrateURL)
	if err != nil {
		return fmt.Errorf("migrate: init: %w%s", err, dbHostHint(err))
	}
	defer func() {
		_, _ = m.Close()
	}()

	if err := m.Up(); err != nil && !errors.Is(err, migrate.ErrNoChange) {
		return fmt.Errorf("migrate: up: %w", err)
	}
	return nil
}

// toMigrateURL rewrites a postgres:// or postgresql:// DATABASE_URL into the
// pgx5:// scheme golang-migrate's pgx/v5 database driver registers itself
// under (see database/pgx/v5.init), and forces simple query protocol so the
// migration connection never names a prepared statement — see the matching
// comment on DefaultQueryExecMode in postgres.go for why that matters
// against a pooler (Supabase Session/Transaction pooler, PgBouncer, ...).
func toMigrateURL(databaseURL string) (string, error) {
	u, err := nurl.Parse(databaseURL)
	if err != nil {
		return "", err
	}
	u.Scheme = "pgx5"
	q := u.Query()
	q.Set("default_query_exec_mode", "simple_protocol")
	u.RawQuery = q.Encode()
	return u.String(), nil
}

// dbHostHint appends actionable guidance for specific, previously-hit
// failure modes when connecting to a managed Postgres from a container
// platform without IPv6 egress (e.g. Hugging Face Spaces) — see
// docs/HUGGINGFACE_DEPLOYMENT.md. Returns "" for any other error, so it
// never claims to diagnose something it hasn't actually recognized.
func dbHostHint(err error) string {
	msg := err.Error()
	switch {
	case strings.Contains(msg, "no such host") && strings.Contains(msg, "supabase.co"):
		return " (hint: use Supabase's \"Session pooler\" connection string, not \"Direct connection\" — Project Settings -> Database; see docs/HUGGINGFACE_DEPLOYMENT.md)"
	case strings.Contains(msg, "prepared statement") && strings.Contains(msg, "already exists"):
		return " (hint: a pooled Postgres connection reused a backend with a leftover prepared statement from a previous session — this should no longer happen now that migrations run with default_query_exec_mode=simple_protocol; if you still see this, the pooler itself may need a moment to recycle stale backends after a crash)"
	}
	return ""
}

// ensure the pgx v5 database driver package (which self-registers via
// init()) is linked into the binary.
var _ = pgxmigrate.DefaultMigrationsTable
