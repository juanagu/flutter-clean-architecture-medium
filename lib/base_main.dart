import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app/src/ioc/ioc_manager.dart';

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  IocManager.register();
}
