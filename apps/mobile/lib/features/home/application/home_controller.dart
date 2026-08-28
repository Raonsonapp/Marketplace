import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/region/country_controller.dart';
import '../data/home_models.dart';
import '../data/home_repository.dart';

/// Loads the home feed. A plain [AsyncNotifier] (rather than a raw
/// FutureProvider) so the screen can call [refresh] from pull-to-refresh.
class HomeController extends AsyncNotifier<HomeFeed> {
  @override
  Future<HomeFeed> build() {
    // Watched, not read: switching market in Settings has to rebuild the
    // feed, since the stores it shows are country-scoped.
    final country = ref.watch(selectedCountryProvider);
    return ref.watch(homeRepositoryProvider).getHomeFeed(country: country);
  }

  Future<void> refresh() async {
    final country = ref.read(selectedCountryProvider);
    state = const AsyncLoading<HomeFeed>().copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).getHomeFeed(country: country),
    );
  }
}

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeFeed>(HomeController.new);
