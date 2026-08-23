import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tajikshop/core/localization/fallback_localizations_delegate.dart';
import 'package:tajikshop/core/network/api_client.dart';
import 'package:tajikshop/core/network/app_exception.dart';
import 'package:tajikshop/core/storage/secure_token_storage.dart';
import 'package:tajikshop/core/widgets/error_state_view.dart';
import 'package:tajikshop/core/widgets/skeleton_loader.dart';
import 'package:tajikshop/features/home/data/home_models.dart';
import 'package:tajikshop/features/home/data/home_repository.dart';
import 'package:tajikshop/features/home/presentation/home_screen.dart';
import 'package:tajikshop/l10n/app_localizations.dart';

/// Never actually calls the platform secure-storage channel — the home
/// screen's anonymous-browsing path (favorites, session) only needs
/// "no session", and constructing [FlutterSecureStorage] itself does not
/// touch the platform channel (only its read/write methods do, and those
/// are overridden away below).
class _FakeSecureTokenStorage extends SecureTokenStorage {
  _FakeSecureTokenStorage() : super(const FlutterSecureStorage());

  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {}

  @override
  Future<void> clear() async {}
}

/// Resolves after [delay] and then always throws, simulating a real failed
/// `GET /home` call (e.g. no connectivity) without a network dependency.
class _FailingHomeRepository extends HomeRepository {
  _FailingHomeRepository(this.delay) : super(ApiClient(Dio()));

  final Duration delay;

  @override
  Future<HomeFeed> getHomeFeed() async {
    await Future<void>.delayed(delay);
    throw const NetworkException(NetworkErrorKind.noConnection);
  }
}

void main() {
  testWidgets('home screen shows a loading skeleton, then an error state on failure', (tester) async {
    final app = ProviderScope(
      overrides: [
        secureTokenStorageProvider.overrideWithValue(_FakeSecureTokenStorage()),
        homeRepositoryProvider.overrideWithValue(
          _FailingHomeRepository(const Duration(milliseconds: 50)),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('tg'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          FallbackMaterialLocalizationsDelegate(),
          FallbackCupertinoLocalizationsDelegate(),
          FallbackWidgetsLocalizationsDelegate(),
        ],
        home: const HomeScreen(),
      ),
    );

    await tester.pumpWidget(app);

    // Immediately after the first frame, the feed is still loading.
    await tester.pump();
    expect(find.byType(SkeletonBox), findsWidgets);
    expect(find.byType(ErrorStateView), findsNothing);

    // Let the fake repository's delay elapse and the future reject.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.byType(ErrorStateView), findsOneWidget);
    expect(find.byType(SkeletonBox), findsNothing);
  });
}
