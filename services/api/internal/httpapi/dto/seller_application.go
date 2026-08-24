package dto

import "tajikshop/api/internal/models"

// CreateSellerApplicationRequest is the body for POST /seller-applications.
// StoreLat/StoreLng OR at least one of the Store* contact links must be set
// (validated in service.SellerApplicationService, not here — see
// docs/API_SPEC.md). The *Key fields are object keys returned by
// POST /uploads/presign with purpose="seller-kyc" (never a public URL).
type CreateSellerApplicationRequest struct {
	BirthDate             string   `json:"birth_date" binding:"required"` // "YYYY-MM-DD"
	StoreLat              *float64 `json:"store_lat"`
	StoreLng              *float64 `json:"store_lng"`
	StoreWebsite          *string  `json:"store_website"`
	StoreInstagram        *string  `json:"store_instagram"`
	StoreTelegram         *string  `json:"store_telegram"`
	StoreWhatsapp         *string  `json:"store_whatsapp"`
	PassportFrontKey      string   `json:"passport_front_key" binding:"required"`
	PassportBackKey       string   `json:"passport_back_key" binding:"required"`
	SelfieWithPassportKey string   `json:"selfie_with_passport_key" binding:"required"`
	LiveSelfieKey         string   `json:"live_selfie_key" binding:"required"`
	// LivenessPassed/FaceMatchScore come from the mobile app's on-device
	// liveness challenge + face-similarity check (Google ML Kit face
	// detection/landmarks — free, on-device, no paid KYC API). The server
	// re-checks FaceMatchScore against its own threshold as a second gate,
	// but cannot independently re-run the comparison itself — see
	// docs/SMS_PROVIDERS.md-style caveat in SellerApplicationService's doc
	// comment on the honest limits of a fully free/on-device approach.
	LivenessPassed bool     `json:"liveness_passed"`
	FaceMatchScore *float64 `json:"face_match_score"`
}

// SellerApplicationResponse is returned by POST /seller-applications and
// GET /seller-applications/me.
type SellerApplicationResponse struct {
	ID              string   `json:"id"`
	Status          string   `json:"status"`
	BirthDate       string   `json:"birth_date"`
	StoreLat        *float64 `json:"store_lat"`
	StoreLng        *float64 `json:"store_lng"`
	StoreWebsite    *string  `json:"store_website"`
	StoreInstagram  *string  `json:"store_instagram"`
	StoreTelegram   *string  `json:"store_telegram"`
	StoreWhatsapp   *string  `json:"store_whatsapp"`
	LivenessPassed  bool     `json:"liveness_passed"`
	FaceMatchScore  *float64 `json:"face_match_score"`
	RejectionReason *string  `json:"rejection_reason"`
	CreatedAt       string   `json:"created_at"`
}

// NewSellerApplicationResponse builds the response DTO from a model.
func NewSellerApplicationResponse(a *models.SellerApplication) SellerApplicationResponse {
	return SellerApplicationResponse{
		ID:              a.ID.String(),
		Status:          a.Status,
		BirthDate:       a.BirthDate.Format("2006-01-02"),
		StoreLat:        a.StoreLat,
		StoreLng:        a.StoreLng,
		StoreWebsite:    a.StoreWebsite,
		StoreInstagram:  a.StoreInstagram,
		StoreTelegram:   a.StoreTelegram,
		StoreWhatsapp:   a.StoreWhatsapp,
		LivenessPassed:  a.LivenessPassed,
		FaceMatchScore:  a.FaceMatchScore,
		RejectionReason: a.RejectionReason,
		CreatedAt:       a.CreatedAt.Format("2006-01-02T15:04:05Z07:00"),
	}
}
