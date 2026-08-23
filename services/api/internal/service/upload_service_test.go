package service

import (
	"context"
	"testing"

	"tajikshop/api/internal/pkg/apperr"
)

func TestUploadService_NotConfigured(t *testing.T) {
	svc := NewUploadService(nil)
	_, err := svc.PresignUpload(context.Background(), "review-images", "image/jpeg")
	appErr, ok := apperr.As(err)
	if !ok || appErr.Code != apperr.CodeUploadsNotConfigured {
		t.Fatalf("expected CodeUploadsNotConfigured, got %v", err)
	}
}
