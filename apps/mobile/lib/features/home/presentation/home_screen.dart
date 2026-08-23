import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/home_controller.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/categories_row.dart';
import 'widgets/featured_brands_row.dart';
import 'widgets/home_product_section.dart';
import 'widgets/nearby_stores_row.dart';

/// The home tab — renders the dynamic feed from `GET /home`
/// (docs/API_SPEC.md). Every section is optional; only present, non-empty
/// sections are rendered, in the order defined by ARCHITECTURE.md.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final feedAsync = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.scanLine),
            tooltip: l10n.barcodeScanTitle,
            onPressed: () => context.push(RoutePaths.barcodeScanner),
          ),
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () => context.push(RoutePaths.search),
          ),
        ],
      ),
      body: Column(
        children: [
          OfflineBanner(
            visible: feedAsync.hasError &&
                (feedAsync.error is NetworkException),
          ),
          Expanded(
            child: feedAsync.when(
              data: (feed) {
                if (feed.isEntirelyEmpty) {
                  return EmptyStateView(
                    title: l10n.commonEmptyTitle,
                    message: l10n.homeEmptyFeed,
                    actionLabel: l10n.commonRetry,
                    onAction: () => ref.read(homeControllerProvider.notifier).refresh(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    children: [
                      if (feed.banners != null && feed.banners!.isNotEmpty) ...[
                        BannerCarousel(banners: feed.banners!),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.categories != null && feed.categories!.isNotEmpty) ...[
                        CategoriesRow(
                          title: l10n.homeSectionCategories,
                          categories: feed.categories!,
                          onCategoryTap: (category) => context.push(
                            '${RoutePaths.categoryProductsPath(category.id)}?name=${Uri.encodeComponent(category.name)}',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.discounted != null && feed.discounted!.isNotEmpty) ...[
                        HomeProductSection(
                          title: l10n.homeSectionDiscounted,
                          products: feed.discounted!,
                          onProductTap: (p) => context.push(RoutePaths.productDetailPath(p.id)),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.popular != null && feed.popular!.isNotEmpty) ...[
                        HomeProductSection(
                          title: l10n.homeSectionPopular,
                          products: feed.popular!,
                          onProductTap: (p) => context.push(RoutePaths.productDetailPath(p.id)),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.personalOffers != null && feed.personalOffers!.isNotEmpty) ...[
                        HomeProductSection(
                          title: l10n.homeSectionPersonalOffers,
                          products: feed.personalOffers!,
                          onProductTap: (p) => context.push(RoutePaths.productDetailPath(p.id)),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.recommended != null && feed.recommended!.isNotEmpty) ...[
                        HomeProductSection(
                          title: l10n.homeSectionRecommended,
                          products: feed.recommended!,
                          onProductTap: (p) => context.push(RoutePaths.productDetailPath(p.id)),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.buyAgain != null && feed.buyAgain!.isNotEmpty) ...[
                        HomeProductSection(
                          title: l10n.homeSectionBuyAgain,
                          products: feed.buyAgain!,
                          onProductTap: (p) => context.push(RoutePaths.productDetailPath(p.id)),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.recentlyViewed != null && feed.recentlyViewed!.isNotEmpty) ...[
                        HomeProductSection(
                          title: l10n.homeSectionRecentlyViewed,
                          products: feed.recentlyViewed!,
                          onProductTap: (p) => context.push(RoutePaths.productDetailPath(p.id)),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.nearbyStores != null && feed.nearbyStores!.isNotEmpty) ...[
                        NearbyStoresRow(
                          title: l10n.homeSectionNearbyStores,
                          stores: feed.nearbyStores!,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (feed.featuredBrands != null && feed.featuredBrands!.isNotEmpty) ...[
                        FeaturedBrandsRow(
                          title: l10n.homeSectionFeaturedBrands,
                          brands: feed.featuredBrands!,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorStateView(
                error: error,
                onRetry: () => ref.read(homeControllerProvider.notifier).refresh(),
              ),
              loading: () => const SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                child: Column(
                  children: [
                    SkeletonBox(width: double.infinity, height: 150, borderRadius: BorderRadius.all(Radius.circular(AppSpacing.cardRadius))),
                    SizedBox(height: AppSpacing.lg),
                    ProductRowSkeleton(),
                    SizedBox(height: AppSpacing.lg),
                    ProductRowSkeleton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
