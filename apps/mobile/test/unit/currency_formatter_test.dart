import 'package:flutter_test/flutter_test.dart';
import 'package:tajikshop/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter.format', () {
    test('formats a simple decimal-string amount with the Tajik suffix', () {
      expect(CurrencyFormatter.format('125.50'), '125.50 сомонӣ');
    });

    test('formats with the Russian suffix when requested', () {
      expect(CurrencyFormatter.format('125.50', languageCode: 'ru'), '125.50 сомони');
    });

    test('groups thousands with a thin space', () {
      expect(CurrencyFormatter.format('1250.00'), '1 250.00 сомонӣ');
    });

    test('groups larger amounts correctly', () {
      expect(CurrencyFormatter.format('1234567.89'), '1 234 567.89 сомонӣ');
    });

    test('pads a whole-number amount to two decimals', () {
      expect(CurrencyFormatter.format('99'), '99.00 сомонӣ');
    });

    test('treats an unparsable amount as zero rather than throwing', () {
      expect(CurrencyFormatter.format('not-a-number'), '0.00 сомонӣ');
    });

    test('formats zero correctly', () {
      expect(CurrencyFormatter.format('0'), '0.00 сомонӣ');
    });
  });

  group('CurrencyFormatter.formatDouble', () {
    test('formats a double amount', () {
      expect(CurrencyFormatter.formatDouble(42.5), '42.50 сомонӣ');
    });
  });

  group('CurrencyFormatter.formatBare', () {
    test('formats without the currency suffix', () {
      expect(CurrencyFormatter.formatBare('1250.5'), '1 250.50');
    });
  });
}
