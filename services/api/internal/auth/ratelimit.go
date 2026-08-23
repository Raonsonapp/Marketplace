package auth

import (
	"context"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
)

// Limiter implements a fixed-window rate limiter backed by Redis, used for
// every quota in docs/SECURITY.md ("5 OTP sends/phone/hour, 20/IP/hour, 5
// verify attempts/phone/15min") plus general API throttling.
type Limiter struct {
	rdb *redis.Client
}

// NewLimiter builds a Limiter.
func NewLimiter(rdb *redis.Client) *Limiter {
	return &Limiter{rdb: rdb}
}

// Allow increments the counter for key and reports whether the caller is
// still within limit for the current window. window controls both the
// bucket size and the key's TTL (fixed-window, reset every `window`).
func (l *Limiter) Allow(ctx context.Context, key string, limit int, window time.Duration) (allowed bool, retryAfter time.Duration, err error) {
	count, err := l.rdb.Incr(ctx, key).Result()
	if err != nil {
		return false, 0, fmt.Errorf("ratelimit: incr: %w", err)
	}
	if count == 1 {
		if err := l.rdb.Expire(ctx, key, window).Err(); err != nil {
			return false, 0, fmt.Errorf("ratelimit: expire: %w", err)
		}
	}
	if count > int64(limit) {
		ttl, err := l.rdb.TTL(ctx, key).Result()
		if err != nil || ttl < 0 {
			ttl = window
		}
		return false, ttl, nil
	}
	return true, 0, nil
}

// Cooldown enforces a simple "at most once per `window`" gate using SET NX,
// used for the 60s OTP resend cooldown (`otp:cooldown:<phone>`).
func (l *Limiter) Cooldown(ctx context.Context, key string, window time.Duration) (allowed bool, retryAfter time.Duration, err error) {
	ok, err := l.rdb.SetNX(ctx, key, "1", window).Result()
	if err != nil {
		return false, 0, fmt.Errorf("ratelimit: setnx: %w", err)
	}
	if ok {
		return true, 0, nil
	}
	ttl, err := l.rdb.TTL(ctx, key).Result()
	if err != nil || ttl < 0 {
		ttl = window
	}
	return false, ttl, nil
}
