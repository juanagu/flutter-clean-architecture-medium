import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/auth/auth_index_feature.dart';
import 'package:app/src/features/sign_in/data/remote/sign_in_remote_repository.dart';
import 'package:app/src/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:app/src/features/sign_in/presentation/cubits/sign_in_cubit.dart';
import 'package:app/src/features/sign_in/presentation/pages/sign_in_page.dart';
import 'package:app/src/features/sign_in/presentation/widgets/sign_in_component.dart';
import 'package:app/src/features/sign_up/sign_up_feature.dart';
import 'package:flutter/material.dart';

/// Composition root of the sign-in screen.
class SignInFeature {
  static const String route = '/sign-in';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {route: (context) => SignInFeature().buildPage()};
  }

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (route) => false);
  }

  Widget buildPage() {
    return SignInPage(
      body: SignInComponent(
        createCubit: _provideCubit,
        onAuthorized: AuthIndexFeature.navigate,
        signUpAction: SignUpFeature().buildButton(),
      ),
    );
  }

  SignInCubit _provideCubit() {
    return SignInCubit(signInRepository: _provideRepository());
  }

  SignInRepository _provideRepository() {
    final injector = Injector.instance;
    return SignInRemoteRepository(
      authClient: injector.resolve<AuthClient>(),
      logger: injector.resolve<Logger>(),
    );
  }
}
