// Package migrations embeds the SQL migration files copied from
// infrastructure/database/migrations (the canonical source of truth per
// docs/ARCHITECTURE.md's monorepo layout) so the compiled server binary can
// run them against an empty database with no filesystem dependency.
package migrations

import "embed"

//go:embed *.sql
var FS embed.FS
