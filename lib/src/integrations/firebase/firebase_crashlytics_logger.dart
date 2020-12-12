import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:app/src/abstractions/utils/logger.dart';

class FirebaseCrashlyticsLogger implements Logger {
  FirebaseCrashlytics _instance;
  @override
  Future<void> error(String message) async {
    var crashlytics = await _getInstance();
    await crashlytics.log('Error: $message');
  }

  @override
  Future<void> info(String message) async {
    var crashlytics = await _getInstance();
    await crashlytics.log('Info: $message');
  }

  @override
  Future<void> recordError(error, StackTrace stackTrace) async {
    var crashlytics = await _getInstance();
    await crashlytics.recordError(error, stackTrace);
  }

  Future<FirebaseCrashlytics> _getInstance() async {
    await _init();
    return _instance;
  }

  Future<void> _init() async {
    if (_instance == null) {
      _instance = FirebaseCrashlytics.instance;
      FlutterError.onError = (FlutterErrorDetails errorDetails) async {
        await _instance.recordFlutterError(errorDetails);
      };
      await _instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    }
  }
}
