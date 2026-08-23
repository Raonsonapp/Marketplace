import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/phone_entry_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/category_products_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/product/presentation/product_detail_screen.dart';
import '../../features/profile/presentation/addresses_screen.dart';
import '../../features/profile/presentation/language_selection_screen.dart';
import '../../features/profile/presentation/profile_edit_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
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
      location.startsWith(RoutePaths.checkout);
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
        builder: (context, state) => const PhoneEntryScreen(),
      ),
      GoRoute(
        path: RoutePaths.otp,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationScreen(phone: phone);
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
        path: RoutePaths.languageSelection,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.profileSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
