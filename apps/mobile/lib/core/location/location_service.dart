import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Why the current-location request could not be fulfilled — mapped to a
/// user-facing message by the caller rather than surfaced as a raw
/// exception, mirroring `NearbyStoresController`'s status handling.
enum LocationFailure {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  lookupFailed,
}

/// The device's current position plus its best-effort reverse-geocoded
/// address parts (any of which may be null if the platform geocoder can't
/// resolve them — the lat/lng is always present).
class ResolvedLocation {
  const ResolvedLocation({
    required this.latitude,
    required this.longitude,
    this.city,
    this.street,
    this.house,
  });

  final double latitude;
  final double longitude;
  final String? city;
  final String? street;
  final String? house;
}

/// Thrown by [LocationService.currentLocation] with a typed [reason] so the
/// UI can show the right prompt (turn on GPS, grant permission, open
/// settings) instead of a generic error.
class LocationException implements Exception {
  const LocationException(this.reason);
  final LocationFailure reason;
}

/// One place for "get the device's current location", shared by the nearby
/// stores map, the delivery-address form's auto-fill, and the seller store
/// GPS step. Requests permission on demand (never at startup) and, when
/// asked, reverse-geocodes the coordinates into city/street for a form.
class LocationService {
  const LocationService();

  /// Requests permission if needed, then returns the current position.
  /// [withAddress] additionally reverse-geocodes it (best effort). Throws
  /// [LocationException] for every denied/disabled/failed path.
  Future<ResolvedLocation> currentLocation({bool withAddress = false}) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationFailure.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(LocationFailure.permissionDenied);
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationFailure.permissionDeniedForever);
    }

    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
    } catch (_) {
      throw const LocationException(LocationFailure.lookupFailed);
    }

    if (!withAddress) {
      return ResolvedLocation(latitude: position.latitude, longitude: position.longitude);
    }

    // Reverse-geocoding is best-effort: on a device with no geocoder backend
    // (some Android builds) it throws, in which case we still return the
    // coordinates so the delivery-zone check and map pin work — the user
    // just fills city/street by hand.
    try {
      final marks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final p = marks.isNotEmpty ? marks.first : null;
      return ResolvedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        city: _nonEmpty(p?.locality) ?? _nonEmpty(p?.subAdministrativeArea),
        street: _nonEmpty(p?.thoroughfare) ?? _nonEmpty(p?.street),
        house: _nonEmpty(p?.subThoroughfare),
      );
    } catch (_) {
      return ResolvedLocation(latitude: position.latitude, longitude: position.longitude);
    }
  }

  static String? _nonEmpty(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
}

final locationServiceProvider = Provider<LocationService>((ref) => const LocationService());
