// Package middleware implements the Gin middleware chain: auth, RBAC, rate
// limiting, CORS, structured logging, and panic recovery.
package middleware

import (
	"strings"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/httpctx"
	"tajikshop/api/internal/pkg/apperr"
)

// respondError writes the standard error envelope and aborts the chain.
func respondError(c *gin.Context, appErr *apperr.Error) {
	lang := httpctx.Lang(c)
	msg := appErr.Message
	if msg == "" {
		msg = apperr.Localize(appErr.Code, lang)
	}
	details := appErr.Details
	if details == nil {
		details = map[string]any{}
	}
	c.AbortWithStatusJSON(appErr.HTTPStatus(), gin.H{
		"error": gin.H{
			"code":    appErr.Code,
			"message": msg,
			"details": details,
		},
	})
}

// RespondError is the exported form used by httpapi handlers too.
func RespondError(c *gin.Context, appErr *apperr.Error) { respondError(c, appErr) }

// Language resolves the response language from Accept-Language: "ru" is
// used only when explicitly requested; every other value (including
// missing) falls back to "tj", the default per docs/API_SPEC.md.
func Language() gin.HandlerFunc {
	return func(c *gin.Context) {
		lang := "tj"
		if al := c.GetHeader("Accept-Language"); al != "" {
			if strings.Contains(strings.ToLower(al), "ru") {
				lang = "ru"
			}
		}
		httpctx.SetLang(c, lang)
		c.Next()
	}
}

// OptionalAuth parses a Bearer token if present and, when valid, loads the
// user id/role into the context — used by endpoints that work anonymously
// but personalize when a token is present (home/catalog/search).
func OptionalAuth(tm *auth.TokenManager) gin.HandlerFunc {
	return func(c *gin.Context) {
		token := bearerToken(c)
		if token == "" {
			c.Next()
			return
		}
		claims, err := tm.ParseAccessToken(token)
		if err != nil {
			c.Next()
			return
		}
		httpctx.SetAuth(c, claims.UserID, claims.Role)
		c.Next()
	}
}

// RequireAuth parses a Bearer access token and rejects the request with 401
// when it is missing or invalid.
func RequireAuth(tm *auth.TokenManager) gin.HandlerFunc {
	return func(c *gin.Context) {
		token := bearerToken(c)
		if token == "" {
			respondError(c, apperr.New(apperr.CodeUnauthorized, nil))
			return
		}
		claims, err := tm.ParseAccessToken(token)
		if err != nil {
			respondError(c, apperr.New(apperr.CodeUnauthorized, nil))
			return
		}
		httpctx.SetAuth(c, claims.UserID, claims.Role)
		c.Next()
	}
}

func bearerToken(c *gin.Context) string {
	h := c.GetHeader("Authorization")
	if h == "" {
		return ""
	}
	parts := strings.SplitN(h, " ", 2)
	if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
		return ""
	}
	return strings.TrimSpace(parts[1])
}
