import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_user.dart';
import '../../../core/session/session_controller.dart';
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
    return profile;
  }

  Future<void> updateProfile({String? fullName, String? email}) async {
    state = const AsyncLoading<AppUser?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final updated = await ref.read(profileRepositoryProvider).updateProfile(
            fullName: fullName,
            email: email,
          );
      ref.read(sessionControllerProvider.notifier).updateUser(updated);
      return updated;
    });
  }
}

final profileControllerProvider = AsyncNotifierProvider<ProfileController, AppUser?>(
  ProfileController.new,
);
