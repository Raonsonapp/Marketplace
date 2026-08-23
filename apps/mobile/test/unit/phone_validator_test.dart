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

  group('PhoneValidator.normalize (Russia)', () {
    test('accepts a full +7 number unchanged', () {
      expect(PhoneValidator.normalize('+79161234567'), '+79161234567');
    });

    test('accepts a bare 10-digit national number with region: russia', () {
      expect(
        PhoneValidator.normalize('9161234567', region: PhoneRegion.russia),
        '+79161234567',
      );
    });

    test('normalizes the domestic 8-prefixed dialing form', () {
      expect(PhoneValidator.normalize('89161234567'), '+79161234567');
    });

    test('a +7 number normalizes correctly even with region: tajikistan selected', () {
      // The number's own prefix wins over the selector (see normalize's
      // doc comment) — otherwise switching the selector back could corrupt
      // an already-typed number from the other region.
      expect(
        PhoneValidator.normalize('+79161234567', region: PhoneRegion.tajikistan),
        '+79161234567',
      );
    });

    test('rejects a +7 number with the wrong digit count', () {
      expect(PhoneValidator.normalize('+7916123456'), isNull);
    });
  });

  group('PhoneValidator.detectRegion', () {
    test('detects Tajikistan from a +992 prefix', () {
      expect(PhoneValidator.detectRegion('+992501234567'), PhoneRegion.tajikistan);
    });

    test('detects Russia from a +7 prefix', () {
      expect(PhoneValidator.detectRegion('+79161234567'), PhoneRegion.russia);
    });

    test('detects Russia from the domestic 8 prefix', () {
      expect(PhoneValidator.detectRegion('89161234567'), PhoneRegion.russia);
    });

    test('returns null when no recognizable prefix is present', () {
      expect(PhoneValidator.detectRegion('501234567'), isNull);
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

    test('groups a Russian number for readability', () {
      expect(PhoneValidator.formatForDisplay('+79161234567'), '+7 916 123 45 67');
    });
  });
}
