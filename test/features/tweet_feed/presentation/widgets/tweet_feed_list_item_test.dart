import 'package:app/src/application/widgets/avatars/initial_avatar.dart';
import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';
import 'package:app/src/features/tweet_feed/presentation/widgets/tweet_feed_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';
import '../../../../support/localized.dart';

void main() {
  testWidgets('shows the owner initial, the header line and the content', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      TweetFeedListItem(
        tweetItem: TweetItem(
          tweet: makeTweet(content: 'Hello there'),
          timeAgo: '3 minutes ago',
        ),
        likeAction: const Text('like'),
      ),
    );

    expect(
      find.descendant(of: find.byType(InitialAvatar), matching: find.text('U')),
      findsOneWidget,
    );
    expect(find.text(testUser.email), findsOneWidget);
    expect(find.text('3 minutes ago'), findsOneWidget);
    expect(find.text('Hello there'), findsOneWidget);
    expect(find.text('like'), findsOneWidget);
  });
}
