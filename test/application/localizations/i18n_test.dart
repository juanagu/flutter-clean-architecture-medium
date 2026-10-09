import 'dart:io';

import 'package:app/src/application/localizations/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/localized.dart';

void main() {
  group('I18n.translate', () {
    final i18n = I18n.fromMap(const Locale('en'), {
      'plain': 'Plain',
      'nested': {'key': 'Nested'},
    });

    test('resolves flat and dotted keys', () {
      expect(i18n.translate('plain'), 'Plain');
      expect(i18n.translate('nested.key'), 'Nested');
    });

    test('returns the key itself when it is missing', () {
      expect(i18n.translate('missing'), 'missing');
      expect(i18n.translate('nested.missing'), 'nested.missing');
      expect(i18n.translate('plain.deeper'), 'plain.deeper');
    });

    test('returns the key when it points at a branch, not a leaf', () {
      expect(i18n.translate('nested'), 'nested');
    });
  });

  group('dictionaries', () {
    final dictionaries = {
      for (final language in I18n.languages)
        language: _flatten(loadDictionary(language)),
    };

    test('every language has the same keys', () {
      final reference = dictionaries[I18n.defaultLanguage]!;
      for (final entry in dictionaries.entries) {
        expect(
          entry.value,
          reference,
          reason: '${entry.key}.json differs from ${I18n.defaultLanguage}.json',
        );
      }
    });

    test('every key used in lib/ exists in the default dictionary', () {
      final used = _keysUsedInSources(Directory('lib'));
      final defined = dictionaries[I18n.defaultLanguage]!;

      expect(used, isNotEmpty);
      expect(used.difference(defined), isEmpty);
    });

    test('every dictionary key is used by some source file', () {
      final used = _keysUsedInSources(Directory('lib'));
      final defined = dictionaries[I18n.defaultLanguage]!;

      expect(defined.difference(used), isEmpty);
    });
  });
}

Set<String> _flatten(Map<String, dynamic> map, [String prefix = '']) {
  final keys = <String>{};
  map.forEach((key, value) {
    final path = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map<String, dynamic>) {
      keys.addAll(_flatten(value, path));
    } else {
      keys.add(path);
    }
  });
  return keys;
}

final RegExp _translateCall = RegExp(r"translate\('([^']+)'\)");
final RegExp _keyConstant = RegExp(r"Key = '([a-z_.]+)';");
final RegExp _keyLiteral = RegExp(r"'([a-z_]+\.[a-z_]+(?:\.[a-z_]+)*)'");

/// Collects i18n keys from source: `translate('x.y')` calls, `...Key = 'x.y'`
/// constants, and dotted string literals passed around as keys.
Set<String> _keysUsedInSources(Directory directory) {
  final keys = <String>{};
  final files = directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
  for (final file in files) {
    final source = file.readAsStringSync();
    for (final pattern in [_translateCall, _keyConstant, _keyLiteral]) {
      keys.addAll(
        pattern
            .allMatches(source)
            .map((match) => match.group(1)!)
            .where((key) => !key.endsWith('.dart')),
      );
    }
  }
  return keys;
}
