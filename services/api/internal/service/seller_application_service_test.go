package service

import (
	"testing"
	"time"
)

func TestAgeInYears(t *testing.T) {
	at := time.Date(2026, 8, 24, 0, 0, 0, 0, time.UTC)

	cases := []struct {
		name  string
		birth time.Time
		want  int
	}{
		{"birthday already passed this year", time.Date(2000, 1, 1, 0, 0, 0, 0, time.UTC), 26},
		{"birthday is today", time.Date(2008, 8, 24, 0, 0, 0, 0, time.UTC), 18},
		{"birthday not yet reached this year", time.Date(2008, 8, 25, 0, 0, 0, 0, time.UTC), 17},
		{"birthday next month", time.Date(2007, 9, 1, 0, 0, 0, 0, time.UTC), 18},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := ageInYears(tc.birth, at); got != tc.want {
				t.Errorf("ageInYears(%v, %v) = %d, want %d", tc.birth, at, got, tc.want)
			}
		})
	}
}
