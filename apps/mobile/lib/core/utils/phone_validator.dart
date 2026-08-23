/// Validates and normalizes phone numbers for the OTP auth flow across the
/// two regions TajikShop serves (docs/SECURITY.md): Tajikistan (+992, 9
/// national digits, e.g. `+992501234567`) and Russia (+7, 10 national
/// digits, e.g. `+79161234567`).
enum PhoneRegion {
  tajikistan('+992', 9, '🇹🇯'),
  russia('+7', 10, '🇷🇺');

  const PhoneRegion(this.countryCode, this.nationalNumberLength, this.flag);

  final String countryCode;
  final int nationalNumberLength;
  final String flag;
}

class PhoneValidator {
  PhoneValidator._();

  /// Kept for existing call sites that assumed a single region; new code
  /// should use [PhoneRegion] explicitly.
  static const String countryCode = '+992';
  static const int nationalNumberLength = 9;

  static final Map<PhoneRegion, RegExp> _patterns = {
    for (final region in PhoneRegion.values)
      region: RegExp('^\\${region.countryCode}\\d{${region.nationalNumberLength}}\$'),
  };

  /// Strips everything except digits and a leading `+`.
  static String sanitize(String input) {
    final trimmed = input.trim();
    final buffer = StringBuffer();
    for (var i = 0; i < trimmed.length; i++) {
      final char = trimmed[i];
      if (char == '+' && i == 0) {
        buffer.write(char);
      } else if (RegExp(r'\d').hasMatch(char)) {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// Detects the region from an explicit country-code prefix in [input]
  /// (`+992`/`992`, or `+7`/`8` — the common domestic-dial form for Russian
  /// numbers), if present.
  static PhoneRegion? detectRegion(String input) {
    final sanitized = sanitize(input);
    if (sanitized.startsWith('+992') || sanitized.startsWith('992')) {
      return PhoneRegion.tajikistan;
    }
    if (sanitized.startsWith('+7') || sanitized.startsWith('7') || sanitized.startsWith('8')) {
      return PhoneRegion.russia;
    }
    return null;
  }

  /// Normalizes a user-entered number (with or without a country-code
  /// prefix, spaces, dashes, etc.) into canonical `+<countryCode>XXXXXXXXX`
  /// form. [region] is used only when [input] carries no explicit country
  /// code of its own (e.g. the user typed just the national digits) —
  /// otherwise the number's own prefix wins, so a `+7...` number normalizes
  /// correctly even if the region selector is set to Tajikistan. Returns
  /// null if the input can never be normalized into a valid number.
  static String? normalize(String input, {PhoneRegion region = PhoneRegion.tajikistan}) {
    var sanitized = sanitize(input);

    if (sanitized.startsWith('00992')) {
      sanitized = '+${sanitized.substring(2)}';
    } else if (sanitized.startsWith('992') && !sanitized.startsWith('+')) {
      sanitized = '+$sanitized';
    } else if (sanitized.startsWith('+992')) {
      // already canonical
    } else if (sanitized.startsWith('8') && sanitized.length == 11) {
      // Russian domestic dialing convention (8XXXXXXXXXX) -> +7XXXXXXXXXX.
      sanitized = '+7${sanitized.substring(1)}';
    } else if (sanitized.startsWith('7') && !sanitized.startsWith('+')) {
      sanitized = '+$sanitized';
    } else if (sanitized.startsWith('+7')) {
      // already canonical
    } else if (!sanitized.startsWith('+')) {
      // No explicit country code typed — assume the selected region and
      // that the user typed only the national number.
      sanitized = '${region.countryCode}$sanitized';
    }

    for (final pattern in _patterns.values) {
      if (pattern.hasMatch(sanitized)) return sanitized;
    }
    return null;
  }

  /// True if [input] normalizes to a valid number in any supported region.
  static bool isValid(String input, {PhoneRegion region = PhoneRegion.tajikistan}) =>
      normalize(input, region: region) != null;

  /// Formats a canonical number for display, e.g. `+992 50 123 45 67` or
  /// `+7 916 123 45 67`.
  static String formatForDisplay(String canonical) {
    for (final region in PhoneRegion.values) {
      if (_patterns[region]!.hasMatch(canonical)) {
        final national = canonical.substring(region.countryCode.length);
        switch (region) {
          case PhoneRegion.tajikistan:
            return '${region.countryCode} ${national.substring(0, 2)} ${national.substring(2, 5)} '
                '${national.substring(5, 7)} ${national.substring(7, 9)}';
          case PhoneRegion.russia:
            return '${region.countryCode} ${national.substring(0, 3)} ${national.substring(3, 6)} '
                '${national.substring(6, 8)} ${national.substring(8, 10)}';
        }
      }
    }
    return canonical;
  }
}
