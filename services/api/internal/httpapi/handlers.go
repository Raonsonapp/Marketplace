package httpapi

// Handlers bundles every feature handler internal/httpserver's router needs.
type Handlers struct {
	Auth         *AuthHandler
	Catalog      *CatalogHandler
	Cart         *CartHandler
	Checkout     *CheckoutHandler
	Order        *OrderHandler
	Favorites    *FavoritesHandler
	Loyalty      *LoyaltyHandler
	Address      *AddressHandler
	Profile      *ProfileHandler
	Health       *HealthHandler
	OrderWS      *OrderWSHandler
	Promotion    *PromotionHandler
	Review       *ReviewHandler
	Notification *NotificationHandler
	Support      *SupportHandler
	SupportWS    *SupportWSHandler
	Upload       *UploadHandler
}
