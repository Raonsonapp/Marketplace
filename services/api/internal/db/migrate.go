package db

import (
	"errors"
	"fmt"
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

	// golang-migrate's pgx/v5 database driver registers itself under the
	// "pgx5" URL scheme (see database/pgx/v5.init) rather than "postgres".
	migrateURL := "pgx5://" + strings.TrimPrefix(strings.TrimPrefix(databaseURL, "postgres://"), "postgresql://")

	m, err := migrate.NewWithSourceInstance("iofs", src, migrateURL)
	if err != nil {
		return fmt.Errorf("migrate: init: %w", err)
	}
	defer func() {
		_, _ = m.Close()
	}()

	if err := m.Up(); err != nil && !errors.Is(err, migrate.ErrNoChange) {
		return fmt.Errorf("migrate: up: %w", err)
	}
	return nil
}

// ensure the pgx v5 database driver package (which self-registers via
// init()) is linked into the binary.
var _ = pgxmigrate.DefaultMigrationsTable
