/// Form validators for the auth screens.
///
/// Kept in one place so the login and register forms report problems in the
/// same voice — short, specific, and about what to do next.
class AuthValidators {
  const AuthValidators._();

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  /// Generic "this cannot be empty" check. [field] is used in the message, so
  /// pass it capitalised: "Name", "Password".
  static String? required(String? value, String field) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  /// The login identifier.
  ///
  /// Deliberately does NOT check email format: `/auth/login` authenticates by
  /// username, so rejecting anything without an "@" would lock out every valid
  /// account. Emptiness is the only thing that can be judged here.
  static String? identifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or username is required';
    }
    return null;
  }

  /// Register-side email: required, and must actually look like an address.
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!_email.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  /// Confirmation must be present *and* match. [original] is the password
  /// field's current text.
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }
}
