package db

import (
	"context"
	"errors"
	"fmt"
	nurl "net/url"
	"strings"
	"time"

	"github.com/golang-migrate/migrate/v4"
	pgxmigrate "github.com/golang-migrate/migrate/v4/database/pgx/v5"
	"github.com/golang-migrate/migrate/v4/source/iofs"
	"github.com/jackc/pgx/v5"

	"tajikshop/api/migrations"
)

// AppSchema is the dedicated Postgres schema TajikShop's own tables live
// in — deliberately not "public". A managed database (this account's
// Supabase project in particular) is routinely shared across more than one
// app; "public" is exactly where an unrelated app's own tables land by
// default, and this schema has already collided with a pre-existing
// "users"/"categories" table pair that happened to share TajikShop's table
// names but not its columns ("column \"name_tj\" does not exist"). Giving
// TajikShop its own namespace makes that whole class of collision
// impossible regardless of what else lives in the same database, with zero
// per-query code changes needed: every unqualified table reference in this
// codebase resolves against search_path, which both RunMigrations and
// NewPostgresPool point at this schema.
const AppSchema = "tajikshop"

// RunMigrations applies every pending up-migration embedded from
// services/api/migrations (copied from infrastructure/database/migrations,
// the canonical source — see docs/ARCHITECTURE.md monorepo layout) against
// databaseURL, inside the dedicated AppSchema (created first if it doesn't
// exist yet). It is safe to call on every process start: golang-migrate
// tracks applied versions in AppSchema's own schema_migrations table and is
// a no-op when the schema is already current.
func RunMigrations(databaseURL string) error {
	if err := ensureAppSchema(databaseURL); err != nil {
		return fmt.Errorf("migrate: create schema %q: %w%s", AppSchema, err, dbHostHint(err))
	}

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

// ensureAppSchema creates AppSchema if it doesn't already exist, using a
// throwaway connection on whatever schema the URL defaults to (this must
// happen before anything sets search_path to AppSchema, since CREATE SCHEMA
// obviously can't run inside the schema it's about to create).
func ensureAppSchema(databaseURL string) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	conn, err := pgx.Connect(ctx, databaseURL)
	if err != nil {
		return err
	}
	defer conn.Close(ctx)
	_, err = conn.Exec(ctx, `CREATE SCHEMA IF NOT EXISTS `+pgx.Identifier{AppSchema}.Sanitize())
	return err
}

// toMigrateURL rewrites a postgres:// or postgresql:// DATABASE_URL into the
// pgx5:// scheme golang-migrate's pgx/v5 database driver registers itself
// under (see database/pgx/v5.init), points it at AppSchema via search_path,
// and forces simple query protocol so the migration connection never names
// a prepared statement — see the matching comment on DefaultQueryExecMode
// in postgres.go for why that matters against a pooler (Supabase
// Session/Transaction pooler, PgBouncer, ...).
func toMigrateURL(databaseURL string) (string, error) {
	u, err := nurl.Parse(databaseURL)
	if err != nil {
		return "", err
	}
	u.Scheme = "pgx5"
	q := u.Query()
	q.Set("default_query_exec_mode", "simple_protocol")
	q.Set("search_path", AppSchema)
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
