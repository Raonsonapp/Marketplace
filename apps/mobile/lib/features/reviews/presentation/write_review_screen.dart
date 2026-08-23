import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../../l10n/app_localizations.dart';
import '../application/write_review_controller.dart';

/// Arguments for [WriteReviewScreen], passed via `GoRouter`'s `extra`
/// (matching `OtpRouteArgs`'s precedent) rather than URL params — the
/// review is always tied to one specific purchased line, never a
/// client-guessed id, so it must come from the order detail screen that
/// pushed this route.
class WriteReviewRouteArgs {
  const WriteReviewRouteArgs({
    required this.productId,
    required this.orderItemId,
    required this.productName,
  });

  final String productId;
  final String orderItemId;
  final String productName;
}

/// "Write a review" form (`POST /reviews` — docs/API_SPEC.md), reachable
/// only from a delivered order's line item (`OrderDetailScreen`) so
/// [WriteReviewRouteArgs.orderItemId] is always a real purchase.
class WriteReviewScreen extends ConsumerStatefulWidget {
  const WriteReviewScreen({super.key, required this.args});

  final WriteReviewRouteArgs args;

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  int _rating = 0;
  final _textController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final submitState = ref.watch(writeReviewControllerProvider);

    ref.listen(writeReviewControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && next.value != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.reviewsSubmitSuccess)));
        context.pop();
      }
    });

    final error = submitState.error;
    final isDuplicate = error is ApiException && error.code == 'DUPLICATE_REVIEW';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewsWriteTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            // Makes unmistakably clear which purchase this review is for —
            // never an arbitrary/guessed order item.
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.reviewsForPurchase(widget.args.productName),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: RatingStars(
                rating: _rating.toDouble(),
                size: 36,
                onChanged: (value) => setState(() => _rating = value),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.reviewsTextLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(hintText: l10n.reviewsTextHint),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${l10n.reviewsImageUrlLabel} ${l10n.commonOptional}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _imageUrlController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(hintText: l10n.reviewsImageUrlHint),
            ),
            if (isDuplicate) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.reviewsDuplicateError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ] else if (error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                error is ApiException ? error.message : l10n.commonErrorGeneric,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l10n.reviewsSubmit,
              isLoading: submitState.isLoading,
              onPressed: _rating == 0 ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final imageUrl = _imageUrlController.text.trim();
    await ref.read(writeReviewControllerProvider.notifier).submit(
          productId: widget.args.productId,
          orderItemId: widget.args.orderItemId,
          rating: _rating,
          text: _textController.text.trim().isEmpty ? null : _textController.text.trim(),
          images: imageUrl.isEmpty ? null : [imageUrl],
        );
  }
}
