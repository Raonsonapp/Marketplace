package httpapi

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/service"
)

// AuthHandler implements POST /auth/*.
type AuthHandler struct {
	svc *service.AuthService
}

// NewAuthHandler builds an AuthHandler.
func NewAuthHandler(svc *service.AuthService) *AuthHandler { return &AuthHandler{svc: svc} }

func deviceInfo(c *gin.Context) auth.DeviceInfo {
	return auth.DeviceInfo{
		DeviceID:   c.GetHeader("X-Device-Id"),
		DeviceName: c.GetHeader("X-Device-Name"),
		IP:         c.ClientIP(),
		UserAgent:  c.GetHeader("User-Agent"),
	}
}

// SendOTP handles POST /auth/send-otp.
func (h *AuthHandler) SendOTP(c *gin.Context) {
	var req dto.SendOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if !dto.ValidEmail(req.Email) {
		handleErr(c, apperr.New(apperr.CodeEmailInvalid, map[string]any{"field": "email"}))
		return
	}
	retryAfter, err := h.svc.SendOTP(c.Request.Context(), req.Email, c.ClientIP())
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.SendOTPResponse{RetryAfterSeconds: retryAfter})
}

// VerifyOTP handles POST /auth/verify-otp.
func (h *AuthHandler) VerifyOTP(c *gin.Context) {
	var req dto.VerifyOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if !dto.ValidEmail(req.Email) {
		handleErr(c, apperr.New(apperr.CodeEmailInvalid, map[string]any{"field": "email"}))
		return
	}
	if !dto.ValidOTPCode(req.Code) {
		handleErr(c, apperr.New(apperr.CodeOTPInvalid, nil))
		return
	}
	res, err := h.svc.VerifyOTP(c.Request.Context(), req.Email, req.Code, deviceInfo(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.AuthResponse{
		AccessToken: res.AccessToken, RefreshToken: res.RefreshToken,
		User: dto.NewUserResponse(*res.User), IsNewUser: res.IsNewUser,
	})
}

// FirebaseVerify handles POST /auth/firebase-verify — the real-SMS
// registration/login path (Firebase Phone Auth). See docs/FIREBASE_SETUP.md.
func (h *AuthHandler) FirebaseVerify(c *gin.Context) {
	var req dto.FirebaseVerifyRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	res, err := h.svc.FirebaseVerify(c.Request.Context(), req.IDToken, req.FullName, deviceInfo(c))
	if err != nil {
		handleErr(c, err)
		return
	}
	ok(c, dto.AuthResponse{
		AccessToken: res.AccessToken, RefreshToken: res.RefreshToken,
		User: dto.NewUserResponse(*res.User), IsNewUser: res.IsNewUser,
	})
}

// Refresh handles POST /auth/refresh.
func (h *AuthHandler) Refresh(c *gin.Context) {
	var req dto.RefreshRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	res, err := h.svc.Refresh(c.Request.Context(), req.RefreshToken, deviceInfo(c))
	if err != nil {
		handleErr(c, mapSessionErr(err))
		return
	}
	ok(c, dto.RefreshResponse{AccessToken: res.AccessToken, RefreshToken: res.RefreshToken})
}

// Logout handles POST /auth/logout.
func (h *AuthHandler) Logout(c *gin.Context) {
	var req dto.LogoutRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		handleErr(c, apperr.New(apperr.CodeValidation, nil))
		return
	}
	if err := h.svc.Logout(c.Request.Context(), req.RefreshToken); err != nil {
		handleErr(c, err)
		return
	}
	c.Status(http.StatusNoContent)
}

func mapSessionErr(err error) error {
	switch err {
	case auth.ErrSessionNotFound, auth.ErrSessionRevoked:
		return apperr.New(apperr.CodeSessionRevoked, nil)
	case auth.ErrSessionExpired:
		return apperr.New(apperr.CodeSessionExpired, nil)
	default:
		return err
	}
}
