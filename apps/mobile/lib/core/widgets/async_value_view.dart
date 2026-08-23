import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_state_view.dart';

/// Renders an [AsyncValue] with the standard loading/error/data treatment
/// every screen in the app uses, so no screen hand-rolls `.when(...)` with
/// ad-hoc placeholders (see docs/ARCHITECTURE.md).
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    required this.onRetry,
    this.loading,
    this.errorTitle,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback onRetry;
  final Widget Function()? loading;
  final String? errorTitle;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, stackTrace) => ErrorStateView(
        error: error,
        onRetry: onRetry,
        title: errorTitle,
      ),
      loading: () => loading?.call() ??
          const Center(child: CircularProgressIndicator()),
      skipLoadingOnReload: false,
      skipLoadingOnRefresh: false,
    );
  }
}
