import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class I18n {
  I18n.fromMap(this.locale, Map<String, dynamic> sentences)
    : _sentences = sentences;

  static const List<String> languages = ['en', 'es'];
  static const String defaultLanguage = 'en';

  final Locale locale;
  final Map<String, dynamic> _sentences;

  static I18n of(BuildContext context) {
    final i18n = Localizations.of<I18n>(context, I18n);
    assert(
      i18n != null,
      'No I18n in context: register AppLocalizationsDelegate',
    );
    return i18n!;
  }

  static Future<I18n> load(Locale locale) async {
    final raw = await _loadAsset(locale.languageCode);
    return I18n.fromMap(locale, json.decode(raw) as Map<String, dynamic>);
  }

  static Future<String> _loadAsset(String languageCode) async {
    try {
      return await rootBundle.loadString('assets/i18n/$languageCode.json');
    } on FlutterError {
      return rootBundle.loadString('assets/i18n/$defaultLanguage.json');
    }
  }

  /// Resolves a dotted key such as `sign_in_feature.email_label`. A missing key
  /// comes back unchanged so the gap is visible in the UI and in tests.
  String translate(String key) {
    Object? node = _sentences;
    for (final part in key.split('.')) {
      if (node is! Map<String, dynamic>) return key;
      node = node[part];
    }
    return node is String ? node : key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<I18n> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      I18n.languages.contains(locale.languageCode);

  @override
  Future<I18n> load(Locale locale) => I18n.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
