import 'dart:developer';

import 'package:app/src/abstractions/utils/logger.dart';

class WebMockLogger implements Logger {
  @override
  Future<void> error(String message) async {
    log('Error: $error');
  }

  @override
  Future<void> info(String message) async {
    log('Info: $error');
  }

  @override
  Future<void> recordError(error, StackTrace stackTrace) async {
    log(
      error.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
