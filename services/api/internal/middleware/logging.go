package middleware

import (
	"log"
	"time"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpctx"
)

// StructuredLogging logs method, path, status, latency, and user id (never
// request/response bodies, per docs/SECURITY.md).
func StructuredLogging() gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		path := c.Request.URL.Path
		if raw := c.Request.URL.RawQuery; raw != "" {
			path = path + "?" + raw
		}

		c.Next()

		latency := time.Since(start)
		uid := "anon"
		if id, ok := httpctx.UserID(c); ok {
			uid = id.String()
		}
		log.Printf("method=%s path=%s status=%d latency=%s user=%s ip=%s",
			c.Request.Method, path, c.Writer.Status(), latency, uid, c.ClientIP())
	}
}
