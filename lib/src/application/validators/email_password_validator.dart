import 'package:app/src/application/validators/email_validator.dart';

/// Validates the fields of an email + password form. Returns the i18n key of
/// the message to show, or null when the value is valid.
class EmailPasswordValidator {
  const EmailPasswordValidator();

  static const String emailRequiredKey = 'form.email_required';
  static const String emailInvalidKey = 'form.email_invalid';
  static const String passwordRequiredKey = 'form.password_required';

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return emailRequiredKey;
    if (!EmailValidator.validate(email)) return emailInvalidKey;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return passwordRequiredKey;
    return null;
  }
}
