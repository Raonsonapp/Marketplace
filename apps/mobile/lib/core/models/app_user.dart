import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// The authenticated user's profile, matching the `users` table exposed via
/// `GET /profile` / `POST /auth/verify-otp` (see docs/API_SPEC.md).
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String phone,
    String? fullName,
    String? email,
    String? avatarUrl,
    @Default('tg') String language,
    /// The market the account shops in ('TJ' or 'RU'), so the choice
    /// follows the user to a new device rather than living only in local
    /// preferences.
    @Default('TJ') String country,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
