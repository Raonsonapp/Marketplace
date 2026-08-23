import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Language switcher (Tajik default, Russian secondary —
/// docs/ARCHITECTURE.md). Persists the choice via [LocaleController].
class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.languageSelectTitle)),
      body: ListView(
        children: [
          RadioListTile<String>(
            value: 'tg',
            groupValue: currentLocale.languageCode,
            title: Text(l10n.languageTajik),
            activeColor: AppColors.emeraldGreen,
            onChanged: (value) => ref.read(localeControllerProvider.notifier).setLanguage(value!),
          ),
          RadioListTile<String>(
            value: 'ru',
            groupValue: currentLocale.languageCode,
            title: Text(l10n.languageRussian),
            activeColor: AppColors.emeraldGreen,
            onChanged: (value) => ref.read(localeControllerProvider.notifier).setLanguage(value!),
          ),
        ],
      ),
    );
  }
}
