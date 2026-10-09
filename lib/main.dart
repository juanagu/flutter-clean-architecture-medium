import 'dart:ui';

import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/application/application.dart';
import 'package:app/src/ioc/ioc_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final injector = IocManager.register();
  _forwardUncaughtErrors(() => injector.resolve<Logger>());

  if (!IocManager.useInMemoryBackend) {
    await Firebase.initializeApp();
  }

  runApp(const Application());
}

void _forwardUncaughtErrors(Logger Function() logger) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _report(logger, details.exception, details.stack ?? StackTrace.empty);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    _report(logger, error, stackTrace);
    return true;
  };
}

/// A logger that fails (Crashlytics before Firebase is ready, for instance)
/// must not re-enter the error handler, so its own failure only prints.
Future<void> _report(
  Logger Function() logger,
  Object error,
  StackTrace stackTrace,
) async {
  try {
    await logger().recordError(error, stackTrace);
  } catch (loggingError) {
    debugPrint('Uncaught: $error\n$stackTrace\nLogger failed: $loggingError');
  }
}
