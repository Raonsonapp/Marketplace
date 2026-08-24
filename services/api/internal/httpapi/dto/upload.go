package dto

// PresignUploadRequest is the body for POST /uploads/presign.
type PresignUploadRequest struct {
	ContentType string `json:"content_type" binding:"required"`
	// Purpose scopes the object key prefix (e.g. "review-images",
	// "support-attachments") so different upload flows land in
	// distinguishable, auditable locations in the bucket.
	Purpose string `json:"purpose" binding:"required"`
}

// PresignUploadResponse is returned by POST /uploads/presign.
type PresignUploadResponse struct {
	UploadURL string `json:"upload_url"`
	PublicURL string `json:"public_url"`
	// ObjectKey is the bucket key the client just got a PUT URL for.
	// Callers submitting a "seller-kyc" purpose upload must send this
	// (never PublicURL) back to POST /seller-applications — see
	// storage.Client.PresignGet's doc comment on why those documents are
	// never exposed at a permanent public URL.
	ObjectKey string `json:"object_key"`
	ExpiresIn int    `json:"expires_in_seconds"`
}
