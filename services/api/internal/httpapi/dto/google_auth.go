package dto

// GoogleAuthRequest is the body for POST /auth/google.
type GoogleAuthRequest struct {
	IDToken string `json:"id_token" binding:"required"`
}
