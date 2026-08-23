package httpapi

import (
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/middleware"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/pagination"
)

// handleErr maps any error returned by the service layer to the standard
// error envelope: a *apperr.Error carries its own code/status, anything
// else becomes an opaque INTERNAL_ERROR (never leaking internals to the client).
func handleErr(c *gin.Context, err error) {
	if ae, ok := apperr.As(err); ok {
		middleware.RespondError(c, ae)
		return
	}
	log.Printf("internal error: %v", err)
	middleware.RespondError(c, apperr.New(apperr.CodeInternal, nil))
}

// ok writes a 200 JSON body.
func ok(c *gin.Context, body any) {
	c.JSON(http.StatusOK, body)
}

// created writes a 201 JSON body.
func created(c *gin.Context, body any) {
	c.JSON(http.StatusCreated, body)
}

// noContent writes a 204.
func noContent(c *gin.Context) {
	c.Status(http.StatusNoContent)
}

// list writes the standard `{"data": [...], "next_cursor": ...}` envelope.
func list(c *gin.Context, data any, nextCursor string) {
	var nc any
	if nextCursor != "" {
		nc = nextCursor
	}
	c.JSON(http.StatusOK, gin.H{"data": data, "next_cursor": nc})
}

// queryLimit reads and clamps the `limit` query param.
func queryLimit(c *gin.Context) int {
	n, err := strconv.Atoi(c.Query("limit"))
	if err != nil {
		n = 0
	}
	return pagination.ClampLimit(n)
}

// queryOffset decodes the `cursor` query param into an offset.
func queryOffset(c *gin.Context) int {
	return pagination.DecodeOffset(c.Query("cursor"))
}
