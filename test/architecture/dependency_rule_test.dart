import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces the dependency rule from docs/architecture.md by reading every
/// import under lib/. A failure lists the offending lines, so the fix is
/// always a specific import to remove or re-route.
void main() {
  final sources = _dartFiles(Directory('lib'));

  test('lib/ has the expected top-level layers', () {
    final layers = sources.map(_layerOf).whereType<String>().toSet();
    expect(
      layers,
      containsAll([
        'abstractions',
        'core',
        'application',
        'features',
        'integrations',
        'ioc',
      ]),
    );
  });

  test('every app import respects the layer table', () {
    final violations = <String>[];
    for (final source in sources) {
      for (final import in _appImports(source)) {
        if (!_isAllowed(source, import)) {
          violations.add('${_relative(source)} imports ${import.path}');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('vendor packages are imported only by integrations and main', () {
    final violations = <String>[];
    for (final source in sources) {
      final layer = _layerOf(source);
      if (layer == 'integrations' || _isMain(source)) continue;

      for (final package in _vendorImports(source)) {
        violations.add('${_relative(source)} imports package:$package');
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('a feature never imports its own composition root from inside', () {
    final violations = <String>[];
    for (final source in sources) {
      final feature = _featureOf(source);
      if (feature == null || _isCompositionRoot(source)) continue;

      for (final import in _appImports(source)) {
        if (import.feature == feature && import.isCompositionRoot) {
          violations.add('${_relative(source)} imports ${import.path}');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

const Set<String> _vendorPrefixes = {
  'firebase_',
  'cloud_firestore',
  'get_it',
  'timeago',
};

final RegExp _importLine = RegExp(
  r'''^import\s+'([^']+)'(?:\s+(?:as|hide|show)\b[^;]*)?;''',
  multiLine: true,
);
final RegExp _appImport = RegExp(r'^package:app/(.*)$');
final RegExp _compositionRoot = RegExp(
  r'^features/([a-z_]+)/[a-z_]+_feature\.dart$',
);

List<File> _dartFiles(Directory directory) {
  return directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();
}

String _relative(File file) =>
    file.path.replaceAll('\\', '/').replaceFirst(RegExp(r'^.*?lib/'), 'lib/');

bool _isMain(File file) => _relative(file) == 'lib/main.dart';

/// The folder right under lib/src, or null for lib/main.dart.
String? _layerOf(File file) {
  final match = RegExp(r'^lib/src/([a-z_]+)/').firstMatch(_relative(file));
  return match?.group(1);
}

String? _featureOf(File file) {
  final match = RegExp(r'^lib/src/features/([a-z_]+)/')
      .firstMatch(_relative(file));
  return match?.group(1);
}

bool _isCompositionRoot(File file) =>
    _compositionRoot.hasMatch(_relative(file).replaceFirst('lib/src/', ''));

Iterable<_AppImport> _appImports(File file) sync* {
  for (final match in _importLine.allMatches(file.readAsStringSync())) {
    final target = _appImport.firstMatch(match.group(1)!);
    if (target == null) continue;
    yield _AppImport(target.group(1)!);
  }
}

Iterable<String> _vendorImports(File file) sync* {
  for (final match in _importLine.allMatches(file.readAsStringSync())) {
    final uri = match.group(1)!;
    if (!uri.startsWith('package:')) continue;
    final package = uri.substring('package:'.length).split('/').first;
    if (_vendorPrefixes.any(package.startsWith)) yield package;
  }
}

/// The table in docs/architecture.md, one row per importing layer.
bool _isAllowed(File source, _AppImport import) {
  if (_isMain(source)) return true;

  return switch (_layerOf(source)) {
    'abstractions' => import.layer == 'abstractions',
    'core' => const {'abstractions', 'core'}.contains(import.layer),
    'features' => _featureMayImport(_featureOf(source)!, import),
    'application' =>
      const {'abstractions', 'core', 'application'}.contains(import.layer) ||
          (import.layer == 'features' && import.isCompositionRoot),
    'integrations' => const {
      'abstractions',
      'core',
      'integrations',
    }.contains(import.layer),
    'ioc' => true,
    _ => false,
  };
}

bool _featureMayImport(String feature, _AppImport import) {
  if (const {'abstractions', 'core', 'application'}.contains(import.layer)) {
    return true;
  }
  if (import.layer != 'features') return false;

  return import.feature == feature || import.isCompositionRoot;
}

class _AppImport {
  _AppImport(this.path)
    : layer = path.startsWith('main.dart')
          ? 'main'
          : path.split('/').skip(1).first,
      feature = RegExp(r'^src/features/([a-z_]+)/').firstMatch(path)?.group(1),
      isCompositionRoot = _compositionRoot.hasMatch(
        path.replaceFirst('src/', ''),
      );

  /// Path after `package:app/`, e.g. `src/features/auth/auth_index_feature.dart`.
  final String path;
  final String layer;
  final String? feature;
  final bool isCompositionRoot;
}
