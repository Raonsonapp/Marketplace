package service

import (
	"context"

	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/storage"
)

// UploadService issues presigned object-storage upload URLs. It never
// touches file bytes itself — see internal/storage's doc comment.
type UploadService struct {
	storage *storage.Client // nil when R2/S3 is not configured
}

// NewUploadService builds an UploadService. client may be nil when the
// backend isn't configured with R2/S3 credentials — PresignUpload then
// returns CodeUploadsNotConfigured instead of panicking.
func NewUploadService(client *storage.Client) *UploadService {
	return &UploadService{storage: client}
}

// allowedPurposes bounds the object-key prefixes callers may request,
// keeping uploads scoped to known, auditable flows.
var allowedPurposes = map[string]bool{
	"review-images":       true,
	"support-attachments": true,
	// seller-kyc: passport/selfie documents for POST /seller-applications.
	// Callers must submit the ObjectKey (never the PublicURL) for this
	// purpose — see storage.Client.PresignGet's doc comment.
	"seller-kyc": true,
}

// PresignUpload validates purpose/contentType and returns a short-lived
// presigned PUT URL plus the public URL the object will be reachable at
// once uploaded.
func (s *UploadService) PresignUpload(ctx context.Context, purpose, contentType string) (*storage.PresignedUpload, error) {
	if s.storage == nil {
		return nil, apperr.New(apperr.CodeUploadsNotConfigured, nil)
	}
	if !allowedPurposes[purpose] {
		return nil, apperr.New(apperr.CodeValidation, map[string]any{"field": "purpose"})
	}
	if !storage.AllowedContentType(contentType) {
		return nil, apperr.New(apperr.CodeUploadContentType, nil)
	}

	upload, err := s.storage.PresignUpload(ctx, purpose, contentType)
	if err != nil {
		return nil, err
	}
	return upload, nil
}
