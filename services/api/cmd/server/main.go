// Command server is the TajikShop API entrypoint: it loads config, connects
// to Postgres/Redis, runs migrations, wires every repository/service/
// handler, and serves the Gin router with graceful shutdown.
package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/config"
	"tajikshop/api/internal/db"
	"tajikshop/api/internal/httpapi"
	"tajikshop/api/internal/httpserver"
	"tajikshop/api/internal/jobs"
	"tajikshop/api/internal/pkg/otp"
	"tajikshop/api/internal/pkg/telegrambot"
	"tajikshop/api/internal/repository"
	"tajikshop/api/internal/service"
	"tajikshop/api/internal/storage"
	"tajikshop/api/internal/ws"
)

func main() {
	if err := run(); err != nil {
		log.Fatalf("fatal: %v", err)
	}
}

func run() error {
	cfg, err := config.Load()
	if err != nil {
		return err
	}

	if err := db.RunMigrations(cfg.DatabaseURL); err != nil {
		return err
	}
	log.Println("migrations: up to date")

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	pool, err := db.NewPostgresPool(ctx, cfg.DatabaseURL)
	if err != nil {
		return err
	}
	defer pool.Close()

	rdb, closeRedis, err := db.ConnectRedis(ctx, cfg.RedisURL)
	if err != nil {
		return err
	}
	defer closeRedis()

	// ---- repositories ----
	userRepo := repository.NewUserRepository()
	sessionRepo := repository.NewSessionRepository()
	otpRepo := repository.NewOTPRepository()
	addressRepo := repository.NewAddressRepository()
	storeRepo := repository.NewStoreRepository()
	categoryRepo := repository.NewCategoryRepository()
	productRepo := repository.NewProductRepository()
	inventoryRepo := repository.NewInventoryRepository()
	favoriteRepo := repository.NewFavoriteRepository()
	cartRepo := repository.NewCartRepository()
	orderRepo := repository.NewOrderRepository()
	promoRepo := repository.NewPromoCodeRepository()
	loyaltyRepo := repository.NewLoyaltyRepository()
	regionRepo := repository.NewRegionRepository()
	cargoRepo := repository.NewCargoRepository()
	brandRepo := repository.NewBrandRepository()
	discountRepo := repository.NewDiscountRepository()
	reviewRepo := repository.NewReviewRepository()
	notificationRepo := repository.NewNotificationRepository()
	supportRepo := repository.NewSupportRepository()
	sellerAppRepo := repository.NewSellerApplicationRepository()

	// ---- auth primitives ----
	tokenMgr := auth.NewTokenManager(cfg.JWTSecret, cfg.AccessTTL)
	limiter := auth.NewLimiter(rdb)

	// Login is email-based: the OTP code is mailed to the address the user
	// signs in with (docs/SMS_PROVIDERS.md). Delivery goes through the same
	// Google Apps Script relay as the owner alerts, because this host can
	// reach Google's network but not Telegram's — and cloud hosts generally
	// block outbound SMTP, so a direct mail send is not an option either.
	// With no relay configured, codes are logged to the console (local dev).
	var otpSender otp.Sender = otp.NewConsoleSender()
	if cfg.TelegramGatewayProxyURL != "" {
		otpSender = otp.NewEmailSender(cfg.TelegramGatewayProxyURL, cfg.TelegramGatewayProxySecret, "YouShop")
		log.Printf("otp: emailing codes via the Apps Script relay (%s)", cfg.TelegramGatewayProxyURL)
	} else {
		log.Printf("otp: no email relay configured (TELEGRAM_GATEWAY_PROXY_URL), logging OTP codes to console (dev mode)")
	}
	otpMgr := auth.NewOTPManager(
		repository.NewOTPStoreAdapter(otpRepo, pool), otpSender, limiter,
		cfg.OTPTTL, cfg.OTPResendCD, cfg.BcryptCost,
	)
	sessionMgr := auth.NewSessionManager(repository.NewSessionStoreAdapter(sessionRepo, pool), cfg.RefreshTTL)
	firebaseVerifier := auth.NewFirebaseVerifier(cfg.FirebaseWebAPIKey)

	// ---- services ----
	authSvc := service.NewAuthService(pool, otpMgr, sessionMgr, tokenMgr, userRepo, firebaseVerifier)
	catalogSvc := service.NewCatalogService(pool, categoryRepo, productRepo, storeRepo, inventoryRepo)
	homeSvc := service.NewHomeService(pool, categoryRepo, productRepo, storeRepo, brandRepo, orderRepo, catalogSvc)
	cartSvc := service.NewCartService(pool, cartRepo, productRepo, inventoryRepo, storeRepo)
	checkoutSvc := service.NewCheckoutService(
		pool, rdb, service.CheckoutConfig{LoyaltyEarnRatePercent: cfg.LoyaltyEarnRatePercent, LoyaltyMaxRedeemPercent: cfg.LoyaltyMaxRedeemPercent},
		cartRepo, productRepo, inventoryRepo, storeRepo, addressRepo, promoRepo, loyaltyRepo, orderRepo,
	)
	orderSvc := service.NewOrderService(pool, orderRepo)
	loyaltySvc := service.NewLoyaltyService(pool, loyaltyRepo)
	favoritesSvc := service.NewFavoritesService(pool, favoriteRepo, productRepo)
	addressSvc := service.NewAddressService(pool, addressRepo)
	regionSvc := service.NewRegionService(pool, regionRepo)
	cargoSvc := service.NewCargoService(pool, cargoRepo, notificationRepo)
	profileSvc := service.NewProfileService(pool, userRepo, sessionRepo)
	promotionSvc := service.NewPromotionService(pool, discountRepo, promoRepo)
	reviewSvc := service.NewReviewService(pool, reviewRepo)
	notificationSvc := service.NewNotificationService(pool, notificationRepo)

	// Owner-alert channel (new seller application, new support message):
	// the bot messages the owner's chat, routed through the OTP relay when
	// api.telegram.org is unreachable from this host. See
	// docs/TELEGRAM_RELAY_SETUP.md. Disabled (no-op) until
	// TELEGRAM_ADMIN_CHAT_ID is set.
	adminNotifier := telegrambot.NewAdminNotifier(
		cfg.TelegramBotToken, cfg.TelegramAdminChatID,
		cfg.TelegramGatewayProxyURL, cfg.TelegramGatewayProxySecret,
	)
	if adminNotifier.Enabled() {
		log.Printf("notify: owner alerts (seller apps, support) enabled for chat %d", cfg.TelegramAdminChatID)
	}
	supportSvc := service.NewSupportService(pool, supportRepo, userRepo, adminNotifier)

	// Object storage (Cloudflare R2 / any S3-compatible endpoint) is
	// optional: uploads/presign returns UPLOADS_NOT_CONFIGURED until these
	// env vars are set, rather than the server failing to start.
	var storageClient *storage.Client
	r2Endpoint := strings.TrimPrefix(strings.TrimPrefix(cfg.R2Endpoint, "https://"), "http://")
	if cfg.R2Endpoint != "" {
		storageClient, err = storage.NewClient(storage.Config{
			Endpoint:  r2Endpoint,
			AccessKey: cfg.R2AccessKey,
			SecretKey: cfg.R2SecretKey,
			Bucket:    cfg.R2Bucket,
			PublicURL: cfg.R2PublicURL,
			UseSSL:    true,
		})
		if err != nil {
			return fmt.Errorf("storage: %w", err)
		}
		log.Printf("storage: R2 object storage configured (bucket=%s)", cfg.R2Bucket)
	} else {
		log.Printf("storage: R2_ENDPOINT not set, uploads/presign will return UPLOADS_NOT_CONFIGURED")
	}
	uploadSvc := service.NewUploadService(storageClient)
	sellerAppSvc := service.NewSellerApplicationService(pool, sellerAppRepo, userRepo, storageClient, adminNotifier)

	// ---- handlers ----
	hub := ws.NewHub()
	handlers := httpapi.Handlers{
		Auth:         httpapi.NewAuthHandler(authSvc),
		Catalog:      httpapi.NewCatalogHandler(catalogSvc, homeSvc),
		Cart:         httpapi.NewCartHandler(cartSvc),
		Checkout:     httpapi.NewCheckoutHandler(checkoutSvc),
		Order:        httpapi.NewOrderHandler(orderSvc, checkoutSvc),
		Favorites:    httpapi.NewFavoritesHandler(favoritesSvc),
		Loyalty:      httpapi.NewLoyaltyHandler(loyaltySvc),
		Address:      httpapi.NewAddressHandler(addressSvc),
		Region:       httpapi.NewRegionHandler(regionSvc),
		Cargo:        httpapi.NewCargoHandler(cargoSvc),
		Legal:        httpapi.NewLegalHandler(),
		Profile:      httpapi.NewProfileHandler(profileSvc),
		Health:       httpapi.NewHealthHandler(pool, rdb),
		OrderWS:      httpapi.NewOrderWSHandler(hub, orderSvc, tokenMgr),
		Promotion:    httpapi.NewPromotionHandler(promotionSvc, checkoutSvc),
		Review:       httpapi.NewReviewHandler(reviewSvc),
		Notification: httpapi.NewNotificationHandler(notificationSvc),
		Support:      httpapi.NewSupportHandler(supportSvc, hub),
		SupportWS:    httpapi.NewSupportWSHandler(hub, supportSvc, tokenMgr),
		Upload:       httpapi.NewUploadHandler(uploadSvc),
		SellerApp:    httpapi.NewSellerApplicationHandler(sellerAppSvc),
	}

	router := httpserver.NewRouter(handlers, tokenMgr, limiter, cfg.CORSOrigins)

	cleanup := jobs.NewCleanupJob(pool, time.Hour)
	go cleanup.Run(ctx)

	srv := &http.Server{
		Addr:              ":" + cfg.Port,
		Handler:           router,
		ReadHeaderTimeout: 10 * time.Second,
	}

	go func() {
		log.Printf("tajikshop-api listening on :%s (env=%s)", cfg.Port, cfg.Env)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("server: %v", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	log.Println("shutting down...")

	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer shutdownCancel()
	cancel() // stop background jobs

	return srv.Shutdown(shutdownCtx)
}
