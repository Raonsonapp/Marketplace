import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/email_entry_screen.dart';
import '../../features/barcode/presentation/barcode_scanner_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/category_products_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/loyalty/presentation/loyalty_screen.dart';
import '../../features/notifications/presentation/notification_preferences_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/product/presentation/product_detail_screen.dart';
import '../../features/cargo/presentation/cargo_screen.dart';
import '../../features/profile/presentation/addresses_screen.dart';
import '../../features/profile/presentation/legal_screen.dart';
import '../../features/profile/presentation/language_selection_screen.dart';
import '../../features/profile/presentation/profile_edit_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/promotions/presentation/promotions_screen.dart';
import '../../features/reviews/presentation/write_review_screen.dart';
import '../../features/seller/presentation/become_seller_screen.dart';
import '../../features/seller/presentation/seller_documents_screen.dart';
import '../../features/seller/presentation/seller_face_liveness_screen.dart';
import '../../features/seller/presentation/seller_store_info_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/stores/presentation/stores_map_screen.dart';
import '../../features/support/presentation/support_chat_screen.dart';
import '../../features/support/presentation/support_conversations_screen.dart';
import '../session/session_controller.dart';
import '../storage/preferences_storage.dart';
import 'app_shell.dart';
import 'route_paths.dart';
import 'router_refresh_notifier.dart';

/// Routes that require an authenticated session. Anonymous users can browse
/// home/catalog/search/product freely, per docs/API_SPEC.md.
bool _requiresAuth(String location) {
  return location.startsWith(RoutePaths.cart) ||
      location.startsWith(RoutePaths.orders) ||
      location.startsWith(RoutePaths.profile) ||
      location.startsWith(RoutePaths.favorites) ||
      location.startsWith(RoutePaths.checkout) ||
      location.startsWith(RoutePaths.loyalty) ||
      location.startsWith(RoutePaths.promotions) ||
      location.startsWith(RoutePaths.notifications) ||
      location.startsWith(RoutePaths.support) ||
      location.startsWith(RoutePaths.writeReview);
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = RouterRefreshNotifier(ref, sessionControllerProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final sessionAsync = ref.read(sessionControllerProvider);

      if (sessionAsync.isLoading && location != RoutePaths.splash) {
        return RoutePaths.splash;
      }
      if (sessionAsync.isLoading) return null;

      final hasSeenOnboarding = ref.read(preferencesStorageProvider).hasSeenOnboarding();
      final isAuthenticated = sessionAsync.valueOrNull?.isAuthenticated ?? false;
      final isAuthRoute = location == RoutePaths.login || location == RoutePaths.otp;

      if (location == RoutePaths.splash) {
        // Home works anonymously (docs/API_SPEC.md), so splash always lands
        // there once onboarding has been seen — no forced login gate.
        if (!hasSeenOnboarding) return RoutePaths.onboarding;
        return RoutePaths.home;
      }

      if (!hasSeenOnboarding && location != RoutePaths.onboarding) {
        return RoutePaths.onboarding;
      }

      if (_requiresAuth(location) && !isAuthenticated) {
        return RoutePaths.login;
      }

      if (isAuthRoute && isAuthenticated) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const EmailEntryScreen(),
      ),
      GoRoute(
        path: RoutePaths.otp,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is OtpRouteArgs) {
            return OtpVerificationScreen(email: extra.email);
          }
          // Fallback for a deep link / restored route with no `extra`
          // (e.g. `?email=...` only).
          final email = state.uri.queryParameters['email'] ?? '';
          return OtpVerificationScreen(email: email);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.home, builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.catalog, builder: (context, state) => const CatalogScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.cart, builder: (context, state) => const CartScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.orders, builder: (context, state) => const OrdersScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.profile, builder: (context, state) => const ProfileScreen()),
          ]),
        ],
      ),
      GoRoute(
        path: RoutePaths.categoryProducts,
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          final categoryName = state.uri.queryParameters['name'];
          return CategoryProductsScreen(categoryId: categoryId, categoryName: categoryName);
        },
      ),
      GoRoute(
        path: RoutePaths.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: RoutePaths.barcodeScanner,
        builder: (context, state) => const BarcodeScannerScreen(),
      ),
      GoRoute(
        path: RoutePaths.storesMap,
        builder: (context, state) => const StoresMapScreen(),
      ),
      GoRoute(
        path: RoutePaths.productDetail,
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: RoutePaths.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: RoutePaths.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RoutePaths.orderDetail,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return OrderDetailScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: RoutePaths.profileEdit,
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: RoutePaths.addresses,
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: RoutePaths.cargo,
        builder: (context, state) => const CargoScreen(),
      ),
      GoRoute(
        path: RoutePaths.legal,
        builder: (context, state) => const LegalScreen(),
      ),
      GoRoute(
        path: RoutePaths.languageSelection,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.profileSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.becomeSeller,
        builder: (context, state) => const BecomeSellerScreen(),
      ),
      GoRoute(
        path: RoutePaths.becomeSellerStoreInfo,
        builder: (context, state) => const SellerStoreInfoScreen(),
      ),
      GoRoute(
        path: RoutePaths.becomeSellerDocuments,
        builder: (context, state) => const SellerDocumentsScreen(),
      ),
      GoRoute(
        path: RoutePaths.becomeSellerFace,
        builder: (context, state) => const SellerFaceLivenessScreen(),
      ),
      GoRoute(
        path: RoutePaths.loyalty,
        builder: (context, state) => const LoyaltyScreen(),
      ),
      GoRoute(
        path: RoutePaths.promotions,
        builder: (context, state) => const PromotionsScreen(),
      ),
      GoRoute(
        path: RoutePaths.notificationPreferences,
        builder: (context, state) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RoutePaths.support,
        builder: (context, state) => const SupportConversationsScreen(),
      ),
      GoRoute(
        path: RoutePaths.supportChat,
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          return SupportChatScreen(conversationId: conversationId);
        },
      ),
      GoRoute(
        path: RoutePaths.writeReview,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is WriteReviewRouteArgs) {
            return WriteReviewScreen(args: extra);
          }
          // No valid args (e.g. a bare deep link) — there is no safe,
          // real `order_item_id` to fall back to, so send the user back
          // rather than show a form that could submit an invented one.
          return const _MissingReviewArgsRedirect();
        },
      ),
    ],
  );
});

/// Guards against `RoutePaths.writeReview` ever being reached without the
/// real [WriteReviewRouteArgs] a purchased order item supplies — this
/// screen must never let a review be submitted against a guessed id.
class _MissingReviewArgsRedirect extends StatelessWidget {
  const _MissingReviewArgsRedirect();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    });
    return const Scaffold(body: SizedBox.shrink());
  }
}
