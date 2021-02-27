import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/core/presentation/helpers/time_ago_helper.dart';
import 'package:app/src/features/feature_default_config.dart';
import 'package:app/src/integrations/date_time_helpers/timeago_impl_helper.dart';
import 'package:app/src/integrations/firebase/firebase_remote_feature_config.dart';
import 'package:app/src/integrations/firebase/user_session_firebase_repository.dart';
import 'package:app/src/integrations/web/web_mock_feature_config.dart';
import 'package:app/src/integrations/web/web_mock_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/integrations/firebase/firebase_crashlytics_logger.dart';
import 'package:app/src/integrations/firebase/firebase_data_remote_client.dart';
import 'package:app/src/integrations/get_it/get_it_injetor.dart';

abstract class IocManager {
  static void register() {
    var injector = Injector.register(GetItInjector());

    if (kIsWeb) {
      _registerWeb(injector);
    } else {
      _registerMobile(injector);
    }
  }

  static void _registerMobile(Injector injcetor) {
    var injector = Injector.register(GetItInjector())
      ..registerLazySingleton<Logger>(() => FirebaseCrashlyticsLogger())
      ..registerLazySingleton<FeatureConfig>(() => FirebaseRemoteFeatureConfig(
          defaultConfig: FeatureDefaultConfig.value));

    _registerCommons(injector);
  }

  static void _registerWeb(Injector injector) {
    injector
      ..registerLazySingleton<Logger>(() => WebMockLogger())
      ..registerLazySingleton<FeatureConfig>(() => WebMockFeatureConfig());
    _registerCommons(injector);
  }

  static void _registerCommons(Injector injector) {
    injector
      ..registerLazySingleton<DataRemoteClient>(
          () => FirebaseDataRemoteClient())
      ..registerFactory<UserSessionRepository>(
          () => UserSessionFirebaseRepository())
      ..registerLazySingleton<TimeagoHelper>(() => TimeagoImplHelper());
  }
}
