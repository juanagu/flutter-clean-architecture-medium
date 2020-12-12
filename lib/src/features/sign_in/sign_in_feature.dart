import 'package:app/src/features/sign_in/presentation/pages/sign_in_page.dart';
import 'package:app/src/features/sign_in/presentation/widgets/sign_in_component.dart';
import 'package:flutter/material.dart';

class SignInFeature {
  static const String Route = '/sign-in';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {
      Route: (context) => SignInFeature().buildPage(),
    };
  }

  static Future<dynamic> navigate(
    BuildContext context, {
    bool retainHistory = false,
  }) {
    final navigator = Navigator.of(context);

    if (retainHistory) return navigator.pushNamed(Route);

    return navigator.pushNamedAndRemoveUntil(Route, (route) => false);
  }

  Widget buildPage() {
    return SignInPage(
      signInWiget: _build(),
    );
  }

  Widget _build() {
    return SignInComponent();
  }
}
