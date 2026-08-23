/// Formats Tajik Somoni amounts consistently across the whole app.
///
/// Amounts from the API always arrive as decimal strings with two digits
/// (e.g. `"125.50"`) — see docs/API_SPEC.md. This formatter is the single
/// place that turns such a value into the user-facing "125.50 сомонӣ"
/// (or "125.50 сомони" for Russian, currency name is invariant/Tajik-derived
/// but the numeral formatting follows the active locale's grouping).
class CurrencyFormatter {
  CurrencyFormatter._();

  static const String _currencySuffixTj = 'сомонӣ';
  static const String _currencySuffixRu = 'сомони';

  /// Formats a decimal-string amount (as returned by the API) into a
  /// display string, e.g. `format("1250.5")` -> `"1 250.50 сомонӣ"`.
  static String format(String amount, {String languageCode = 'tg'}) {
    final value = double.tryParse(amount) ?? 0;
    return formatDouble(value, languageCode: languageCode);
  }

  /// Formats a numeric amount into a display string.
  static String formatDouble(double amount, {String languageCode = 'tg'}) {
    final fixed = amount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final wholePart = _groupThousands(parts[0]);
    final suffix = languageCode == 'ru' ? _currencySuffixRu : _currencySuffixTj;
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
