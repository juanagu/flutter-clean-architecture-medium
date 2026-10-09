import 'package:app/src/application/validators/email_password_validator.dart';
import 'package:app/src/application/validators/email_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailValidator', () {
    const valid = [
      'user@example.com',
      'first.last+tag@sub.example.co',
      'user@my-domain.io',
      "o'neil@example.org",
    ];
    const invalid = [
      '',
      'user',
      'user@',
      '@example.com',
      'user@example',
      'user@-example.com',
      'user@example.com extra',
      'user @example.com',
    ];

    for (final email in valid) {
      test(
        'accepts $email',
        () => expect(EmailValidator.validate(email), isTrue),
      );
    }

    for (final email in invalid) {
      test('rejects "$email"', () {
        expect(EmailValidator.validate(email), isFalse);
      });
    }
  });

  group('EmailPasswordValidator', () {
    const validator = EmailPasswordValidator();

    test('requires an email', () {
      expect(
        validator.validateEmail('  '),
        EmailPasswordValidator.emailRequiredKey,
      );
      expect(
        validator.validateEmail(null),
        EmailPasswordValidator.emailRequiredKey,
      );
    });

    test('rejects a malformed email', () {
      expect(
        validator.validateEmail('nope'),
        EmailPasswordValidator.emailInvalidKey,
      );
    });

    test('accepts a padded valid email', () {
      expect(validator.validateEmail(' user@example.com '), isNull);
    });

    test('requires a password', () {
      expect(
        validator.validatePassword(''),
        EmailPasswordValidator.passwordRequiredKey,
      );
      expect(validator.validatePassword('secret'), isNull);
    });
  });
}
