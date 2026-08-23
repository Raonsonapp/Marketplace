import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/promotion_models.dart';
import '../data/promotions_repository.dart';

/// Active campaigns/personal offers (`GET /promotions` — docs/API_SPEC.md).
class PromotionsController extends AsyncNotifier<List<Promotion>> {
  @override
  Future<List<Promotion>> build() {
    return ref.watch(promotionsRepositoryProvider).getPromotions();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<Promotion>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(promotionsRepositoryProvider).getPromotions());
  }
}

final promotionsControllerProvider =
    AsyncNotifierProvider<PromotionsController, List<Promotion>>(PromotionsController.new);
