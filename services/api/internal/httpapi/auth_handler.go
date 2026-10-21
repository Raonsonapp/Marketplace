package httpapi

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/pkg/apperr"
	"tajikshop/api/internal/service"
)

type AuthHandler struct { svc *service.AuthService }

func NewAuthHandler(svc *service.AuthService) *AuthHandler { return &AuthHandler{svc: svc} }

func deviceInfo(c *gin.Context) auth.DeviceInfo {
	return auth.DeviceInfo{
		DeviceID: c.GetHeader("X-Device-Id"),
		DeviceName: c.GetHeader("X-Device-Name"),
		IP: c.ClientIP(),
		UserAgent: c.GetHeader("User-Agent"),
	}
}

func (h *AuthHandler) SendOTP(c *gin.Context) {
	var req dto.SendOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil { handleErr(c, apperr.New(apperr.CodeValidation, nil)); return }
	if !dto.ValidEmail(req.Email) { handleErr(c, apperr.New(apperr.CodeEmailInvalid, map[string]any{"field":"email"})); return }
	retryAfter, err := h.svc.SendOTP(c.Request.Context(), req.Email, c.ClientIP())
	if err != nil { handleErr(c, err); return }
	ok(c, dto.SendOTPResponse{RetryAfterSeconds: retryAfter})
}

func (h *AuthHandler) VerifyOTP(c *gin.Context) {
	var req dto.VerifyOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil { handleErr(c, apperr.New(apperr.CodeValidation, nil)); return }
	if !dto.ValidEmail(req.Email) { handleErr(c, apperr.New(apperr.CodeEmailInvalid, map[string]any{"field":"email"})); return }
	if !dto.ValidOTPCode(req.Code) { handleErr(c, apperr.New(apperr.CodeOTPInvalid, nil)); return }
	res, err := h.svc.VerifyOTP(c.Request.Context(), req.Email, req.Code, deviceInfo(c))
	if err != nil { handleErr(c, err); return }
	ok(c, dto.AuthResponse{AccessToken: res.AccessToken, RefreshToken: res.RefreshToken, User: dto.NewUserResponse(*res.User), IsNewUser: res.IsNewUser})
}

func (h *AuthHandler) GoogleVerify(c *gin.Context) {
	var req dto.GoogleAuthRequest
	if err := c.ShouldBindJSON(&req); err != nil { handleErr(c, apperr.New(apperr.CodeValidation, nil)); return }
	res, err := h.svc.GoogleVerify(c.Request.Context(), req.IDToken, deviceInfo(c))
	if err != nil {
		handleErr(c, apperr.New(apperr.CodeUnauthorized, map[string]any{"reason":"google_sign_in_failed"}))
		return
	}
	ok(c, dto.AuthResponse{AccessToken: res.AccessToken, RefreshToken: res.RefreshToken, User: dto.NewUserResponse(*res.User), IsNewUser: res.IsNewUser})
}

// FirebaseVerify remains implemented for backwards compatibility, but the mobile
// registration UI no longer calls it when Google Sign-In is the selected flow.
func (h *AuthHandler) FirebaseVerify(c *gin.Context) {
	var req dto.FirebaseVerifyRequest
	if err := c.ShouldBindJSON(&req); err != nil { handleErr(c, apperr.New(apperr.CodeValidation, nil)); return }
	res, err := h.svc.FirebaseVerify(c.Request.Context(), req.IDToken, req.FullName, deviceInfo(c))
	if err != nil { handleErr(c, err); return }
	ok(c, dto.AuthResponse{AccessToken: res.AccessToken, RefreshToken: res.RefreshToken, User: dto.NewUserResponse(*res.User), IsNewUser: res.IsNewUser})
}

func (h *AuthHandler) Refresh(c *gin.Context) {
	var req dto.RefreshRequest
	if err := c.ShouldBindJSON(&req); err != nil { handleErr(c, apperr.New(apperr.CodeValidation, nil)); return }
	res, err := h.svc.Refresh(c.Request.Context(), req.RefreshToken, deviceInfo(c))
	if err != nil { handleErr(c, mapSessionErr(err)); return }
	ok(c, dto.RefreshResponse{AccessToken: res.AccessToken, RefreshToken: res.RefreshToken})
}

func (h *AuthHandler) Logout(c *gin.Context) {
	var req dto.LogoutRequest
	if err := c.ShouldBindJSON(&req); err != nil { handleErr(c, apperr.New(apperr.CodeValidation, nil)); return }
	if err := h.svc.Logout(c.Request.Context(), req.RefreshToken); err != nil { handleErr(c, err); return }
	c.Status(http.StatusNoContent)
}

func mapSessionErr(err error) error {
	switch err {
	case auth.ErrSessionNotFound, auth.ErrSessionRevoked: return apperr.New(apperr.CodeSessionRevoked, nil)
	case auth.ErrSessionExpired: return apperr.New(apperr.CodeSessionExpired, nil)
	default: return err
	}
}
