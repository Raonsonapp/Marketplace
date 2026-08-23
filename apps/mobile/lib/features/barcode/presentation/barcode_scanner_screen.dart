import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../l10n/app_localizations.dart';
import '../application/barcode_lookup_controller.dart';
import 'widgets/barcode_result_sheet.dart';

/// The barcode/price-scanner screen (Magnit-style price checker): opens
/// the camera, reads a barcode, calls `GET /products/barcode/:code`
/// (docs/API_SPEC.md), and shows the result — or a clear "not found" state
/// for a 404. Camera permission is requested on demand when this screen is
/// opened, not upfront at app launch.
class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

enum _PermissionUiState { checking, granted, denied, permanentlyDenied }

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  MobileScannerController? _controller;
  _PermissionUiState _permissionState = _PermissionUiState.checking;
  bool _torchOn = false;
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    _applyStatus(status);
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    _applyStatus(status);
  }

  void _applyStatus(PermissionStatus status) {
    if (!mounted) return;
    setState(() {
      if (status.isGranted || status.isLimited) {
        _permissionState = _PermissionUiState.granted;
        _controller ??= MobileScannerController();
      } else if (status.isPermanentlyDenied) {
        _permissionState = _PermissionUiState.permanentlyDenied;
      } else {
        _permissionState = _PermissionUiState.denied;
      }
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (_sheetOpen) return;
    final rawValue = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;
    ref.read(barcodeLookupControllerProvider.notifier).lookup(rawValue);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen(barcodeLookupControllerProvider, (previous, next) {
      if (next.status == BarcodeLookupStatus.found && next.product != null && !_sheetOpen) {
        _sheetOpen = true;
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => BarcodeResultSheet(
            product: next.product!.product,
            onScanAgain: () {
              Navigator.of(context).pop();
            },
          ),
        ).whenComplete(() {
          _sheetOpen = false;
          ref.read(barcodeLookupControllerProvider.notifier).reset();
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(l10n.barcodeScanTitle),
        actions: [
          if (_permissionState == _PermissionUiState.granted) ...[
            IconButton(
              icon: Icon(_torchOn ? LucideIcons.flashlight : LucideIcons.flashlightOff),
              tooltip: l10n.barcodeToggleFlash,
              onPressed: () async {
                await _controller?.toggleTorch();
                setState(() => _torchOn = !_torchOn);
              },
            ),
            IconButton(
              icon: const Icon(LucideIcons.switchCamera),
              tooltip: l10n.barcodeSwitchCamera,
              onPressed: () => _controller?.switchCamera(),
            ),
          ],
        ],
      ),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    switch (_permissionState) {
      case _PermissionUiState.checking:
        return const Center(child: CircularProgressIndicator(color: AppColors.emeraldGreen));
      case _PermissionUiState.granted:
        return _buildScanner(context, l10n);
      case _PermissionUiState.denied:
        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: EmptyStateView(
            icon: LucideIcons.camera,
            title: l10n.barcodeCameraPermissionTitle,
            message: l10n.barcodeCameraPermissionMessage,
            actionLabel: l10n.barcodeCameraPermissionGrant,
            onAction: _requestPermission,
          ),
        );
      case _PermissionUiState.permanentlyDenied:
        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: EmptyStateView(
            icon: LucideIcons.cameraOff,
            title: l10n.barcodeCameraPermissionTitle,
            message: l10n.barcodeCameraPermissionMessage,
            actionLabel: l10n.barcodeCameraPermissionOpenSettings,
            onAction: openAppSettings,
          ),
        );
    }
  }

  Widget _buildScanner(BuildContext context, AppLocalizations l10n) {
    final lookupState = ref.watch(barcodeLookupControllerProvider);

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        IgnorePointer(
          child: Center(
            child: Container(
              width: 240,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.emeraldGreen, width: 2),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: AppSpacing.xl,
          child: Column(
            children: [
              if (lookupState.status == BarcodeLookupStatus.loading)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: CircularProgressIndicator(color: AppColors.emeraldGreen),
                ),
              if (lookupState.status == BarcodeLookupStatus.notFound)
                _NotFoundBanner(code: lookupState.code ?? '', l10n: l10n)
              else if (lookupState.status == BarcodeLookupStatus.error &&
                  lookupState.error != null)
                _ScanErrorBanner(error: lookupState.error!)
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                  child: Text(
                    l10n.barcodeScanInstructions,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotFoundBanner extends ConsumerWidget {
  const _NotFoundBanner({required this.code, required this.l10n});

  final String code;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.packageX, color: AppColors.error, size: 28),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.barcodeNotFoundTitle,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.barcodeNotFoundMessage(code),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextButton(
            onPressed: () => ref.read(barcodeLookupControllerProvider.notifier).reset(),
            child: Text(l10n.barcodeScanAgain),
          ),
        ],
      ),
    );
  }
}

class _ScanErrorBanner extends ConsumerWidget {
  const _ScanErrorBanner({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ErrorStateView.messageFor(context, error),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextButton(
            onPressed: () => ref.read(barcodeLookupControllerProvider.notifier).reset(),
            child: Text(AppLocalizations.of(context)!.commonRetry),
          ),
        ],
      ),
    );
  }
}
