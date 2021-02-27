import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/auth/auth_index_feature.dart';
import 'package:app/src/features/sign_in/data/firebase/sign_in_firebase_repository.dart';
import 'package:app/src/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:app/src/features/sign_in/presentation/cubits/sign_in_cubit.dart';
import 'package:app/src/features/sign_in/presentation/pages/sign_in_page.dart';
import 'package:app/src/features/sign_in/presentation/widgets/sign_in_component.dart';
import 'package:flutter/material.dart';

class SignInFeature {
  static const String route = '/sign-in';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {
      route: (context) => SignInFeature().buildPage(),
    };
  }

  static Future<dynamic> navigate(
    BuildContext context, {
    bool retainHistory = false,
  }) {
    final navigator = Navigator.of(context);

    if (retainHistory) return navigator.pushNamed(route);

    return navigator.pushNamedAndRemoveUntil(route, (route) => false);
  }

  Widget buildPage() {
    return SignInPage(
      signInWiget: _build(),
    );
  }

  Widget _build() {
    return SignInComponent(
      cubit: _provideCubit(),
      onAuthorized: AuthIndexFeature.navigate,
    );
  }

  SignInCubit _provideCubit() {
    return SignInCubit(
      signInRepository: _provideRepository(),
    );
  }

  SignInRepository _provideRepository() {
    return SignInFirebaseRepository(
      logger: Injector.instance.resolve<Logger>(),
    );
  }
}
