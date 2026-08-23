/// Validates and normalizes Tajikistan phone numbers for the OTP auth flow.
///
/// Tajik mobile numbers are `+992` followed by exactly 9 digits, e.g.
/// `+992501234567`. See docs/SECURITY.md ("phone format `+992XXXXXXXXX`").
class PhoneValidator {
  PhoneValidator._();

  static const String countryCode = '+992';
  static const int nationalNumberLength = 9;

  static final RegExp _fullPattern = RegExp(r'^\+992\d{9}$');

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

  /// Normalizes a user-entered national number (with or without the `+992`
  /// prefix, spaces, dashes, etc.) into the canonical `+992XXXXXXXXX` form.
  /// Returns null if the input can never be normalized into a valid number.
  static String? normalize(String input) {
    var sanitized = sanitize(input);
    if (sanitized.startsWith('00992')) {
      sanitized = '+${sanitized.substring(2)}';
    } else if (sanitized.startsWith('992') && !sanitized.startsWith('+')) {
      sanitized = '+$sanitized';
    } else if (!sanitized.startsWith('+')) {
      // Assume the user typed only the 9-digit national number.
      sanitized = '$countryCode$sanitized';
    }
    if (!_fullPattern.hasMatch(sanitized)) {
      return null;
    }
    return sanitized;
  }

  /// True if [input] normalizes to a valid `+992XXXXXXXXX` number.
  static bool isValid(String input) => normalize(input) != null;

  /// Formats a canonical `+992XXXXXXXXX` number for display, e.g.
  /// `+992 50 123 45 67`.
  static String formatForDisplay(String canonical) {
    if (!_fullPattern.hasMatch(canonical)) return canonical;
    final national = canonical.substring(4); // strip +992
    final p1 = national.substring(0, 2);
    final p2 = national.substring(2, 5);
    final p3 = national.substring(5, 7);
    final p4 = national.substring(7, 9);
    return '$countryCode $p1 $p2 $p3 $p4';
  }
}
