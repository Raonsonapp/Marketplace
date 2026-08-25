import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../session/session_controller.dart';
import 'route_paths.dart';

/// The persistent 5-tab bottom navigation shell (Home / Catalog / Cart /
/// Orders / Profile — docs/ARCHITECTURE.md section 3). Built with
/// [StatefulShellRoute.indexedStack] so each tab keeps its own navigation
/// stack and scroll/state across switches.
///
/// Cart, Orders, and Profile require a session (docs/API_SPEC.md: catalog/
/// home/search work anonymously, everything else needs auth) — tapping one
/// of those tabs while logged out redirects to login instead of switching.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _authRequiredIndexes = {2, 3, 4}; // cart, orders, profile

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAuthenticated = ref.watch(
      sessionControllerProvider.select((s) => s.valueOrNull?.isAuthenticated ?? false),
    );

    void onTap(int index) {
      if (_authRequiredIndexes.contains(index) && !isAuthenticated) {
        context.push(RoutePaths.login);
        return;
      }
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: onTap,
        destinations: [
          NavigationDestination(
            icon: const Icon(LucideIcons.store),
            selectedIcon: const Icon(LucideIcons.store),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.layoutGrid),
            selectedIcon: const Icon(LucideIcons.layoutGrid),
            label: l10n.navCatalog,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.shoppingCart),
            selectedIcon: const Icon(LucideIcons.shoppingCart),
            label: l10n.navCart,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.receipt),
            selectedIcon: const Icon(LucideIcons.receipt),
            label: l10n.navOrders,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.user),
            selectedIcon: const Icon(LucideIcons.user),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
