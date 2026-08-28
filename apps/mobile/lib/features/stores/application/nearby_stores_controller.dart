import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/models/store.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/region/country_controller.dart';
import '../data/stores_repository.dart';

part 'nearby_stores_controller.freezed.dart';

enum LocationUiStatus {
  idle,
  locating,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  loadingStores,
  loaded,
  error,
}

@freezed
abstract class NearbyStoresState with _$NearbyStoresState {
  const factory NearbyStoresState({
    @Default(LocationUiStatus.idle) LocationUiStatus status,
    double? lat,
    double? lng,
    @Default(<Store>[]) List<Store> stores,
    AppException? error,
  }) = _NearbyStoresState;
}

/// Drives the "Nearby stores" map screen: on-demand location permission
/// (never requested at app start), reading the device's current GPS
/// position via `geolocator`, then calling `GET /stores?lat=&lng=`
/// (docs/API_SPEC.md, distance-sorted). Every failure mode — location
/// services off, permission denied (once or permanently), or the network
/// call itself failing — gets its own explicit, localized state rather
/// than a single generic error.
class NearbyStoresController extends Notifier<NearbyStoresState> {
  @override
  NearbyStoresState build() => const NearbyStoresState();

  Future<void> requestLocationAndLoad() async {
    state = state.copyWith(status: LocationUiStatus.locating, error: null);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(status: LocationUiStatus.serviceDisabled);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      state = state.copyWith(status: LocationUiStatus.permissionDenied);
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(status: LocationUiStatus.permissionDeniedForever);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      await _loadStores(position.latitude, position.longitude);
    } catch (e) {
      state = state.copyWith(status: LocationUiStatus.error, error: ErrorMapper.map(e));
    }
  }

  Future<void> _loadStores(double lat, double lng) async {
    state = state.copyWith(status: LocationUiStatus.loadingStores, lat: lat, lng: lng);
    try {
      final stores = await ref.read(storesRepositoryProvider).getNearbyStores(
        lat: lat,
        lng: lng,
        country: ref.read(selectedCountryProvider),
      );
      state = state.copyWith(status: LocationUiStatus.loaded, stores: stores);
    } catch (e) {
      state = state.copyWith(status: LocationUiStatus.error, error: ErrorMapper.map(e));
    }
  }

  Future<void> retry() => requestLocationAndLoad();
}

final nearbyStoresControllerProvider =
    NotifierProvider<NearbyStoresController, NearbyStoresState>(NearbyStoresController.new);
