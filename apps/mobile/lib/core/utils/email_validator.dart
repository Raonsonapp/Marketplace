/// Email validation for the sign-in flow. Mirrors the backend's
/// `dto.ValidEmail` (services/api/internal/httpapi/dto/validate.go)
/// deliberately: a permissive "something@something.tld" shape check, since
/// the only real proof an address works is that the OTP code sent to it
/// arrives — a stricter pattern would reject legitimate addresses.
class EmailValidator {
  EmailValidator._();

  static final RegExp _pattern = RegExp(r'^[^@\s]+@[^@\s.]+(\.[^@\s.]+)+$');

  /// Whether [input] is plausibly an email address, ignoring surrounding
  /// whitespace and case.
  static bool isValid(String input) => normalize(input) != null;

  /// Trims and lowercases [input], returning null when it isn't a plausible
  /// address. The backend normalizes the same way, so the value sent here
  /// is the value the account is keyed on.
  static String? normalize(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty || trimmed.length > 255) return null;
    return _pattern.hasMatch(trimmed) ? trimmed : null;
  }
}
