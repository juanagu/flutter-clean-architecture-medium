import 'package:app/src/application/validators/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:app/src/application/localizations/i18n.dart';

class SignInValidator {
  String validateEmail(BuildContext context, String value) {
    if (value.isEmpty) {
      return I18n.of(context).translate('sign_in_feature.email_is_required');
    }

    if (!EmailValidator.validate(value)) {
      return I18n.of(context).translate('email_invalid_format');
    }

    return null;
  }

  String validatePassword(BuildContext context, String value) {
    if (value.isEmpty) {
      return I18n.of(context).translate('sign_in_feature.password_is_required');
    }
    return null;
  }
}
