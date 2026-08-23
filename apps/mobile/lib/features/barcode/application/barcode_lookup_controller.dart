import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product.dart';
import '../../../core/network/app_exception.dart';
import '../../product/data/product_repository.dart';

part 'barcode_lookup_controller.freezed.dart';

enum BarcodeLookupStatus { idle, loading, found, notFound, error }

@freezed
abstract class BarcodeLookupState with _$BarcodeLookupState {
  const factory BarcodeLookupState({
    @Default(BarcodeLookupStatus.idle) BarcodeLookupStatus status,
    String? code,
    ProductDetail? product,
    AppException? error,
  }) = _BarcodeLookupState;
}

/// Drives the barcode/price-scanner screen: given a scanned code, calls
/// `GET /products/barcode/:code` (docs/API_SPEC.md) and exposes a distinct
/// "not found" status for a 404 rather than a generic error, per the
/// brief's "clear, localized not-found state" requirement.
class BarcodeLookupController extends Notifier<BarcodeLookupState> {
  @override
  BarcodeLookupState build() => const BarcodeLookupState();

  Future<void> lookup(String code) async {
    // Ignore re-detections of the same code while a lookup is already in
    // flight or already resolved for it (the scanner fires onDetect
    // continuously while the code stays in frame).
    if (state.status == BarcodeLookupStatus.loading) return;
    if (state.code == code &&
        (state.status == BarcodeLookupStatus.found ||
            state.status == BarcodeLookupStatus.notFound)) {
      return;
    }

    state = BarcodeLookupState(status: BarcodeLookupStatus.loading, code: code);
    try {
      final detail = await ref.read(productRepositoryProvider).getProductByBarcode(code);
      state = BarcodeLookupState(
        status: BarcodeLookupStatus.found,
        code: code,
        product: detail,
      );
    } on AppException catch (e) {
      final isNotFound = e is ApiException && e.statusCode == 404;
      state = BarcodeLookupState(
        status: isNotFound ? BarcodeLookupStatus.notFound : BarcodeLookupStatus.error,
        code: code,
        error: isNotFound ? null : e,
      );
    }
  }

  /// Resets to idle so the scanner can look for a new code.
  void reset() => state = const BarcodeLookupState();
}

final barcodeLookupControllerProvider =
    NotifierProvider<BarcodeLookupController, BarcodeLookupState>(BarcodeLookupController.new);
