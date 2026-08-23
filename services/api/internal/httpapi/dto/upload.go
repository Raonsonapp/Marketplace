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
	ExpiresIn int    `json:"expires_in_seconds"`
}
