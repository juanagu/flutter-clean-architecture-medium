import 'package:app/src/application/localizations/i18n.dart';
import 'package:flutter/material.dart';

/// Shows the translation of [key] in the nearest ScaffoldMessenger.
void showTranslatedSnackBar(BuildContext context, String key) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(I18n.of(context).translate(key))));
}
