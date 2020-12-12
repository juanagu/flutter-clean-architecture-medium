import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/auth/auth_index_feature.dart';
import 'package:app/src/features/sign_in/sign_in_feature.dart';
import 'package:app/src/features/sign_up/data/firebase/sign_up_firebase_repository.dart';
import 'package:app/src/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:app/src/features/sign_up/presentation/cubits/sign_up_cubit.dart';
import 'package:app/src/features/sign_up/presentation/pages/sign_up_page.dart';
import 'package:app/src/features/sign_up/presentation/widgets/sign_up_button.dart';
import 'package:app/src/features/sign_up/presentation/widgets/sign_up_component.dart';
import 'package:flutter/material.dart';

class SignUpFeature {
  static const String Route = '/sign-up';
  static const String Key = 'signUpFeatureIsActive';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {
      Route: (context) => SignUpFeature().buildPage(),
    };
  }

  static Future<dynamic> navigate(
    BuildContext context, {
    bool retainHistory = true,
  }) {
    final navigator = Navigator.of(context);

    if (retainHistory) return navigator.pushNamed(Route);

    return navigator.pushNamedAndRemoveUntil(Route, (route) => false);
  }

  Widget buildPage() {
    return SignUpPage(
      signUpWidget: _build(),
    );
  }

  Widget buildButton() {
    return SignUpButton(
      featureConfig: Injector.instance.resolve<FeatureConfig>(),
    );
  }

  Widget _build() {
    return SignUpComponent(
      cubit: _provideCubit(),
      onRegistered: (context) => AuthIndexFeature.navigate(context),
    );
  }

  SignUpCubit _provideCubit() {
    return SignUpCubit(
      signUpRepository: _provideRepository(),
    );
  }

  SignUpRepository _provideRepository() {
    return SignUpFirebaseRepository(
      logger: Injector.instance.resolve<Logger>(),
    );
  }
}
