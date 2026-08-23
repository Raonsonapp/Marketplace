package service

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"tajikshop/api/internal/models"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/pkg/money"
	"tajikshop/api/internal/repository"
)

func m(s string) money.Money { return money.MustFromString(s) }

func TestComputeDiscountAmountPercentage(t *testing.T) {
	subtotal := m("200.00")
	// 10% of 200.00 = 20.00
	got := computeDiscountAmount(models.DiscountTypePercentage, m("10.00"), nil, subtotal)
	if got.String() != "20.00" {
		t.Errorf("got %s, want 20.00", got)
	}
}

func TestComputeDiscountAmountPercentageCappedByMax(t *testing.T) {
	subtotal := m("1000.00")
	max := m("50.00")
	// 10% of 1000.00 = 100.00, capped at 50.00
	got := computeDiscountAmount(models.DiscountTypePercentage, m("10.00"), &max, subtotal)
	if got.String() != "50.00" {
		t.Errorf("got %s, want 50.00", got)
	}
}

func TestComputeDiscountAmountFixedCappedBySubtotal(t *testing.T) {
	subtotal := m("15.00")
	// A 50.00 fixed discount can never exceed a 15.00 subtotal.
	got := computeDiscountAmount(models.DiscountTypeFixed, m("50.00"), nil, subtotal)
	if got.String() != "15.00" {
		t.Errorf("got %s, want 15.00", got)
	}
}

func TestComputeDiscountAmountFixed(t *testing.T) {
	subtotal := m("200.00")
	got := computeDiscountAmount(models.DiscountTypeFixed, m("25.00"), nil, subtotal)
	if got.String() != "25.00" {
		t.Errorf("got %s, want 25.00", got)
	}
}

func TestComputeBonusAppliedCappedByBalance(t *testing.T) {
	// Requested more than the account holds: capped at balance.
	got := computeBonusApplied(m("100.00"), m("30.00"), m("200.00"), 50)
	if got.String() != "30.00" {
		t.Errorf("got %s, want 30.00", got)
	}
}

func TestComputeBonusAppliedCappedByRedeemRule(t *testing.T) {
	// 50% of a 100.00 post-discount subtotal = 50.00 max, even though the
	// account has plenty and the customer asked for more.
	got := computeBonusApplied(m("80.00"), m("500.00"), m("100.00"), 50)
	if got.String() != "50.00" {
		t.Errorf("got %s, want 50.00", got)
	}
}

func TestComputeBonusAppliedZeroWhenNotRequested(t *testing.T) {
	got := computeBonusApplied(m("0.00"), m("500.00"), m("100.00"), 50)
	if !got.IsZero() {
		t.Errorf("got %s, want 0.00", got)
	}
}

func TestComputeBonusAppliedNegativeRequestIgnored(t *testing.T) {
	got := computeBonusApplied(m("-10.00"), m("500.00"), m("100.00"), 50)
	if !got.IsZero() {
		t.Errorf("got %s, want 0.00", got)
	}
}

func TestComputeTotalBasic(t *testing.T) {
	subtotal := m("100.00")
	discount := m("10.00")
	deliveryFee := m("15.00")
	bonus := m("5.00")
	total, actualBonus := computeTotal(subtotal, discount, deliveryFee, bonus)
	// 100 - 10 + 15 - 5 = 100.00
	if total.String() != "100.00" {
		t.Errorf("total = %s, want 100.00", total)
	}
	if actualBonus.String() != "5.00" {
		t.Errorf("actualBonus = %s, want 5.00", actualBonus)
	}
}

func TestComputeTotalNeverNegativeAndClampsBonus(t *testing.T) {
	subtotal := m("20.00")
	discount := m("0.00")
	deliveryFee := m("0.00")
	// Requesting more bonus than is owed must not produce a negative total,
	// and the ledger must not record redeeming more than was actually used.
	bonus := m("100.00")
	total, actualBonus := computeTotal(subtotal, discount, deliveryFee, bonus)
	if total.String() != "0.00" {
		t.Errorf("total = %s, want 0.00", total)
	}
	if actualBonus.String() != "20.00" {
		t.Errorf("actualBonus = %s, want 20.00 (capped to what was owed)", actualBonus)
	}
}

func TestComputeTotalDiscountExceedingSubtotalClampsToZero(t *testing.T) {
	subtotal := m("10.00")
	discount := m("50.00") // should never happen (computeDiscountAmount caps this), but must be safe anyway
	deliveryFee := m("5.00")
	bonus := m("0.00")
	total, _ := computeTotal(subtotal, discount, deliveryFee, bonus)
	// after-discount clamps to 0, so total = 0 + deliveryFee = 5.00
	if total.String() != "5.00" {
		t.Errorf("total = %s, want 5.00", total)
	}
}

func TestEvaluateLineOutOfStock(t *testing.T) {
	cases := []struct {
		name      string
		requested int
		inv       models.Inventory
		want      bool
	}{
		{"enough stock", 2, models.Inventory{IsAvailable: true, StockQty: 5}, true},
		{"exact stock", 5, models.Inventory{IsAvailable: true, StockQty: 5}, true},
		{"insufficient stock", 6, models.Inventory{IsAvailable: true, StockQty: 5}, false},
		{"zero stock", 1, models.Inventory{IsAvailable: true, StockQty: 0}, false},
		{"marked unavailable despite stock", 1, models.Inventory{IsAvailable: false, StockQty: 10}, false},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			if got := evaluateLine(c.requested, c.inv); got != c.want {
				t.Errorf("evaluateLine(%d, %+v) = %v, want %v", c.requested, c.inv, got, c.want)
			}
		})
	}
}

// promoCodeRow builds the fakeRow that repository.PromoCodeRepository's
// GetActiveByCode/ListActivePublic scan into, in their exact column order
// (see scanPromoCodeRow), so validatePromo's edge cases can be driven
// end-to-end without a live Postgres.
func promoCodeRow(discountType, discountValue, minOrder string, startsAt, endsAt *time.Time, usageLimit *int, perUserLimit int) fakeRow {
	return fakeRow{values: []any{
		uuid.New(), "TESTCODE", discountType, discountValue, minOrder, (*string)(nil),
		startsAt, endsAt, usageLimit, perUserLimit,
		[]uuid.UUID(nil), []uuid.UUID(nil), []uuid.UUID(nil), true,
	}}
}

func TestValidatePromoInvalidCode(t *testing.T) {
	svc := &CheckoutService{promos: repository.NewPromoCodeRepository()}
	q := &fakeQuerier{rows: []fakeRow{{err: pgx.ErrNoRows}}}

	_, _, err := svc.validatePromo(context.Background(), q, "NOPE", uuid.New(), uuid.New(), m("100.00"), nil)

	assertPromoErr(t, err, apperr.CodePromoInvalid)
}

func TestValidatePromoExpired(t *testing.T) {
	svc := &CheckoutService{promos: repository.NewPromoCodeRepository()}
	past := time.Now().Add(-24 * time.Hour)
	q := &fakeQuerier{rows: []fakeRow{promoCodeRow(models.DiscountTypeFixed, "10.00", "0.00", nil, &past, nil, 0)}}

	_, _, err := svc.validatePromo(context.Background(), q, "TESTCODE", uuid.New(), uuid.New(), m("100.00"), nil)

	assertPromoErr(t, err, apperr.CodePromoExpired)
}

func TestValidatePromoMinOrderNotMet(t *testing.T) {
	svc := &CheckoutService{promos: repository.NewPromoCodeRepository()}
	q := &fakeQuerier{rows: []fakeRow{promoCodeRow(models.DiscountTypeFixed, "10.00", "500.00", nil, nil, nil, 0)}}

	// Subtotal (100.00) is below the promo's 500.00 minimum order amount.
	_, _, err := svc.validatePromo(context.Background(), q, "TESTCODE", uuid.New(), uuid.New(), m("100.00"), nil)

	assertPromoErr(t, err, apperr.CodePromoMinOrder)
}

func TestValidatePromoUsageLimitReached(t *testing.T) {
	svc := &CheckoutService{promos: repository.NewPromoCodeRepository()}
	limit := 5
	q := &fakeQuerier{rows: []fakeRow{
		promoCodeRow(models.DiscountTypeFixed, "10.00", "0.00", nil, nil, &limit, 0),
		{values: []any{5}}, // CountUsageTotal: already at the global limit
	}}

	_, _, err := svc.validatePromo(context.Background(), q, "TESTCODE", uuid.New(), uuid.New(), m("100.00"), nil)

	assertPromoErr(t, err, apperr.CodePromoLimitReached)
}

func TestValidatePromoPerUserLimitReached(t *testing.T) {
	svc := &CheckoutService{promos: repository.NewPromoCodeRepository()}
	q := &fakeQuerier{rows: []fakeRow{
		promoCodeRow(models.DiscountTypeFixed, "10.00", "0.00", nil, nil, nil, 1),
		{values: []any{1}}, // CountUsageByUser: this user already redeemed it once
	}}

	_, _, err := svc.validatePromo(context.Background(), q, "TESTCODE", uuid.New(), uuid.New(), m("100.00"), nil)

	assertPromoErr(t, err, apperr.CodePromoLimitReached)
}

func TestValidatePromoValidComputesDiscount(t *testing.T) {
	svc := &CheckoutService{promos: repository.NewPromoCodeRepository()}
	q := &fakeQuerier{rows: []fakeRow{
		promoCodeRow(models.DiscountTypePercentage, "10.00", "0.00", nil, nil, nil, 0),
	}}

	discount, promoID, err := svc.validatePromo(context.Background(), q, "TESTCODE", uuid.New(), uuid.New(), m("200.00"), nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if promoID == nil {
		t.Fatal("expected a non-nil promo id")
	}
	if discount.String() != "20.00" {
		t.Errorf("discount = %s, want 20.00 (10%% of 200.00)", discount)
	}
}

func assertPromoErr(t *testing.T, err error, want apperr.Code) {
	t.Helper()
	ae, ok := apperr.As(err)
	if !ok {
		t.Fatalf("expected an *apperr.Error, got %v (%T)", err, err)
	}
	if ae.Code != want {
		t.Errorf("code = %s, want %s", ae.Code, want)
	}
}

func TestContainsUUIDHelper(t *testing.T) {
	a := uuid.New()
	b := uuid.New()
	if containsUUID(nil, a) {
		t.Error("empty list should never contain anything")
	}
	if !containsUUID([]uuid.UUID{a, b}, b) {
		t.Error("expected list to contain b")
	}
	if containsUUID([]uuid.UUID{a}, b) {
		t.Error("did not expect list to contain b")
	}
}
