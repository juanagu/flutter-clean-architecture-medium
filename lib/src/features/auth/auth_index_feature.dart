import 'dart:developer';

import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/features/home/presentation/home_feature.dart';
import 'package:flutter/material.dart';
import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/auth/data/remote/auth_session_remote_repository.dart';
import 'package:app/src/features/auth/presentation/cubits/auth_index_cubit.dart';
import 'package:app/src/features/auth/presentation/pages/index_page.dart';
import 'package:app/src/features/sign_in/sign_in_feature.dart';

class AuthIndexFeature {
  static const String route = '/';
  static const String key = 'appIsActive';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {
      route: (context) => AuthIndexFeature().buildPage(),
    };
  }

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (route) => false,
    );
  }

  Widget buildPage() {
    return AuthIndexPage(
      cubit: _provideCubit(),
      onAuthorized: HomeFeature.navigate,
      onUnauthorized: SignInFeature.navigate,
      onUnexpected: (context) {
        log('onUnexpected');
      },
    );
  }

  AuthIndexCubit _provideCubit() => AuthIndexCubit(
        authSessionRepository: _provideRepository(),
        featureConfig: Injector.instance.resolve<FeatureConfig>(),
      );

  AuthSessionRemoteRepository _provideRepository() {
    var injector = Injector.instance;
    return AuthSessionRemoteRepository(
      dataRemoteClient: injector.resolve<DataRemoteClient>(),
      logger: injector.resolve<Logger>(),
    );
  }
}
