import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/loyalty_models.dart';
import '../data/loyalty_repository.dart';

/// The TajBonus balance/tier/lifetime-earned summary (`GET /loyalty` —
/// docs/API_SPEC.md).
class LoyaltyAccountController extends AsyncNotifier<LoyaltyAccount> {
  @override
  Future<LoyaltyAccount> build() {
    return ref.watch(loyaltyRepositoryProvider).getAccount();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<LoyaltyAccount>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(loyaltyRepositoryProvider).getAccount());
  }
}

final loyaltyAccountControllerProvider =
    AsyncNotifierProvider<LoyaltyAccountController, LoyaltyAccount>(LoyaltyAccountController.new);
