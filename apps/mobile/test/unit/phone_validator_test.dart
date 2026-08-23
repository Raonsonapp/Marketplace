import 'package:flutter_test/flutter_test.dart';
import 'package:tajikshop/core/utils/phone_validator.dart';

void main() {
  group('PhoneValidator.normalize', () {
    test('accepts a full +992 number unchanged', () {
      expect(PhoneValidator.normalize('+992501234567'), '+992501234567');
    });

    test('accepts a bare 9-digit national number and adds the prefix', () {
      expect(PhoneValidator.normalize('501234567'), '+992501234567');
    });

    test('strips spaces and dashes before validating', () {
      expect(PhoneValidator.normalize('50 123-45-67'), '+992501234567');
    });

    test('normalizes the 00992 international-dial prefix', () {
      expect(PhoneValidator.normalize('00992501234567'), '+992501234567');
    });

    test('normalizes a bare 992-prefixed number', () {
      expect(PhoneValidator.normalize('992501234567'), '+992501234567');
    });

    test('rejects a number with too few digits', () {
      expect(PhoneValidator.normalize('+99250123'), isNull);
    });

    test('rejects a number with too many digits', () {
      expect(PhoneValidator.normalize('+9925012345678'), isNull);
    });

    test('rejects a non-Tajik country code', () {
      expect(PhoneValidator.normalize('+1234567890'), isNull);
    });

    test('rejects empty input', () {
      expect(PhoneValidator.normalize(''), isNull);
    });
  });

  group('PhoneValidator.isValid', () {
    test('true for a valid number', () {
      expect(PhoneValidator.isValid('+992501234567'), isTrue);
    });

    test('false for an invalid number', () {
      expect(PhoneValidator.isValid('12345'), isFalse);
    });
  });

  group('PhoneValidator.formatForDisplay', () {
    test('groups the national number for readability', () {
      expect(PhoneValidator.formatForDisplay('+992501234567'), '+992 50 123 45 67');
    });

    test('returns the input unchanged when it is not a canonical number', () {
      expect(PhoneValidator.formatForDisplay('not-a-phone'), 'not-a-phone');
    });
  });
}
