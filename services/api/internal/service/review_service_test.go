package service

import (
	"context"
	"reflect"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"

	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/repository"
)

// fakeRow is a minimal pgx.Row (Scan(dest ...any) error) that either copies
// canned column values into the caller's dest pointers, or replays a
// canned error (e.g. pgx.ErrNoRows, or a unique_violation).
type fakeRow struct {
	values []any
	err    error
}

func (r fakeRow) Scan(dest ...any) error {
	if r.err != nil {
		return r.err
	}
	if len(dest) != len(r.values) {
		panic("fakeRow: dest/values length mismatch")
	}
	for i, d := range dest {
		dv := reflect.ValueOf(d).Elem()
		vv := reflect.ValueOf(r.values[i])
		if !vv.Type().AssignableTo(dv.Type()) {
			panic("fakeRow: value not assignable to dest")
		}
		dv.Set(vv)
	}
	return nil
}

// fakeQuerier is a scripted repository.Querier: each QueryRow call consumes
// the next entry from rows, in order. It lets review_service_test.go drive
// ReviewService.Create's purchase-gating and duplicate-review branches
// without a live Postgres, by controlling exactly what
// repository.ReviewRepository's SQL calls appear to return.
type fakeQuerier struct {
	rows []fakeRow
	idx  int
}

func (q *fakeQuerier) QueryRow(_ context.Context, _ string, _ ...any) pgx.Row {
	if q.idx >= len(q.rows) {
		return fakeRow{err: pgx.ErrNoRows}
	}
	r := q.rows[q.idx]
	q.idx++
	return r
}

func (q *fakeQuerier) Exec(_ context.Context, _ string, _ ...any) (pgconn.CommandTag, error) {
	return pgconn.CommandTag{}, nil
}

func (q *fakeQuerier) Query(_ context.Context, _ string, _ ...any) (pgx.Rows, error) {
	panic("fakeQuerier: Query not used by the paths under test")
}

var _ repository.Querier = (*fakeQuerier)(nil)

func newReviewServiceWithRows(rows ...fakeRow) *ReviewService {
	return &ReviewService{db: &fakeQuerier{rows: rows}, reviews: repository.NewReviewRepository()}
}

func TestReviewCreateRejectsUnownedOrderItem(t *testing.T) {
	// FindOwnedOrderItem's join finds no matching row: the order_item_id
	// either isn't the caller's, or isn't for this product — either way,
	// docs/SECURITY.md requires rejecting the review outright.
	svc := newReviewServiceWithRows(fakeRow{err: pgx.ErrNoRows})

	_, err := svc.Create(context.Background(), uuid.New(), CreateReviewInput{
		ProductID: uuid.New(), OrderItemID: uuid.New(), Rating: 5,
	})

	ae, ok := apperr.As(err)
	if !ok {
		t.Fatalf("expected an *apperr.Error, got %v (%T)", err, err)
	}
	if ae.Code != apperr.CodeReviewRequiresPurchase {
		t.Errorf("code = %s, want %s", ae.Code, apperr.CodeReviewRequiresPurchase)
	}
}

func TestReviewCreateRejectsDuplicate(t *testing.T) {
	orderItemID := uuid.New()
	productID := uuid.New()

	// First QueryRow (FindOwnedOrderItem) succeeds; second (the INSERT)
	// fails with a unique_violation, mirroring the DB's
	// unique(user_id, product_id, order_item_id) constraint.
	svc := newReviewServiceWithRows(
		fakeRow{values: []any{orderItemID, productID}},
		fakeRow{err: &pgconn.PgError{Code: "23505"}},
	)

	_, err := svc.Create(context.Background(), uuid.New(), CreateReviewInput{
		ProductID: productID, OrderItemID: orderItemID, Rating: 4,
	})

	ae, ok := apperr.As(err)
	if !ok {
		t.Fatalf("expected an *apperr.Error, got %v (%T)", err, err)
	}
	if ae.Code != apperr.CodeDuplicateReview {
		t.Errorf("code = %s, want %s", ae.Code, apperr.CodeDuplicateReview)
	}
}

func TestReviewCreateSucceedsForOwnedPurchase(t *testing.T) {
	orderItemID := uuid.New()
	productID := uuid.New()
	now := time.Now()

	svc := newReviewServiceWithRows(
		fakeRow{values: []any{orderItemID, productID}},          // FindOwnedOrderItem
		fakeRow{values: []any{uuid.New(), "pending", now, now}}, // INSERT ... RETURNING id, status, created_at, updated_at
	)

	rev, err := svc.Create(context.Background(), uuid.New(), CreateReviewInput{
		ProductID: productID, OrderItemID: orderItemID, Rating: 5,
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if rev.Status != "pending" {
		t.Errorf("status = %s, want pending (new reviews are never auto-approved)", rev.Status)
	}
}
