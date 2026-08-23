// Package jobs implements background workers. Phase 2 ships the recurring
// housekeeping job every deployment needs from day one (expiring stale
// auth artifacts); the accrual/notification workers docs/ARCHITECTURE.md
// lists are Phase 5 scope and are not stubbed here.
package jobs

import (
	"context"
	"log"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

// CleanupJob periodically deletes expired otp_codes and old revoked/expired
// user_sessions rows, keeping those tables from growing unbounded. It never
// touches a row that is still valid for authentication.
type CleanupJob struct {
	db       *pgxpool.Pool
	interval time.Duration
}

// NewCleanupJob builds a CleanupJob.
func NewCleanupJob(db *pgxpool.Pool, interval time.Duration) *CleanupJob {
	return &CleanupJob{db: db, interval: interval}
}

// Run blocks, executing the cleanup on every tick until ctx is cancelled.
// Intended to be started with `go job.Run(ctx)` from cmd/server/main.go.
func (j *CleanupJob) Run(ctx context.Context) {
	ticker := time.NewTicker(j.interval)
	defer ticker.Stop()
	// Run once immediately on startup, then on each tick.
	j.runOnce(ctx)
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			j.runOnce(ctx)
		}
	}
}

func (j *CleanupJob) runOnce(ctx context.Context) {
	otpTag, err := j.db.Exec(ctx, `DELETE FROM otp_codes WHERE expires_at < now() - interval '1 day'`)
	if err != nil {
		log.Printf("jobs: cleanup otp_codes failed: %v", err)
	} else if n := otpTag.RowsAffected(); n > 0 {
		log.Printf("jobs: cleanup removed %d expired otp_codes rows", n)
	}

	sessTag, err := j.db.Exec(ctx, `
		DELETE FROM user_sessions
		WHERE (revoked_at IS NOT NULL AND revoked_at < now() - interval '30 days')
		   OR expires_at < now() - interval '30 days'`)
	if err != nil {
		log.Printf("jobs: cleanup user_sessions failed: %v", err)
	} else if n := sessTag.RowsAffected(); n > 0 {
		log.Printf("jobs: cleanup removed %d stale user_sessions rows", n)
	}
}
