import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/application/feature_flags.dart';
import 'package:app/src/application/widgets/feature_gate.dart';
import 'package:app/src/features/auth/auth_index_feature.dart';
import 'package:app/src/features/sign_up/data/remote/sign_up_remote_repository.dart';
import 'package:app/src/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:app/src/features/sign_up/presentation/cubits/sign_up_cubit.dart';
import 'package:app/src/features/sign_up/presentation/pages/sign_up_page.dart';
import 'package:app/src/features/sign_up/presentation/widgets/sign_up_button.dart';
import 'package:app/src/features/sign_up/presentation/widgets/sign_up_component.dart';
import 'package:flutter/material.dart';

/// Composition root of the sign-up screen and of the button that opens it.
class SignUpFeature {
  static const String route = '/sign-up';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {route: (context) => SignUpFeature().buildPage()};
  }

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context).pushNamed(route);
  }

  Widget buildPage() {
    return SignUpPage(
      body: SignUpComponent(
        createCubit: _provideCubit,
        onRegistered: AuthIndexFeature.navigate,
      ),
    );
  }

  /// Hidden while the sign-up toggle is off.
  Widget buildButton() {
    return FeatureGate(
      featureConfig: Injector.instance.resolve<FeatureConfig>(),
      flag: FeatureFlags.signUp,
      child: const SignUpButton(onPressed: navigate),
    );
  }

  SignUpCubit _provideCubit() {
    return SignUpCubit(signUpRepository: _provideRepository());
  }

  SignUpRepository _provideRepository() {
    final injector = Injector.instance;
    return SignUpRemoteRepository(
      authClient: injector.resolve<AuthClient>(),
      logger: injector.resolve<Logger>(),
    );
  }
}
