// Command server is the TajikShop API entrypoint: it loads config, connects
// to Postgres/Redis, runs migrations, wires every repository/service/
// handler, and serves the Gin router with graceful shutdown.
package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/config"
	"tajikshop/api/internal/db"
	"tajikshop/api/internal/httpapi"
	"tajikshop/api/internal/httpserver"
	"tajikshop/api/internal/jobs"
	"tajikshop/api/internal/pkg/otp"
	"tajikshop/api/internal/repository"
	"tajikshop/api/internal/service"
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

	rdb, err := db.NewRedisClient(ctx, cfg.RedisURL)
	if err != nil {
		return err
	}
	defer rdb.Close()

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
	brandRepo := repository.NewBrandRepository()

	// ---- auth primitives ----
	tokenMgr := auth.NewTokenManager(cfg.JWTSecret, cfg.AccessTTL)
	limiter := auth.NewLimiter(rdb)
	otpSender := otp.NewConsoleSender()
	otpMgr := auth.NewOTPManager(
		repository.NewOTPStoreAdapter(otpRepo, pool), otpSender, limiter,
		cfg.OTPTTL, cfg.OTPResendCD, cfg.BcryptCost,
	)
	sessionMgr := auth.NewSessionManager(repository.NewSessionStoreAdapter(sessionRepo, pool), cfg.RefreshTTL)

	// ---- services ----
	authSvc := service.NewAuthService(pool, otpMgr, sessionMgr, tokenMgr, userRepo)
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
	profileSvc := service.NewProfileService(pool, userRepo)

	// ---- handlers ----
	hub := ws.NewHub()
	handlers := httpapi.Handlers{
		Auth:      httpapi.NewAuthHandler(authSvc),
		Catalog:   httpapi.NewCatalogHandler(catalogSvc, homeSvc),
		Cart:      httpapi.NewCartHandler(cartSvc),
		Checkout:  httpapi.NewCheckoutHandler(checkoutSvc),
		Order:     httpapi.NewOrderHandler(orderSvc, checkoutSvc),
		Favorites: httpapi.NewFavoritesHandler(favoritesSvc),
		Loyalty:   httpapi.NewLoyaltyHandler(loyaltySvc),
		Address:   httpapi.NewAddressHandler(addressSvc),
		Profile:   httpapi.NewProfileHandler(profileSvc),
		Health:    httpapi.NewHealthHandler(pool, rdb),
		OrderWS:   httpapi.NewOrderWSHandler(hub, orderSvc, tokenMgr),
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
