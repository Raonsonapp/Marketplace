// Package repository implements plain parameterized pgx SQL access, one
// file per aggregate, with no ORM and no string-concatenated SQL (per
// docs/SECURITY.md). Every function takes a Querier so callers can pass
// either the shared *pgxpool.Pool or an in-flight *pgx.Tx (checkout/order
// creation runs several repository calls inside one transaction with
// `SELECT ... FOR UPDATE` on the touched inventory rows).
package repository

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

// Querier is satisfied by both *pgxpool.Pool and pgx.Tx.
type Querier interface {
	Exec(ctx context.Context, sql string, args ...any) (pgconn.CommandTag, error)
	Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error)
	QueryRow(ctx context.Context, sql string, args ...any) pgx.Row
}

// ErrNotFound is returned by single-row lookups that find nothing. It is
// intentionally distinct from pgx.ErrNoRows so callers outside this package
// never need to import pgx.
var ErrNotFound = errNotFound{}

type errNotFound struct{}

func (errNotFound) Error() string { return "repository: not found" }

func isNoRows(err error) bool {
	return err == pgx.ErrNoRows
}

// ErrConflict is returned when an insert/update violates a unique
// constraint that the caller should map to a specific, user-facing app
// error (e.g. a duplicate review) rather than a generic 500.
var ErrConflict = errConflict{}

type errConflict struct{}

func (errConflict) Error() string { return "repository: conflict" }

// isUniqueViolation reports whether err is a Postgres unique_violation
// (SQLSTATE 23505), the error pgx returns for a violated UNIQUE constraint.
func isUniqueViolation(err error) bool {
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) {
		return pgErr.Code == "23505"
	}
	return false
}
