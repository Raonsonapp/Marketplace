// Package httpserver wires the Gin engine: the global middleware chain and
// every route group from docs/API_SPEC.md, mapped to the handlers built in
// internal/httpapi. Kept separate from internal/httpapi per
// docs/ARCHITECTURE.md's monorepo layout ("httpserver/ router wiring,
// middleware chain" vs "httpapi/ HTTP handlers + DTOs").
package httpserver

import (
	"time"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/httpapi"
	"tajikshop/api/internal/middleware"
)

// NewRouter builds the full Gin engine: global middleware, then every route
// group from docs/API_SPEC.md with the correct auth/RBAC requirement.
func NewRouter(h httpapi.Handlers, tokenMgr *auth.TokenManager, limiter *auth.Limiter, corsOrigins []string) *gin.Engine {
	r := gin.New()
	r.Use(middleware.Recovery())
	r.Use(middleware.StructuredLogging())
	r.Use(middleware.CORS(corsOrigins))
	r.Use(middleware.SecureHeaders())
	r.Use(middleware.Language())

	r.GET("/healthz", h.Health.Check)
	if h.NetCheck != nil {
		r.GET("/debug/netcheck", h.NetCheck.Check)
	}
	if h.OrderWS != nil {
		r.GET("/ws/orders/:id", h.OrderWS.Serve)
	}
	if h.SupportWS != nil {
		r.GET("/ws/support/:conversationId", h.SupportWS.Serve)
	}

	requireAuth := middleware.RequireAuth(tokenMgr)
	optionalAuth := middleware.OptionalAuth(tokenMgr)
	generalLimit := middleware.RateLimit(limiter, 120, time.Minute)

	v1 := r.Group("/api/v1")
	v1.Use(generalLimit)
	{
		authGroup := v1.Group("/auth")
		{
			authGroup.POST("/send-otp", h.Auth.SendOTP)
			authGroup.POST("/verify-otp", h.Auth.VerifyOTP)
			authGroup.POST("/firebase-verify", h.Auth.FirebaseVerify)
			authGroup.POST("/refresh", h.Auth.Refresh)
			authGroup.POST("/logout", h.Auth.Logout)
		}

		v1.GET("/home", optionalAuth, h.Catalog.Home)
		v1.GET("/categories", h.Catalog.Categories)
		v1.GET("/categories/:id/products", optionalAuth, h.Catalog.CategoryProducts)
		v1.GET("/stores", h.Catalog.Stores)
		v1.GET("/stores/:id", h.Catalog.StoreDetail)
		v1.GET("/products", optionalAuth, h.Catalog.Products)
		v1.GET("/products/:id", optionalAuth, h.Catalog.ProductDetail)
		v1.GET("/products/barcode/:code", optionalAuth, h.Catalog.ProductByBarcode)
		v1.GET("/search", optionalAuth, h.Catalog.Search)

		v1.GET("/reviews", h.Review.List)
		v1.GET("/promotions", optionalAuth, h.Promotion.List)

		authed := v1.Group("")
		authed.Use(requireAuth)
		{
			authed.GET("/cart", h.Cart.Get)
			authed.POST("/cart/items", h.Cart.AddItem)
			authed.PATCH("/cart/items/:id", h.Cart.UpdateItem)
			authed.DELETE("/cart/items/:id", h.Cart.RemoveItem)
			authed.DELETE("/cart", h.Cart.Clear)

			authed.POST("/checkout/quote", h.Checkout.Quote)
			authed.POST("/orders", h.Checkout.CreateOrder)
			authed.GET("/orders", h.Order.List)
			authed.GET("/orders/:id", h.Order.Get)
			authed.POST("/orders/:id/cancel", h.Order.Cancel)

			authed.GET("/favorites", h.Favorites.List)
			authed.POST("/favorites/:productId", h.Favorites.Add)
			authed.DELETE("/favorites/:productId", h.Favorites.Remove)

			authed.GET("/loyalty", h.Loyalty.Summary)
			authed.GET("/loyalty/transactions", h.Loyalty.Transactions)

			authed.GET("/addresses", h.Address.List)
			authed.POST("/addresses", h.Address.Create)
			authed.PATCH("/addresses/:id", h.Address.Update)
			authed.DELETE("/addresses/:id", h.Address.Delete)

			authed.GET("/profile", h.Profile.Get)
			authed.PATCH("/profile", h.Profile.Update)

			authed.POST("/promo-codes/validate", h.Promotion.Validate)
			authed.POST("/reviews", h.Review.Create)

			authed.GET("/notifications", h.Notification.List)
			authed.PATCH("/notifications/:id/read", h.Notification.MarkRead)
			authed.GET("/notifications/preferences", h.Notification.GetPreferences)
			authed.PATCH("/notifications/preferences", h.Notification.UpdatePreferences)
			authed.POST("/devices", h.Notification.RegisterDevice)

			authed.POST("/uploads/presign", h.Upload.Presign)

			authed.POST("/seller-applications", h.SellerApp.Create)
			authed.GET("/seller-applications/me", h.SellerApp.GetMine)

			authed.GET("/support/conversations", h.Support.ListConversations)
			authed.POST("/support/conversations", h.Support.CreateConversation)
			authed.GET("/support/conversations/:id/messages", h.Support.ListMessages)
			authed.POST("/support/conversations/:id/messages", h.Support.PostMessage)
		}
	}

	return r
}
