import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/features/tweet_creation/presentation/pages/tweet_creation_page.dart';
import 'package:flutter/material.dart';

import 'widgets/tweet_creation_floating_button.dart';

class TweetCreationFeature {
  static const String Route = '/tweet';
  static const String Key = 'tweetCreationIsActive';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {
      Route: (context) => TweetCreationFeature().buildPage(),
    };
  }

  static Future<dynamic> navigate(BuildContext context) {
    return Navigator.of(context).pushNamed(Route);
  }

  Widget buildPage() {
    return TweetCreationPage();
  }

  Widget buildFloatingButton() {
    return TweetCreationFloatingButton(
      featureConfig: Injector.instance.resolve<FeatureConfig>(),
    );
  }
}
