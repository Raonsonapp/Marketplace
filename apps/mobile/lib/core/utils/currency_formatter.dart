/// Formats money amounts consistently across the whole app.
///
/// Amounts from the API always arrive as decimal strings with two digits
/// (e.g. `"125.50"`) — see docs/API_SPEC.md — and carry no currency tag,
/// because which currency they are in follows from the market the shopper is
/// in (somoni in Tajikistan, rubles in Russia). Callers pass that market's
/// label as [currencyLabel]; the Tajik somoni names remain the fallback for
/// when `/countries` has not loaded yet.
class CurrencyFormatter {
  CurrencyFormatter._();

  static const String _currencySuffixTj = 'сомонӣ';
  static const String _currencySuffixRu = 'сомони';
  static const String _currencySuffixEn = 'TJS';

  /// Formats a decimal-string amount (as returned by the API) into a
  /// display string, e.g. `format("1250.5")` -> `"1 250.50 сомонӣ"`.
  ///
  /// [currencyLabel] comes from the active market (`Country.currencyLabel`);
  /// when it is null the Tajik somoni names are used, which is what every
  /// call site meant before the app served two countries.
  static String format(String amount, {String languageCode = 'tg', String? currencyLabel}) {
    final value = double.tryParse(amount) ?? 0;
    return formatDouble(value, languageCode: languageCode, currencyLabel: currencyLabel);
  }

  /// Formats a numeric amount into a display string.
  static String formatDouble(
    double amount, {
    String languageCode = 'tg',
    String? currencyLabel,
  }) {
    final fixed = amount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final wholePart = _groupThousands(parts[0]);
    final suffix = currencyLabel ??
        switch (languageCode) {
          'ru' => _currencySuffixRu,
          'en' => _currencySuffixEn,
          _ => _currencySuffixTj,
        };
    return '$wholePart.${parts[1]} $suffix';
  }

  /// Formats an amount without the currency suffix (e.g. for compact UI
  /// like quantity steppers showing a running total inline).
  static String formatBare(String amount) {
    final value = double.tryParse(amount) ?? 0;
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    return '${_groupThousands(parts[0])}.${parts[1]}';
  }

  static String _groupThousands(String digits) {
    final isNegative = digits.startsWith('-');
    final unsigned = isNegative ? digits.substring(1) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < unsigned.length; i++) {
      final positionFromEnd = unsigned.length - i;
      buffer.write(unsigned[i]);
      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write(' ');
      }
    }
    return (isNegative ? '-' : '') + buffer.toString();
  }
}
