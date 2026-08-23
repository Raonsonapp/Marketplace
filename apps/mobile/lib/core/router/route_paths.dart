/// Centralized route path constants so no screen hardcodes a route string.
class RoutePaths {
  RoutePaths._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/login/otp';

  static const home = '/home';
  static const catalog = '/catalog';
  static const cart = '/cart';
  static const orders = '/orders';
  static const profile = '/profile';

  static const categoryProducts = '/catalog/category/:categoryId';
  static const search = '/search';
  static const barcodeScanner = '/barcode';
  static const productDetail = '/product/:productId';
  static const favorites = '/favorites';
  static const checkout = '/checkout';
  static const orderDetail = '/orders/:orderId';
  static const profileEdit = '/profile/edit';
  static const profileSettings = '/profile/settings';
  static const languageSelection = '/profile/language';
  static const addresses = '/profile/addresses';

  static String categoryProductsPath(String categoryId) => '/catalog/category/$categoryId';
  static String productDetailPath(String productId) => '/product/$productId';
  static String orderDetailPath(String orderId) => '/orders/$orderId';
}

/// Passed via `GoRouter`'s `extra` to the OTP screen — carries the Firebase
/// `verificationId` (docs/FIREBASE_SETUP.md) alongside the phone number
/// when the phone-entry screen went through Firebase Phone Auth rather
/// than the console-OTP fallback.
class OtpRouteArgs {
  const OtpRouteArgs({required this.phone, this.firebaseVerificationId});

  final String phone;
  final String? firebaseVerificationId;
}
