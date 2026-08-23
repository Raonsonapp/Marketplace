package httpapi

import (
	"context"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/redis/go-redis/v9"
)

// HealthHandler implements GET /healthz.
type HealthHandler struct {
	db  *pgxpool.Pool
	rdb *redis.Client
}

// NewHealthHandler builds a HealthHandler.
func NewHealthHandler(db *pgxpool.Pool, rdb *redis.Client) *HealthHandler {
	return &HealthHandler{db: db, rdb: rdb}
}

// Check handles GET /healthz: 200 with component status when everything is
// reachable, 503 otherwise. Never requires authentication.
func (h *HealthHandler) Check(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), 3*time.Second)
	defer cancel()

	status := gin.H{"status": "ok"}
	healthy := true

	if err := h.db.Ping(ctx); err != nil {
		status["database"] = "unreachable"
		healthy = false
	} else {
		status["database"] = "ok"
	}

	if err := h.rdb.Ping(ctx).Err(); err != nil {
		status["redis"] = "unreachable"
		healthy = false
	} else {
		status["redis"] = "ok"
	}

	if !healthy {
		status["status"] = "degraded"
		c.JSON(503, status)
		return
	}
	c.JSON(200, status)
}
