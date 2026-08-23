package middleware

import (
	"log"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/pkg/apperr"
)

// Recovery converts a panic in any downstream handler into a clean 500
// error envelope instead of crashing the process or leaking a stack trace
// to the client.
func Recovery() gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if r := recover(); r != nil {
				log.Printf("panic recovered: %v", r)
				respondError(c, apperr.New(apperr.CodeInternal, nil))
			}
		}()
		c.Next()
	}
}
