import 'package:flutter/material.dart';

import 'pages/home_page.dart';

class HomeFeature {
  static const String Route = '/home';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {
      Route: (context) => HomeFeature().buildPage(),
    };
  }

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      Route,
      (route) => false,
    );
  }

  Widget buildPage() {
    return HomePage();
  }
}
