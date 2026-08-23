package db

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/alicebob/miniredis/v2"
	"github.com/redis/go-redis/v9"
)

// NewRedisClient creates and validates a Redis client used for OTP
// throttling, rate limiting, and the order-creation idempotency cache.
func NewRedisClient(ctx context.Context, redisURL string) (*redis.Client, error) {
	opt, err := redis.ParseURL(redisURL)
	if err != nil {
		return nil, fmt.Errorf("db: parse REDIS_URL: %w", err)
	}
	client := redis.NewClient(opt)

	pingCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	if err := client.Ping(pingCtx).Err(); err != nil {
		_ = client.Close()
		return nil, fmt.Errorf("db: redis ping: %w", err)
	}
	return client, nil
}

// ConnectRedis connects to redisURL, or — when it's empty — starts an
// in-process, in-memory Redis-compatible server (miniredis) and connects to
// that instead, so the rest of the app (rate limiting, OTP cooldowns,
// checkout idempotency) works unchanged with zero external setup. This is
// meant for small/single-instance deployments (see
// docs/HUGGINGFACE_DEPLOYMENT.md); the in-memory data does not survive a
// restart and isn't shared across replicas. The returned cleanup func stops
// the in-memory server, if one was started; it's a no-op otherwise.
func ConnectRedis(ctx context.Context, redisURL string) (*redis.Client, func(), error) {
	if redisURL != "" {
		client, err := NewRedisClient(ctx, redisURL)
		if err != nil {
			return nil, nil, err
		}
		return client, func() { _ = client.Close() }, nil
	}

	log.Println("db: REDIS_URL not set — starting an in-process, in-memory Redis (data is lost on restart; set REDIS_URL for a real deployment)")
	mr := miniredis.NewMiniRedis()
	if err := mr.Start(); err != nil {
		return nil, nil, fmt.Errorf("db: start in-memory redis: %w", err)
	}

	client, err := NewRedisClient(ctx, "redis://"+mr.Addr())
	if err != nil {
		mr.Close()
		return nil, nil, err
	}
	return client, func() {
		_ = client.Close()
		mr.Close()
	}, nil
}
