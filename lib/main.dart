import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app/src/abstractions/utils/logger.dart';

import 'base_main.dart';
import 'src/abstractions/ioc/injector.dart';
import 'src/core/presentation/application.dart';

Future<void> main() async {
  await init();
  runZonedGuarded(
    () => runApp(Application()),
    (error, stackTrace) {
      Injector.instance.resolve<Logger>().recordError(error, stackTrace);
    },
  );
}
