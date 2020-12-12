import 'package:flutter/material.dart';
import 'package:app/src/core/presentation/localizations/i18n.dart';

class SignInValidator {
  String validateEmail(BuildContext context, String value) {
    if (value.isEmpty) {
      return I18n.of(context).translate('sign_in_email_is_required');
    }

    return null;
  }

  String validatePassword(BuildContext context, String value) {
    if (value.isEmpty) {
      return I18n.of(context).translate('sign_in_password_is_required');
    }
    return null;
  }
}
