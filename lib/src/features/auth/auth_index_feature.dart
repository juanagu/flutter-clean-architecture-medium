import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/auth/data/remote/auth_session_remote_repository.dart';
import 'package:app/src/features/auth/domain/repositories/auth_session_repository.dart';
import 'package:app/src/features/auth/presentation/cubits/auth_index_cubit.dart';
import 'package:app/src/features/auth/presentation/pages/auth_index_page.dart';
import 'package:app/src/features/home/home_feature.dart';
import 'package:app/src/features/sign_in/sign_in_feature.dart';
import 'package:flutter/material.dart';

/// Composition root of the entry screen.
class AuthIndexFeature {
  static const String route = '/';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {route: (context) => AuthIndexFeature().buildPage()};
  }

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (route) => false);
  }

  Widget buildPage() {
    return AuthIndexPage(
      createCubit: _provideCubit,
      onAuthorized: HomeFeature.navigate,
      onUnauthorized: SignInFeature.navigate,
    );
  }

  AuthIndexCubit _provideCubit() {
    final injector = Injector.instance;
    return AuthIndexCubit(
      authSessionRepository: _provideRepository(injector),
      featureConfig: injector.resolve<FeatureConfig>(),
      logger: injector.resolve<Logger>(),
    );
  }

  AuthSessionRepository _provideRepository(Injector injector) {
    return AuthSessionRemoteRepository(
      authClient: injector.resolve<AuthClient>(),
      logger: injector.resolve<Logger>(),
    );
  }
}
