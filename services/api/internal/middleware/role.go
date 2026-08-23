package middleware

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
)

// RequireRole rejects the request with 403 unless the authenticated user's
// role is one of allowed. Must be mounted after RequireAuth.
func RequireRole(allowed ...string) gin.HandlerFunc {
	set := make(map[string]bool, len(allowed))
	for _, r := range allowed {
		set[r] = true
	}
	return func(c *gin.Context) {
		role := httpctx.Role(c)
		if role == "" || !set[role] {
			respondError(c, apperr.New(apperr.CodeForbidden, nil))
			return
		}
		c.Next()
	}
}
