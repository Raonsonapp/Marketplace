import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bridges a Riverpod provider to go_router's `refreshListenable`, so the
/// router re-evaluates its `redirect` callback whenever [provider] changes
/// (e.g. login/logout) without the router itself depending on Riverpod's
/// widget-tree context.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref, ProviderListenable providers) {
    ref.listen(providers, (_, _) => notifyListeners());
  }
}
