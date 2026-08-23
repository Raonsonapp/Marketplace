// Package pagination implements the opaque cursor scheme used by every list
// endpoint in docs/API_SPEC.md (`?cursor=&limit=`, response has
// `next_cursor`). The cursor currently encodes a plain offset; because it is
// opaque to clients, the encoding can move to true keyset pagination later
// without any change to the public API contract.
package pagination

import (
	"encoding/base64"
	"strconv"
)

const (
	DefaultLimit = 20
	MaxLimit     = 100
)

// DecodeOffset decodes a cursor produced by EncodeOffset back into an
// offset. An empty cursor decodes to offset 0. Invalid cursors also decode
// to 0 so a malformed/stale cursor degrades to "start over" rather than 500s.
func DecodeOffset(cursor string) int {
	if cursor == "" {
		return 0
	}
	raw, err := base64.RawURLEncoding.DecodeString(cursor)
	if err != nil {
		return 0
	}
	n, err := strconv.Atoi(string(raw))
	if err != nil || n < 0 {
		return 0
	}
	return n
}

// EncodeOffset encodes an offset into an opaque cursor string.
func EncodeOffset(offset int) string {
	return base64.RawURLEncoding.EncodeToString([]byte(strconv.Itoa(offset)))
}

// NextCursor returns the cursor for the page following one that started at
// offset and returned returnedCount rows out of a page sized limit. When the
// page was not full, there is no further data and it returns "".
func NextCursor(offset, limit, returnedCount int) string {
	if returnedCount < limit {
		return ""
	}
	return EncodeOffset(offset + returnedCount)
}

// ClampLimit normalizes a client-supplied limit to (0, MaxLimit], defaulting
// to DefaultLimit when the input is <= 0.
func ClampLimit(limit int) int {
	if limit <= 0 {
		return DefaultLimit
	}
	if limit > MaxLimit {
		return MaxLimit
	}
	return limit
}
