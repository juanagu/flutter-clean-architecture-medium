import 'dart:convert';
import 'dart:io';

import 'package:app/src/application/localizations/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reads a real dictionary from disk so widget tests exercise shipped copy.
Map<String, dynamic> loadDictionary(String languageCode) {
  final raw = File('assets/i18n/$languageCode.json').readAsStringSync();
  return json.decode(raw) as Map<String, dynamic>;
}

class _MapLocalizationsDelegate extends LocalizationsDelegate<I18n> {
  const _MapLocalizationsDelegate(this.languageCode, this.sentences);

  final String languageCode;
  final Map<String, dynamic> sentences;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<I18n> load(Locale locale) async =>
      I18n.fromMap(Locale(languageCode), sentences);

  @override
  bool shouldReload(_MapLocalizationsDelegate old) => false;
}

/// Wraps [child] in a MaterialApp with the given dictionary so `I18n.of`
/// and `ScaffoldMessenger.of` work, then settles the first frame.
Future<I18n> pumpLocalized(
  WidgetTester tester,
  Widget child, {
  String languageCode = 'en',
  Size viewport = const Size(390, 844),
}) async {
  final sentences = loadDictionary(languageCode);
  await tester.binding.setSurfaceSize(viewport);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(languageCode),
      localizationsDelegates: [
        _MapLocalizationsDelegate(languageCode, sentences),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],
      home: Scaffold(body: child),
    ),
  );
  await tester.pump();
  return I18n.fromMap(Locale(languageCode), sentences);
}
