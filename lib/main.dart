import 'dart:async';

import 'package:app/src/ioc/ioc_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app/src/abstractions/utils/logger.dart';

import 'src/abstractions/ioc/injector.dart';
import 'src/application/application.dart';

Future<void> main() async {
  await init();
  runZonedGuarded(
    () => runApp(Application()),
    (error, stackTrace) {
      Injector.instance.resolve<Logger>().recordError(error, stackTrace);
    },
  );
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  IocManager.register();
}
