package db

import (
	"context"
	"testing"
)

func TestConnectRedis_InMemoryFallback(t *testing.T) {
	client, cleanup, err := ConnectRedis(context.Background(), "")
	if err != nil {
		t.Fatalf("ConnectRedis with empty URL: %v", err)
	}
	defer cleanup()

	if err := client.Ping(context.Background()).Err(); err != nil {
		t.Fatalf("ping in-memory redis: %v", err)
	}
	if err := client.Set(context.Background(), "smoke", "ok", 0).Err(); err != nil {
		t.Fatalf("set on in-memory redis: %v", err)
	}
	got, err := client.Get(context.Background(), "smoke").Result()
	if err != nil {
		t.Fatalf("get on in-memory redis: %v", err)
	}
	if got != "ok" {
		t.Fatalf("expected %q, got %q", "ok", got)
	}
}
