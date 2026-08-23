import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/models/store.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../l10n/app_localizations.dart';
import '../application/nearby_stores_controller.dart';
import 'widgets/store_info_sheet.dart';

/// "Nearby stores" map (docs/ARCHITECTURE.md's vendor-neutral `geo.Provider`
/// principle, mirrored here with OpenStreetMap tiles rather than a paid
/// map vendor): on-demand GPS permission + position via `geolocator`, then
/// `GET /stores?lat=&lng=` (docs/API_SPEC.md) rendered as markers.
class StoresMapScreen extends ConsumerStatefulWidget {
  const StoresMapScreen({super.key});

  @override
  ConsumerState<StoresMapScreen> createState() => _StoresMapScreenState();
}

class _StoresMapScreenState extends ConsumerState<StoresMapScreen> {
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Permission is requested here, when the user opens this screen — never
    // upfront at app launch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nearbyStoresControllerProvider.notifier).requestLocationAndLoad();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(nearbyStoresControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storesMapTitle)),
      body: _buildBody(context, l10n, state),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, NearbyStoresState state) {
    switch (state.status) {
      case LocationUiStatus.idle:
      case LocationUiStatus.locating:
      case LocationUiStatus.loadingStores:
        return const Center(child: CircularProgressIndicator(color: AppColors.emeraldGreen));

      case LocationUiStatus.serviceDisabled:
      case LocationUiStatus.permissionDenied:
        return _PermissionPrompt(
          message: l10n.storesMapPermissionMessage,
          onGrant: () => ref.read(nearbyStoresControllerProvider.notifier).requestLocationAndLoad(),
        );

      case LocationUiStatus.permissionDeniedForever:
        return _PermissionPrompt(
          message: l10n.storesMapPermissionMessage,
          grantLabel: l10n.storesMapPermissionOpenSettings,
          onGrant: () => Geolocator.openAppSettings(),
        );

      case LocationUiStatus.error:
        return ErrorStateView(
          error: state.error ?? const UnknownException('failed to load nearby stores'),
          onRetry: () => ref.read(nearbyStoresControllerProvider.notifier).retry(),
        );

      case LocationUiStatus.loaded:
        if (state.stores.isEmpty) {
          return EmptyStateView(icon: LucideIcons.mapPin, title: l10n.storesMapEmptyTitle);
        }
        return _MapView(stores: state.stores, center: LatLng(state.lat!, state.lng!));
    }
  }
}

class _MapView extends StatelessWidget {
  const _MapView({required this.stores, required this.center});

  final List<Store> stores;
  final LatLng center;

  @override
  Widget build(BuildContext context) {
    final storesWithLocation = stores.where((s) => s.lat != null && s.lng != null).toList();

    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: 13),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'tj.tajikshop.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 24,
              height: 24,
              child: const _UserLocationDot(),
            ),
            ...storesWithLocation.map((store) => Marker(
                  point: LatLng(store.lat!, store.lng!),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _showStoreSheet(context, store),
                    child: const Icon(
                      LucideIcons.mapPin,
                      color: AppColors.emeraldGreen,
                      size: 36,
                    ),
                  ),
                )),
          ],
        ),
      ],
    );
  }

  void _showStoreSheet(BuildContext context, Store store) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StoreInfoSheet(store: store),
    );
  }
}

class _UserLocationDot extends StatelessWidget {
  const _UserLocationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.info.withValues(alpha: 0.9),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _PermissionPrompt extends StatelessWidget {
  const _PermissionPrompt({required this.message, required this.onGrant, this.grantLabel});

  final String message;
  final VoidCallback onGrant;
  final String? grantLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: EmptyStateView(
            icon: LucideIcons.mapPin,
            title: l10n.storesMapPermissionTitle,
            message: message,
            actionLabel: grantLabel ?? l10n.storesMapPermissionGrant,
            onAction: onGrant,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: TextButton(
            // Never blocks the rest of the app on a denied permission —
            // the user can always fall back to manually managing addresses.
            onPressed: () => context.push(RoutePaths.addresses),
            child: Text(l10n.storesMapChooseManually),
          ),
        ),
      ],
    );
  }
}
