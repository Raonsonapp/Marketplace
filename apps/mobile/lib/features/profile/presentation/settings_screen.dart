import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/models/country.dart';
import '../../../core/region/country_controller.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/session/session_controller.dart';
import '../../auth/application/logout_action.dart';
import '../application/profile_controller.dart';

/// Settings screen: market (country), language and theme switches, plus
/// logout.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);
    final languageLabel = switch (locale.languageCode) {
      'ru' => l10n.languageRussian,
      'en' => l10n.languageEnglish,
      _ => l10n.languageTajik,
    };
    final countries = ref.watch(countriesProvider).valueOrNull ?? const <Country>[];
    final activeCountry = ref.watch(activeCountryProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final themeLabel = switch (themeMode) {
      ThemeMode.light => l10n.themeLight,
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.dark => l10n.themeDark,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileSettings)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // The market decides the currency, the delivery cities and which
          // stores the home feed shows. Hidden while `/countries` is still
          // loading or reports a single market — there is nothing to pick.
          if (countries.length > 1) ...[
            Card(
              child: ListTile(
                leading: const Icon(LucideIcons.mapPin),
                title: Text(l10n.profileCountry),
                subtitle: Text(activeCountry == null
                    ? l10n.commonLoading
                    : '${activeCountry.flagEmoji}  ${activeCountry.name(locale.languageCode)}'),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: () => _pickCountry(context, ref, countries, locale.languageCode),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Card(
            child: ListTile(
              leading: const Icon(LucideIcons.globe),
              title: Text(l10n.profileLanguage),
              subtitle: Text(languageLabel),
              trailing: const Icon(LucideIcons.chevronRight),
              onTap: () => context.push(RoutePaths.languageSelection),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: ListTile(
              leading: const Icon(LucideIcons.settings),
              title: Text(l10n.profileTheme),
              subtitle: Text(themeLabel),
              trailing: const Icon(LucideIcons.chevronRight),
              onTap: () => _pickThemeMode(context, ref, themeMode),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(LucideIcons.logOut, color: AppColors.error),
            label: Text(l10n.authLogout, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCountry(
    BuildContext context,
    WidgetRef ref,
    List<Country> countries,
    String languageCode,
  ) async {
    final current = ref.read(selectedCountryProvider);
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: RadioGroup<String>(
          groupValue: current,
          onChanged: (value) => Navigator.of(sheetContext).pop(value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final country in countries)
                RadioListTile<String>(
                  value: country.code,
                  title: Text('${country.flagEmoji}  ${country.name(languageCode)}'),
                  subtitle: Text(country.currencyLabel(languageCode)),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected == null) return;
    await ref.read(selectedCountryProvider.notifier).select(selected);
    // Mirror the choice onto the account so it follows the user to another
    // device. Best-effort: the local preference is what the UI reads, so a
    // failed sync must not surface as an error or block the switch.
    final isAuthenticated =
        ref.read(sessionControllerProvider).valueOrNull?.isAuthenticated ?? false;
    if (isAuthenticated) {
      await ref.read(profileControllerProvider.notifier).updateProfile(country: selected);
    }
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.authLogout),
        content: Text(l10n.authLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await performLogout(ref);
    if (context.mounted) context.go(RoutePaths.home);
  }

  Future<void> _pickThemeMode(BuildContext context, WidgetRef ref, ThemeMode current) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: RadioGroup<ThemeMode>(
          groupValue: current,
          onChanged: (value) => Navigator.of(sheetContext).pop(value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode in ThemeMode.values)
                RadioListTile<ThemeMode>(
                  value: mode,
                  title: Text(switch (mode) {
                    ThemeMode.light => l10n.themeLight,
                    ThemeMode.system => l10n.themeSystem,
                    ThemeMode.dark => l10n.themeDark,
                  }),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected != null) {
      await ref.read(themeModeControllerProvider.notifier).setThemeMode(selected);
    }
  }
}
