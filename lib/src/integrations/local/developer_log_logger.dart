import 'dart:developer' as developer;

import 'package:app/src/abstractions/utils/logger.dart';

/// Writes to the Dart developer log. Used where Crashlytics is unavailable.
class DeveloperLogLogger implements Logger {
  const DeveloperLogLogger();

  static const String _name = 'app';

  @override
  Future<void> info(String message) async {
    developer.log('Info: $message', name: _name);
  }

  @override
  Future<void> error(String message) async {
    developer.log('Error: $message', name: _name);
  }

  @override
  Future<void> recordError(Object error, StackTrace stackTrace) async {
    developer.log(
      error.toString(),
      name: _name,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
