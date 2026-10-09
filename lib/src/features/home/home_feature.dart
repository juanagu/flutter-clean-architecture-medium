import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/application/feature_flags.dart';
import 'package:app/src/application/widgets/feature_gate.dart';
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

  /// Reads the compose toggle once: it decides both whether the button is
  /// there and whether the feed keeps its last row clear of it.
  Widget buildPage() {
    return FeatureGate.builder(
      featureConfig: Injector.instance.resolve<FeatureConfig>(),
      flag: FeatureFlags.tweetCreation,
      builder: (_, canCompose) => HomePage(
        feed: TweetFeedFeature().build(hasFloatingAction: canCompose),
        composeButton: canCompose
            ? TweetCreationFeature().buildFloatingButton()
            : null,
      ),
    );
  }
}
