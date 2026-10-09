import 'package:app/src/abstractions/utils/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseCrashlyticsLogger implements Logger {
  FirebaseCrashlyticsLogger();

  Future<void>? _configured;

  FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;

  @override
  Future<void> info(String message) async {
    await _ensureConfigured();
    await _crashlytics.log('Info: $message');
  }

  @override
  Future<void> error(String message) async {
    await _ensureConfigured();
    await _crashlytics.log('Error: $message');
  }

  @override
  Future<void> recordError(Object error, StackTrace stackTrace) async {
    await _ensureConfigured();
    await _crashlytics.recordError(error, stackTrace);
  }

  /// Debug builds never report, so local crashes don't pollute the console.
  /// A failed setup is forgotten so the next call can retry it.
  Future<void> _ensureConfigured() => _configured ??= _configure();

  Future<void> _configure() async {
    try {
      await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    } catch (_) {
      _configured = null;
      rethrow;
    }
  }
}
