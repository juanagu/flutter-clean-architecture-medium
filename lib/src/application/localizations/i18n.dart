import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class I18n {
  static const List<String> Languages = ['en', 'es'];
  static const String DefaultLanguage = 'en';
  I18n(
    this._locale, {
    this.isTest = false,
  });

  final Locale _locale;
  bool isTest;
  Map<String, dynamic> _sentences;

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  Future<I18n> loadTest(Locale locale) async {
    return I18n(locale);
  }

  Future<I18n> load() async {
    var data = await _loadData();

    Map<String, dynamic> _result = json.decode(data);
    _sentences = {};
    _result.forEach((String key, dynamic value) {
      if (value is Map) {
        return _sentences[key] = value;
      }
      _sentences[key] = value.toString();
    });
    return I18n(_locale);
  }

  Future<String> _loadData() async {
    try {
      return await rootBundle
          .loadString('assets/i18n/${_locale.languageCode}.json');
    } catch (_) {
      return await rootBundle
          .loadString('assets/i18n/${I18n.DefaultLanguage}.json');
    }
  }

  String translate(String key) {
    if (isTest) return key;

    if (key == null) {
      return '...';
    }

    final keySplit = key.split('.');
    var text = keySplit.length == 1
        ? _sentences[keySplit[0]]
        : _getComposeTranslation(keySplit);
    return text ?? key;
  }

  String _getComposeTranslation(List<String> keySplit) {
    return _sentences[keySplit[0]] != null
        ? _sentences[keySplit[0]][keySplit[1]]
        : null;
  }

  String toUpperCase(String key) {
    return translate(key).toUpperCase();
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<I18n> {
  final bool isTest;
  const AppLocalizationsDelegate({
    this.isTest = false,
  });

  @override
  bool isSupported(Locale locale) {
    return I18n.Languages.contains(locale.languageCode);
  }

  @override
  Future<I18n> load(Locale locale) async {
    var localizations = I18n(
      locale,
      isTest: isTest,
    );
    if (isTest) {
      await localizations.loadTest(locale);
    } else {
      await localizations.load();
    }

    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
