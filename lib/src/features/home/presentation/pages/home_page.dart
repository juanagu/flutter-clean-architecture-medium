import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/features/tweet_creation/tweet_creation_feature.dart';
import 'package:app/src/features/tweet_feed/tweet_feed_feature.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: I18n.of(context).translate('home_title'),
      body: TweetFeedFeature().build(),
      floatingActionButton: TweetCreationFeature().buildFloatingButton(),
    );
  }
}
