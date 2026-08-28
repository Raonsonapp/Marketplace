// Package money provides safe handling of the currency values that map to
// the database's numeric(12,2) columns. Money is represented internally as
// an int64 count of minor units (dirams for TJS, kopecks for RUB — both
// currencies YouShop trades in have exactly two decimal places) so
// arithmetic never suffers floating point rounding error. The amount itself
// carries no currency tag: which currency it is in follows from the country
// of the store or account it belongs to (migration 0007). All API JSON fields are
// strings with exactly two decimals (e.g. "125.50"), matching docs/API_SPEC.md.
package money

import (
	"database/sql/driver"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"strings"
)

// Money is an amount stored as minor units (1/100 of the major unit).
type Money int64

// Zero is the additive identity.
const Zero Money = 0

// ErrInvalidFormat is returned when a string cannot be parsed as money.
var ErrInvalidFormat = errors.New("money: invalid amount format")

// FromString parses a decimal string like "125.50", "125", "-4.2" (a single
// optional leading '-', digits, optional '.' followed by 1-2 digits) into
// Money. Empty string is treated as zero.
func FromString(s string) (Money, error) {
	s = strings.TrimSpace(s)
	if s == "" {
		return 0, nil
	}
	neg := false
	if strings.HasPrefix(s, "-") {
		neg = true
		s = s[1:]
	} else if strings.HasPrefix(s, "+") {
		s = s[1:]
	}
	parts := strings.SplitN(s, ".", 2)
	if len(parts) == 0 || len(parts) > 2 {
		return 0, ErrInvalidFormat
	}
	intPart := parts[0]
	if intPart == "" {
		intPart = "0"
	}
	for _, r := range intPart {
		if r < '0' || r > '9' {
			return 0, ErrInvalidFormat
		}
	}
	fracPart := "00"
	if len(parts) == 2 {
		fracPart = parts[1]
		if len(fracPart) == 0 || len(fracPart) > 2 {
			return 0, ErrInvalidFormat
		}
		for _, r := range fracPart {
			if r < '0' || r > '9' {
				return 0, ErrInvalidFormat
			}
		}
		if len(fracPart) == 1 {
			fracPart += "0"
		}
	}
	whole, err := strconv.ParseInt(intPart, 10, 63)
	if err != nil {
		return 0, ErrInvalidFormat
	}
	frac, err := strconv.ParseInt(fracPart, 10, 63)
	if err != nil {
		return 0, ErrInvalidFormat
	}
	total := whole*100 + frac
	if neg {
		total = -total
	}
	return Money(total), nil
}

// MustFromString parses s and panics on error. Intended for constants/tests.
func MustFromString(s string) Money {
	m, err := FromString(s)
	if err != nil {
		panic(err)
	}
	return m
}

// FromMinorUnits builds a Money value directly from minor units (dirams).
func FromMinorUnits(minor int64) Money { return Money(minor) }

// MinorUnits returns the raw minor-unit (diram) count.
func (m Money) MinorUnits() int64 { return int64(m) }

// String renders the amount with exactly two decimal digits, e.g. "125.50".
func (m Money) String() string {
	v := int64(m)
	neg := v < 0
	if neg {
		v = -v
	}
	whole := v / 100
	frac := v % 100
	s := fmt.Sprintf("%d.%02d", whole, frac)
	if neg {
		s = "-" + s
	}
	return s
}

// Add returns m + other.
func (m Money) Add(other Money) Money { return m + other }

// Sub returns m - other.
func (m Money) Sub(other Money) Money { return m - other }

// Neg returns -m.
func (m Money) Neg() Money { return -m }

// MulInt multiplies by an integer quantity (e.g. unit price * quantity).
func (m Money) MulInt(qty int) Money { return Money(int64(m) * int64(qty)) }

// MulFloat multiplies by a fractional quantity — a parcel's weight in
// kilograms against a per-kilo rate, say — rounding to the nearest minor
// unit, half away from zero. The float only ever multiplies; the result is
// immediately back in exact integer minor units, so no rounding error can
// accumulate across calls.
func (m Money) MulFloat(qty float64) Money {
	v := float64(m) * qty
	if v >= 0 {
		return Money(int64(v + 0.5))
	}
	return Money(int64(v - 0.5))
}

// PercentOf returns pct% of m, rounded to the nearest diram (half away from
// zero), e.g. Money(10000).PercentOf(12.5) == 1250 minor units (12.50 TJS on
// a 100.00 TJS base).
func (m Money) PercentOf(pct float64) Money {
	v := float64(m) * pct / 100.0
	if v >= 0 {
		return Money(int64(v + 0.5))
	}
	return Money(int64(v - 0.5))
}

// IsNegative reports whether m < 0.
func (m Money) IsNegative() bool { return m < 0 }

// IsZero reports whether m == 0.
func (m Money) IsZero() bool { return m == 0 }

// LessThan reports whether m < other.
func (m Money) LessThan(other Money) bool { return m < other }

// GreaterThan reports whether m > other.
func (m Money) GreaterThan(other Money) bool { return m > other }

// Min returns the smaller of m and other.
func Min(a, b Money) Money {
	if a < b {
		return a
	}
	return b
}

// Max returns the larger of m and other.
func Max(a, b Money) Money {
	if a > b {
		return a
	}
	return b
}

// ClampNonNegative returns m if m >= 0, otherwise Zero.
func (m Money) ClampNonNegative() Money {
	if m < 0 {
		return 0
	}
	return m
}

// MarshalJSON encodes Money as a JSON string, e.g. "125.50".
func (m Money) MarshalJSON() ([]byte, error) {
	return json.Marshal(m.String())
}

// UnmarshalJSON decodes Money from a JSON string or JSON number.
func (m *Money) UnmarshalJSON(data []byte) error {
	var s string
	if err := json.Unmarshal(data, &s); err == nil {
		v, perr := FromString(s)
		if perr != nil {
			return perr
		}
		*m = v
		return nil
	}
	// Fall back to numeric JSON (not the documented format, but tolerated).
	var f float64
	if err := json.Unmarshal(data, &f); err != nil {
		return ErrInvalidFormat
	}
	*m = Money(int64(f*100 + 0.5))
	return nil
}

// Value implements driver.Valuer so Money can be used directly as a query
// parameter against a numeric(12,2) column when the SQL text casts the
// placeholder explicitly (e.g. "$1::numeric").
func (m Money) Value() (driver.Value, error) {
	return m.String(), nil
}
