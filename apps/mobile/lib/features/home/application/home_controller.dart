import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/home_models.dart';
import '../data/home_repository.dart';

/// Loads the home feed. A plain [AsyncNotifier] (rather than a raw
/// FutureProvider) so the screen can call [refresh] from pull-to-refresh.
class HomeController extends AsyncNotifier<HomeFeed> {
  @override
  Future<HomeFeed> build() {
    return ref.watch(homeRepositoryProvider).getHomeFeed();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<HomeFeed>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(homeRepositoryProvider).getHomeFeed());
  }
}

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeFeed>(HomeController.new);
