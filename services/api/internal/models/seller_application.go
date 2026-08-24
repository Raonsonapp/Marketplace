package models

import (
	"time"

	"github.com/google/uuid"
)

// SellerApplication statuses, matching seller_applications.status CHECK.
const (
	SellerApplicationPending  = "pending"
	SellerApplicationApproved = "approved"
	SellerApplicationRejected = "rejected"
)

// SellerApplication mirrors the seller_applications table: a "become a
// seller" request carrying store location/contact info and the KYC
// documents/liveness result captured by the mobile app's onboarding wizard
// (docs/API_SPEC.md `POST /seller-applications`).
type SellerApplication struct {
	ID                    uuid.UUID
	UserID                uuid.UUID
	BirthDate             time.Time
	StoreLat              *float64
	StoreLng              *float64
	StoreWebsite          *string
	StoreInstagram        *string
	StoreTelegram         *string
	StoreWhatsapp         *string
	PassportFrontKey      string
	PassportBackKey       string
	SelfieWithPassportKey string
	LiveSelfieKey         string
	LivenessPassed        bool
	FaceMatchScore        *float64
	Status                string
	RejectionReason       *string
	ReviewedAt            *time.Time
	CreatedAt             time.Time
	UpdatedAt             time.Time
}
