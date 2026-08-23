import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/app_user.dart';

part 'session_state.freezed.dart';

enum AuthStatus { authenticated, unauthenticated }

/// Current authentication session. Read by the router redirect guard and by
/// any screen that needs to know whether the user is logged in (see
/// docs/API_SPEC.md: catalog/home/search work anonymously but personalize
/// when a token is present).
@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    required AuthStatus status,
    AppUser? user,
  }) = _SessionState;

  const SessionState._();

  bool get isAuthenticated => status == AuthStatus.authenticated;
}
