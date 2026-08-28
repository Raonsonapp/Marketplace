import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_user.dart';
import '../../../core/region/country_controller.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/storage/preferences_storage.dart';
import '../data/profile_repository.dart';

/// Loads/updates the authenticated user's profile (`GET/PATCH /profile` —
/// docs/API_SPEC.md) and mirrors the result into [SessionController] so
/// every screen reading `sessionControllerProvider.user` stays in sync.
class ProfileController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    // .select narrows this to the isAuthenticated flag only — watching the
    // full SessionState here would re-trigger build() every time updateUser
    // below writes the freshly-fetched profile back into it, refetching
    // forever (observed in production: hundreds of GET /profile calls/min).
    final isAuthenticated = ref.watch(
      sessionControllerProvider.select((s) => s.valueOrNull?.isAuthenticated ?? false),
    );
    if (!isAuthenticated) return null;
    final profile = await ref.watch(profileRepositoryProvider).getProfile();
    ref.read(sessionControllerProvider.notifier).updateUser(profile);
    // Signing in on a new device: the account already knows which market it
    // shops in, so adopt it. Only when nothing is stored locally — a choice
    // made on this device is the more recent intent and must not be undone
    // by a stale server value.
    if (ref.read(preferencesStorageProvider).readCountry() == null) {
      await ref.read(selectedCountryProvider.notifier).select(profile.country);
    }
    return profile;
  }

  Future<void> updateProfile({String? fullName, String? email, String? country}) async {
    state = const AsyncLoading<AppUser?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final updated = await ref.read(profileRepositoryProvider).updateProfile(
            fullName: fullName,
            email: email,
            country: country,
          );
      ref.read(sessionControllerProvider.notifier).updateUser(updated);
      return updated;
    });
  }
}

final profileControllerProvider = AsyncNotifierProvider<ProfileController, AppUser?>(
  ProfileController.new,
);
