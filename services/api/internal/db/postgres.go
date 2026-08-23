package db

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// NewPostgresPool creates and validates a pgx connection pool.
func NewPostgresPool(ctx context.Context, databaseURL string) (*pgxpool.Pool, error) {
	cfg, err := pgxpool.ParseConfig(databaseURL)
	if err != nil {
		return nil, fmt.Errorf("db: parse DATABASE_URL: %w", err)
	}
	cfg.MaxConns = 20
	cfg.MinConns = 1
	cfg.MaxConnLifetime = time.Hour
	cfg.HealthCheckPeriod = time.Minute

	// Managed poolers (Supabase's Session/Transaction pooler, PgBouncer,
	// Supavisor, ...) can hand a reconnecting client a backend connection
	// that still has a same-named prepared statement left over from a
	// previous, abruptly-terminated session — pgx names statements
	// deterministically by SQL hash, so the collision surfaces as
	// "prepared statement ... already exists" (SQLSTATE 42P05). Simple
	// protocol mode never prepares/names statements, so it's safe through
	// any pooler; direct, unpooled Postgres works fine with it too.
	cfg.ConnConfig.DefaultQueryExecMode = pgx.QueryExecModeSimpleProtocol

	// Every table this app queries lives in AppSchema (see migrate.go), not
	// "public" — RunMigrations already created it and applied migrations
	// there. Setting search_path here means every unqualified table name in
	// every existing query (there is no schema-qualification anywhere in
	// this codebase) resolves against AppSchema automatically.
	cfg.ConnConfig.RuntimeParams["search_path"] = AppSchema

	pool, err := pgxpool.NewWithConfig(ctx, cfg)
	if err != nil {
		return nil, fmt.Errorf("db: create pool: %w", err)
	}

	pingCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	if err := pool.Ping(pingCtx); err != nil {
		pool.Close()
		return nil, fmt.Errorf("db: ping: %w", err)
	}
	return pool, nil
}
