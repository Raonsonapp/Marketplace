package httpapi

import (
	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/service"
)

// UploadHandler implements POST /uploads/presign.
type UploadHandler struct {
	svc *service.UploadService
}

// NewUploadHandler builds an UploadHandler.
func NewUploadHandler(svc *service.UploadService) *UploadHandler {
	return &UploadHandler{svc: svc}
}

// Presign handles POST /uploads/presign — issues a short-lived presigned
// PUT URL for an image the client uploads directly to object storage (used
// by review images and support-chat attachments; see internal/storage).
func (h *UploadHandler) Presign(c *gin.Context) {
	var req dto.PresignUploadRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	upload, err := h.svc.PresignUpload(c.Request.Context(), req.Purpose, req.ContentType)
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.PresignUploadResponse{
		UploadURL: upload.UploadURL,
		PublicURL: upload.PublicURL,
		ObjectKey: upload.ObjectKey,
		ExpiresIn: int(upload.ExpiresIn.Seconds()),
	})
}
