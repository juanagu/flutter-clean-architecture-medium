import 'package:flutter/material.dart';

import 'pages/home_page.dart';

class HomeFeature {
  static const String route = '/home';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {
      route: (context) => HomeFeature().buildPage(),
    };
  }

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (route) => false,
    );
  }

  Widget buildPage() {
    return HomePage();
  }
}
