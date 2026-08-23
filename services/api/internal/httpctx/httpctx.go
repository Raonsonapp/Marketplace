// Package httpctx holds small Gin-context helpers shared between
// internal/middleware (which sets them) and internal/httpapi (which reads
// them), kept in their own package so neither of those two needs to import
// the other.
package httpctx

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

const (
	keyUserID = "auth.user_id"
	keyRole   = "auth.role"
	keyLang   = "lang"
)

// SetAuth stores the authenticated user's id/role on the Gin context.
func SetAuth(c *gin.Context, userID uuid.UUID, role string) {
	c.Set(keyUserID, userID)
	c.Set(keyRole, role)
}

// UserID returns the authenticated user's id, or (uuid.Nil, false) for an
// anonymous request.
func UserID(c *gin.Context) (uuid.UUID, bool) {
	v, ok := c.Get(keyUserID)
	if !ok {
		return uuid.Nil, false
	}
	id, ok := v.(uuid.UUID)
	return id, ok
}

// MustUserID returns the authenticated user's id, panicking if absent. Only
// call this in handlers mounted behind middleware.RequireAuth.
func MustUserID(c *gin.Context) uuid.UUID {
	id, ok := UserID(c)
	if !ok {
		panic("httpctx: MustUserID called without an authenticated user")
	}
	return id
}

// Role returns the authenticated user's role, or "" for an anonymous request.
func Role(c *gin.Context) string {
	v, ok := c.Get(keyRole)
	if !ok {
		return ""
	}
	role, _ := v.(string)
	return role
}

// SetLang stores the resolved response language ("tj" or "ru") on the context.
func SetLang(c *gin.Context, lang string) {
	c.Set(keyLang, lang)
}

// Lang returns the resolved response language, defaulting to "tj".
func Lang(c *gin.Context) string {
	v, ok := c.Get(keyLang)
	if !ok {
		return "tj"
	}
	lang, _ := v.(string)
	if lang == "" {
		return "tj"
	}
	return lang
}
