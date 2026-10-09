import 'package:app/src/features/home/presentation/pages/home_page.dart';
import 'package:app/src/features/tweet_creation/tweet_creation_feature.dart';
import 'package:app/src/features/tweet_feed/tweet_feed_feature.dart';
import 'package:flutter/material.dart';

/// Composition root of the home screen: the feed plus the compose button.
class HomeFeature {
  static const String route = '/home';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {route: (context) => HomeFeature().buildPage()};
  }

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (route) => false);
  }

  Widget buildPage() {
    return HomePage(
      feed: TweetFeedFeature().build(),
      composeButton: TweetCreationFeature().buildFloatingButton(),
    );
  }
}
