// Package storage provides presigned-upload access to TajikShop's
// S3-compatible object store (Cloudflare R2 in production; any
// S3-compatible endpoint, e.g. MinIO, in local dev — see
// docs/DEPLOYMENT.md). The backend never proxies upload bytes itself: it
// hands the client a short-lived presigned PUT URL, the client uploads
// directly to the bucket, and only the resulting public URL is ever stored
// (e.g. as a review's image_url) — matching docs/SECURITY.md's rule that
// uploaded files are stored under a generated key, never the client-
// supplied filename.
package storage

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

// Client wraps a minio client configured for an S3-compatible bucket.
type Client struct {
	mc        *minio.Client
	bucket    string
	publicURL string // e.g. https://<accountid>.r2.dev or a custom domain
}

// Config holds the R2/S3-compatible connection settings, matching the
// R2_* environment variables in .env.example.
type Config struct {
	Endpoint  string // host[:port], no scheme, e.g. "xxxx.r2.cloudflarestorage.com"
	AccessKey string
	SecretKey string
	Bucket    string
	PublicURL string
	UseSSL    bool
}

// Configured reports whether enough settings are present to build a Client.
func (c Config) Configured() bool {
	return c.Endpoint != "" && c.AccessKey != "" && c.SecretKey != "" && c.Bucket != ""
}

// NewClient builds a storage Client from cfg. Callers must check
// cfg.Configured() first; this returns an error otherwise rather than a
// half-working client.
func NewClient(cfg Config) (*Client, error) {
	if !cfg.Configured() {
		return nil, fmt.Errorf("storage: R2/S3 is not configured")
	}
	mc, err := minio.New(cfg.Endpoint, &minio.Options{
		Creds:  credentials.NewStaticV4(cfg.AccessKey, cfg.SecretKey, ""),
		Secure: cfg.UseSSL,
	})
	if err != nil {
		return nil, fmt.Errorf("storage: build client: %w", err)
	}
	return &Client{mc: mc, bucket: cfg.Bucket, publicURL: cfg.PublicURL}, nil
}

// PresignedUpload is what callers hand back to the client.
type PresignedUpload struct {
	UploadURL string
	PublicURL string
	ObjectKey string
	ExpiresIn time.Duration
}

// allowedContentTypes bounds what PresignUpload will issue a URL for —
// image uploads only (review photos, support-chat attachments), per
// docs/API_SPEC.md.
var allowedContentTypes = map[string]string{
	"image/jpeg": "jpg",
	"image/png":  "png",
	"image/webp": "webp",
}

// AllowedContentType reports whether contentType is one PresignUpload will
// accept, letting handlers validate before calling it.
func AllowedContentType(contentType string) bool {
	_, ok := allowedContentTypes[contentType]
	return ok
}

// PresignUpload generates a short-lived presigned PUT URL for a new,
// randomly-named object under purpose/ (e.g. "review-images/",
// "support-attachments/"). The object key is always server-generated
// (uuid), never derived from client input.
func (c *Client) PresignUpload(ctx context.Context, purpose, contentType string) (*PresignedUpload, error) {
	ext, ok := allowedContentTypes[contentType]
	if !ok {
		return nil, fmt.Errorf("storage: unsupported content type %q", contentType)
	}

	objectKey := fmt.Sprintf("%s/%s.%s", purpose, uuid.NewString(), ext)
	const ttl = 10 * time.Minute

	u, err := c.mc.PresignedPutObject(ctx, c.bucket, objectKey, ttl)
	if err != nil {
		return nil, fmt.Errorf("storage: presign put: %w", err)
	}

	return &PresignedUpload{
		UploadURL: u.String(),
		PublicURL: c.publicURL + "/" + objectKey,
		ObjectKey: objectKey,
		ExpiresIn: ttl,
	}, nil
}
