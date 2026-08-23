package middleware

import (
	"strconv"
	"time"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
)

// RateLimit applies a general per-client-IP (falling back to authenticated
// user id) request quota to a route group, independent of the
// auth-specific OTP quotas enforced inside internal/auth.
func RateLimit(limiter *auth.Limiter, limit int, window time.Duration) gin.HandlerFunc {
	return func(c *gin.Context) {
		key := "rl:ip:" + c.ClientIP()
		if uid, ok := httpctx.UserID(c); ok {
			key = "rl:user:" + uid.String()
		}
		allowed, retryAfter, err := limiter.Allow(c.Request.Context(), key, limit, window)
		if err != nil {
			respondError(c, apperr.Wrap(apperr.CodeInternal, err, nil))
			return
		}
		if !allowed {
			c.Header("Retry-After", formatSeconds(retryAfter))
			respondError(c, apperr.New(apperr.CodeRateLimited, map[string]any{
				"retry_after_seconds": int(retryAfter.Seconds()),
			}))
			return
		}
		c.Next()
	}
}

func formatSeconds(d time.Duration) string {
	secs := int(d.Seconds())
	if secs < 1 {
		secs = 1
	}
	return strconv.Itoa(secs)
}
