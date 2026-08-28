// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'YouShop';

  @override
  String get navHome => 'Home';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navCart => 'Cart';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Profile';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonEmptyTitle => 'Nothing here yet';

  @override
  String get commonEmptyMessage => 'No data is available right now.';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonDone => 'Done';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonClose => 'Close';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonOptional => '(optional)';

  @override
  String get offlineBannerMessage => 'No internet connection';

  @override
  String get networkErrorTimeout =>
      'Connection to the server was interrupted. Please check your internet connection.';

  @override
  String get networkErrorNoConnection =>
      'No internet available. Please check your connection and try again.';

  @override
  String get networkErrorCancelled => 'Request was cancelled.';

  @override
  String get networkErrorUnknown => 'Unknown network error. Please try again.';

  @override
  String get authWelcomeTitle => 'Welcome to YouShop';

  @override
  String get authWelcomeSubtitle => 'Enter your phone number to continue';

  @override
  String get authWelcomeSubtitleEmail => 'Enter your email to continue';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPhoneLabel => 'Phone number';

  @override
  String get authPhoneHint => '90 123 45 67';

  @override
  String get authPhoneInvalid =>
      'Invalid phone number. Example: +992 90 123 45 67';

  @override
  String get authSendCode => 'Send code';

  @override
  String get authOpenTelegramBot => 'Open Telegram bot';

  @override
  String get authOtpTitle => 'Enter the verification code';

  @override
  String authOtpSubtitle(String email) {
    return 'We sent the verification code to $email. Check your inbox — if it is not there, look in the Spam folder.';
  }

  @override
  String get authOtpInvalid => 'Invalid code. Please try again.';

  @override
  String get authOtpExpired => 'The code has expired. Request a new one.';

  @override
  String get authResendCode => 'Resend code';

  @override
  String authResendCodeIn(int seconds) {
    return 'Resend available in ${seconds}s';
  }

  @override
  String get authVerify => 'Verify';

  @override
  String get authChangeNumber => 'Change email';

  @override
  String get authLogout => 'Log out';

  @override
  String get authCompleteRegTitle => 'Enter your email';

  @override
  String get authCompleteRegSubtitle =>
      'Last step: add your email for notifications and account recovery';

  @override
  String get authEmailHint => 'example@gmail.com';

  @override
  String get authEmailInvalid => 'Invalid email address';

  @override
  String get authLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get authSignInRequiredTitle => 'Sign-in required';

  @override
  String get authSignInRequiredMessage => 'Please sign in to continue';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get onboardingTitle1 => 'Shop from home';

  @override
  String get onboardingBody1 =>
      'Order thousands of fresh and everyday products from nearby stores';

  @override
  String get onboardingTitle2 => 'Fast delivery';

  @override
  String get onboardingBody2 =>
      'Your order is delivered to you in the shortest possible time';

  @override
  String get onboardingTitle3 => 'Earn TajBonus';

  @override
  String get onboardingBody3 =>
      'Earn bonus points with every purchase and use them on future orders';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get homeGreeting => 'Hello!';

  @override
  String get homeSectionCategories => 'Categories';

  @override
  String get homeSectionPopular => 'Popular products';

  @override
  String get homeSectionDiscounted => 'On sale';

  @override
  String get homeSectionRecommended => 'Recommended for you';

  @override
  String get homeSectionRecentlyViewed => 'Recently viewed';

  @override
  String get homeSectionPersonalOffers => 'Your personal offers';

  @override
  String get homeSectionNearbyStores => 'Stores near you';

  @override
  String get homeSectionFeaturedBrands => 'Featured brands';

  @override
  String get homeSectionBuyAgain => 'Buy again';

  @override
  String get homeEmptyFeed =>
      'The home feed is empty right now. Please check back later.';

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get catalogEmptyCategories => 'No categories found';

  @override
  String get categoryProductsEmpty => 'There are no products in this category';

  @override
  String get searchHint => 'Search for products';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchClearRecent => 'Clear';

  @override
  String get searchSuggestions => 'Suggestions';

  @override
  String get searchNoResults => 'No results found for your search';

  @override
  String searchResultsCount(int count) {
    return '$count results found';
  }

  @override
  String get productAddToCart => 'Add to cart';

  @override
  String get productOutOfStock => 'Out of stock';

  @override
  String get productInStock => 'In stock';

  @override
  String get productQuantity => 'Quantity';

  @override
  String get productDescription => 'Description';

  @override
  String get productRelated => 'Related products';

  @override
  String get productAddedToCart => 'Added to cart';

  @override
  String get productFavoriteAdded => 'Added to favorites';

  @override
  String get productFavoriteRemoved => 'Removed from favorites';

  @override
  String productDiscountBadge(int percent) {
    return '-$percent%';
  }

  @override
  String get productUnavailableTitle => 'Product unavailable';

  @override
  String get productUnavailableMessage =>
      'Sorry, this product is currently unavailable.';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmptyTitle => 'Your favorites are empty';

  @override
  String get favoritesEmptyMessage =>
      'Save products you like by tapping the heart icon';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyMessage => 'Add products to get started';

  @override
  String get cartRemoveItem => 'Remove';

  @override
  String get cartSaveForLater => 'Save for later';

  @override
  String get cartMoveToCart => 'Move to cart';

  @override
  String get cartSavedForLaterTitle => 'Saved for later';

  @override
  String get cartPromoCodeLabel => 'Promo code';

  @override
  String get cartPromoCodeHint => 'Enter code';

  @override
  String get cartPromoCodeApply => 'Apply';

  @override
  String get cartPromoCodeApplied => 'Promo code applied';

  @override
  String get cartPromoCodeRemove => 'Remove';

  @override
  String get cartPromoCodeInvalid => 'Promo code is invalid or expired';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartDiscount => 'Discount';

  @override
  String get cartDeliveryFee => 'Delivery fee';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartServerCalculatedNote => 'Prices are calculated by the server';

  @override
  String get cartCheckoutButton => 'Checkout';

  @override
  String get cartClearConfirm => 'Clear the cart?';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutDeliveryMethod => 'Delivery method';

  @override
  String get checkoutDeliveryMethodDelivery => 'Delivery';

  @override
  String get checkoutDeliveryMethodPickup => 'Pickup';

  @override
  String get checkoutAddressTitle => 'Address';

  @override
  String get checkoutAddressSelect => 'Select an address';

  @override
  String get checkoutAddressAdd => 'Add a new address';

  @override
  String get checkoutAddressEmpty => 'You haven\'t added an address yet';

  @override
  String get checkoutTimeTitle => 'Delivery time';

  @override
  String get checkoutTimeAsap => 'As soon as possible';

  @override
  String get checkoutTimeScheduled => 'Choose a time';

  @override
  String get checkoutPaymentTitle => 'Payment method';

  @override
  String get checkoutPaymentCashOnDelivery => 'Cash on delivery';

  @override
  String get checkoutQuoteTitle => 'Order preview';

  @override
  String get checkoutPlaceOrder => 'Place order';

  @override
  String get checkoutOrderSuccessTitle => 'Order placed!';

  @override
  String checkoutOrderSuccessMessage(String orderNumber) {
    return 'Your order #$orderNumber has been placed and is being processed';
  }

  @override
  String get checkoutViewOrder => 'View order';

  @override
  String get checkoutBackToHome => 'Back to home';

  @override
  String get addressLabelHome => 'Home';

  @override
  String get addressLabelWork => 'Work';

  @override
  String get addressLabelOther => 'Other';

  @override
  String get addressCity => 'City';

  @override
  String get addressStreet => 'Street';

  @override
  String get addressHouse => 'House';

  @override
  String get addressApartment => 'Apartment';

  @override
  String get addressEntrance => 'Entrance';

  @override
  String get addressFloor => 'Floor';

  @override
  String get addressComment => 'Comment';

  @override
  String get addressSetDefault => 'Set as default';

  @override
  String get addressDefault => 'Default';

  @override
  String get addressDelete => 'Delete address';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get ordersTabActive => 'Active';

  @override
  String get ordersTabCompleted => 'Completed';

  @override
  String get ordersTabCancelled => 'Cancelled';

  @override
  String get ordersEmptyActive => 'You have no active orders';

  @override
  String get ordersEmptyCompleted => 'You have no completed orders';

  @override
  String get ordersEmptyCancelled => 'You have no cancelled orders';

  @override
  String orderNumber(String number) {
    return 'Order #$number';
  }

  @override
  String get orderDetailTitle => 'Order details';

  @override
  String get orderItemsTitle => 'Items';

  @override
  String get orderStatusHistory => 'Status history';

  @override
  String get orderCancel => 'Cancel order';

  @override
  String get orderCancelReasonHint => 'Enter a reason for cancelling';

  @override
  String get orderReorder => 'Reorder';

  @override
  String get orderReceipt => 'Receipt';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusPreparing => 'Preparing';

  @override
  String get orderStatusReady => 'Ready';

  @override
  String get orderStatusCourierAssigned => 'Courier assigned';

  @override
  String get orderStatusPickedUp => 'Picked up';

  @override
  String get orderStatusDelivering => 'On the way';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileFullName => 'Full name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone number';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAddresses => 'My addresses';

  @override
  String get profileMyOrders => 'My orders';

  @override
  String get profileFavorites => 'Favorites';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileGuestTitle => 'Guest';

  @override
  String get profileGuestMessage => 'Sign in to see your profile';

  @override
  String get languageSelectTitle => 'Choose language';

  @override
  String get languageTajik => 'Tajik';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';

  @override
  String get profileTheme => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'Follow system';

  @override
  String get splashTagline => 'Easy shopping, fast delivery';

  @override
  String get barcodeScanTitle => 'Barcode scanner';

  @override
  String get barcodeScanInstructions =>
      'Point the camera at a product\'s barcode';

  @override
  String get barcodeCameraPermissionTitle => 'Camera access needed';

  @override
  String get barcodeCameraPermissionMessage =>
      'To scan a product\'s barcode, please allow camera access';

  @override
  String get barcodeCameraPermissionGrant => 'Grant access';

  @override
  String get barcodeCameraPermissionOpenSettings => 'Open settings';

  @override
  String get barcodeNotFoundTitle => 'Product not found';

  @override
  String barcodeNotFoundMessage(String code) {
    return 'Sorry, no product was found with barcode $code';
  }

  @override
  String get barcodeScanAgain => 'Scan again';

  @override
  String get barcodeResultTitle => 'Scan result';

  @override
  String get barcodeToggleFlash => 'Flashlight';

  @override
  String get barcodeSwitchCamera => 'Switch camera';

  @override
  String get orderTrackingTitle => 'Order tracking';

  @override
  String get orderTrackingLive => 'Live';

  @override
  String get storesMapTitle => 'Nearby stores';

  @override
  String get storesMapPermissionTitle => 'Location access needed';

  @override
  String get storesMapPermissionMessage =>
      'To show stores near you on the map, please allow location access';

  @override
  String get storesMapPermissionGrant => 'Grant access';

  @override
  String get storesMapPermissionOpenSettings => 'Open settings';

  @override
  String get storesMapChooseManually => 'Choose an address instead';

  @override
  String get storesMapEmptyTitle => 'No stores found nearby';

  @override
  String storeDistanceAway(String km) {
    return '$km km away';
  }

  @override
  String get storeDeliveryAvailable => 'Delivery available';

  @override
  String get storePickupAvailable => 'Pickup available';

  @override
  String get storeSells => 'What this store carries';

  @override
  String get storeBrowseCatalog => 'Browse catalog';

  @override
  String get loyaltyTitle => 'TajBonus';

  @override
  String get loyaltyBalance => 'Balance';

  @override
  String loyaltyLifetimeEarned(String amount) {
    return 'Lifetime earned: $amount';
  }

  @override
  String get loyaltyTransactionsTitle => 'Transaction history';

  @override
  String get loyaltyEmptyTransactionsTitle => 'No transactions yet';

  @override
  String get loyaltyEmptyTransactionsMessage =>
      'Shop to earn TajBonus — your transactions will show up here';

  @override
  String get loyaltyTypeEarn => 'Earned';

  @override
  String get loyaltyTypeSpend => 'Spent';

  @override
  String get loyaltyTypeExpire => 'Expired';

  @override
  String get loyaltyTypeAdjust => 'Adjustment';

  @override
  String get loyaltyTypeCampaign => 'Campaign bonus';

  @override
  String get loyaltyTierStandard => 'Standard';

  @override
  String get loyaltyTierSilver => 'Silver';

  @override
  String get loyaltyTierGold => 'Gold';

  @override
  String get loyaltyTierPlatinum => 'Platinum';

  @override
  String get promotionsTitle => 'Offers';

  @override
  String get promotionsEmptyTitle => 'No offers yet';

  @override
  String get promotionsEmptyMessage =>
      'You have no active offers right now. Check back later.';

  @override
  String promotionsValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String promotionsCopyCode(String code) {
    return 'Copy code: $code';
  }

  @override
  String get promotionsCodeCopied => 'Code copied';

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String get reviewsEmptyTitle => 'No reviews yet';

  @override
  String get reviewsEmptyMessage => 'Be the first to review this product';

  @override
  String get reviewsAnonymousReviewer => 'Customer';

  @override
  String get reviewsHelpful => 'Helpful';

  @override
  String get reviewsLeaveReview => 'Leave a review';

  @override
  String get reviewsWriteTitle => 'Write a review';

  @override
  String reviewsForPurchase(String productName) {
    return 'Review for: $productName';
  }

  @override
  String get reviewsTextLabel => 'Your review';

  @override
  String get reviewsTextHint => 'Tell us about the product…';

  @override
  String get reviewsImageUrlLabel => 'Attach a photo';

  @override
  String get reviewsImageUrlHint => 'Photo link (URL)';

  @override
  String get reviewsSubmit => 'Submit review';

  @override
  String get reviewsSubmitSuccess => 'Thanks! Your review has been submitted';

  @override
  String get reviewsDuplicateError => 'You\'ve already reviewed this purchase';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptyMessage =>
      'Your notifications will show up here';

  @override
  String get notificationsPreferencesTitle => 'Notification settings';

  @override
  String get notificationsPrefOrders => 'Orders';

  @override
  String get notificationsPrefPromotions => 'Discounts & promotions';

  @override
  String get notificationsPrefPersonalOffers => 'Personal offers';

  @override
  String get notificationsPrefBonusUpdates => 'TajBonus updates';

  @override
  String get notificationsPrefNewProducts => 'New products';

  @override
  String get supportTitle => 'Support';

  @override
  String get supportNewConversation => 'New conversation';

  @override
  String get supportEmptyTitle => 'No conversations yet';

  @override
  String get supportEmptyMessage =>
      'If you have a question, get in touch with us';

  @override
  String get supportStatusOpen => 'Open';

  @override
  String get supportStatusClosed => 'Closed';

  @override
  String get supportChatTitle => 'Support chat';

  @override
  String get supportChatEmptyTitle => 'No messages';

  @override
  String get supportChatEmptyMessage => 'Send your first message';

  @override
  String get supportChatInputHint => 'Write a message…';

  @override
  String get sellerMenuTitle => 'Become a seller';

  @override
  String get sellerIntroBody =>
      'Sell on YouShop: add your store location or a link where customers can find you, verify your passport, and confirm it\'s really you with a quick face check — all free, right in the app.';

  @override
  String get sellerIntroStart => 'Get started';

  @override
  String get sellerStoreInfoTitle => 'Your store';

  @override
  String get sellerStoreInfoSubtitle =>
      'Add your store\'s GPS location, or — if you don\'t have a physical store — a website, Instagram, Telegram, or WhatsApp link.';

  @override
  String get sellerUseMyLocation => 'Use my current location';

  @override
  String get sellerLocationCaptured => 'Location saved';

  @override
  String get locationServiceDisabled =>
      'Location is turned off. Please enable GPS.';

  @override
  String get locationPermissionDenied => 'Location permission was denied.';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission is blocked. Enable it in Settings.';

  @override
  String get locationLookupFailed =>
      'Could not determine your location. Please try again.';

  @override
  String get sellerWebsiteLabel => 'Website';

  @override
  String get sellerInstagramLabel => 'Instagram';

  @override
  String get sellerTelegramLabel => 'Telegram';

  @override
  String get sellerWhatsappLabel => 'WhatsApp';

  @override
  String get sellerStoreInfoRequiredError =>
      'Add your store\'s location or at least one contact link';

  @override
  String get sellerDocumentsTitle => 'Documents';

  @override
  String get sellerBirthDateLabel => 'Date of birth';

  @override
  String get sellerBirthDateNotSet => 'Not set';

  @override
  String get sellerPassportFrontLabel => 'Passport — front page';

  @override
  String get sellerPassportBackLabel => 'Passport — back page';

  @override
  String get sellerSelfieWithPassportLabel => 'Selfie holding your passport';

  @override
  String get sellerCapturePhoto => 'Take photo';

  @override
  String get sellerRetakePhoto => 'Retake';

  @override
  String get sellerDocumentsIncompleteError =>
      'Please add all three photos and your date of birth';

  @override
  String get sellerFaceTitle => 'Face check';

  @override
  String get sellerFaceInstructionLookNormal =>
      'Look at the camera normally, then tap capture';

  @override
  String get sellerFaceInstructionBlink => 'Now blink, then tap capture again';

  @override
  String get sellerFaceCapture => 'Capture';

  @override
  String get sellerFaceProcessing => 'Checking…';

  @override
  String get sellerFaceFailed =>
      'We couldn\'t confirm it\'s you. Make sure your face is well-lit and fully visible, then try again.';

  @override
  String get sellerSubmitApplication => 'Submit application';

  @override
  String get sellerUnderageError =>
      'You must be at least 18 years old to become a seller';

  @override
  String get sellerApplicationExistsError =>
      'You\'ve already submitted a seller application';

  @override
  String get sellerStatusTitle => 'Seller application';

  @override
  String get sellerStatusPending =>
      'Your application is being reviewed. We\'ll notify you once it\'s approved.';

  @override
  String get sellerStatusApproved =>
      'Congratulations! You\'re now a seller on YouShop.';

  @override
  String get sellerStatusRejected => 'Your application was not approved.';
}
