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
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/cart_controller.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/cart_totals_summary.dart';

/// The Cart tab (`GET/POST/PATCH/DELETE /cart*` — docs/API_SPEC.md). Totals
/// are always the server's numbers (see `CartTotalsSummary`).
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cartAsync = ref.watch(cartControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cartTitle)),
      body: Column(
        children: [
          OfflineBanner(visible: cartAsync.hasError && cartAsync.error is NetworkException),
          Expanded(
            child: cartAsync.when(
              data: (cart) {
                if (cart.isEmpty) {
                  return EmptyStateView(
                    icon: LucideIcons.shoppingCart,
                    title: l10n.cartEmptyTitle,
                    message: l10n.cartEmptyMessage,
                    actionLabel: l10n.catalogTitle,
                    onAction: () => context.go(RoutePaths.catalog),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(cartControllerProvider.notifier).refresh(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      ...cart.items.map((item) => CartItemTile(
                            item: item,
                            onQuantityChanged: (qty) => ref
                                .read(cartControllerProvider.notifier)
                                .updateQuantity(cartItemId: item.id, quantity: qty),
                            onRemove: () =>
                                ref.read(cartControllerProvider.notifier).removeItem(item.id),
                            onSaveForLater: () =>
                                ref.read(cartControllerProvider.notifier).saveForLater(item.id),
                          )),
                      const SizedBox(height: AppSpacing.md),
                      CartTotalsSummary(cart: cart),
                      if (cart.savedForLater.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(l10n.cartSavedForLaterTitle, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        ...cart.savedForLater.map((item) => CartItemTile(
                              item: item,
                              onRemove: () =>
                                  ref.read(cartControllerProvider.notifier).removeItem(item.id),
                              onMoveToCart: () =>
                                  ref.read(cartControllerProvider.notifier).moveToCart(item.id),
                            )),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorStateView(
                error: error,
                onRetry: () => ref.read(cartControllerProvider.notifier).refresh(),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: ListRowSkeleton(count: 3),
              ),
            ),
          ),
          cartAsync.maybeWhen(
            data: (cart) => cart.isEmpty
                ? const SizedBox.shrink()
                : SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: PrimaryButton(
                        label: l10n.cartCheckoutButton,
                        onPressed: () => context.push(RoutePaths.checkout),
                      ),
                    ),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

