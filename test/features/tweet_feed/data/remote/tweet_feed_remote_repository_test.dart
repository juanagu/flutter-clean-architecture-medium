import 'package:app/src/core/data/tweet_document.dart';
import 'package:app/src/features/tweet_feed/data/remote/tweet_feed_remote_repository.dart';
import 'package:app/src/integrations/in_memory/in_memory_data_remote_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';

void main() {
  late InMemoryDataRemoteClient client;

  setUp(() {
    client = InMemoryDataRemoteClient(
      seed: {
        TweetDocument.collection: [
          makeRemoteTweet(
            'old',
            creationDate: DateTime.utc(2024, 1, 1),
            likedBy: [testUser.id, 'someone-else'],
          ),
          makeRemoteTweet('new', creationDate: DateTime.utc(2024, 1, 2)),
        ],
      },
    );
  });

  test(
    'emits newest first with likes resolved for the signed-in user',
    () async {
      final repository = TweetFeedRemoteRepository(
        dataRemoteClient: client,
        userSessionRepository: FixedUserSessionRepository(testUser),
      );

      final tweets = await repository.watch().first;

      expect(tweets.map((tweet) => tweet.id), ['new', 'old']);
      expect(tweets.last.likes, 2);
      expect(tweets.last.likeIt, isTrue);
      expect(tweets.first.likeIt, isFalse);
    },
  );

  test('marks nothing as liked without a session', () async {
    final repository = TweetFeedRemoteRepository(
      dataRemoteClient: client,
      userSessionRepository: FixedUserSessionRepository(null),
    );

    final tweets = await repository.watch().first;

    expect(tweets.every((tweet) => !tweet.likeIt), isTrue);
    expect(tweets.last.likes, 2);
  });

  test('re-emits when a document changes', () async {
    final repository = TweetFeedRemoteRepository(
      dataRemoteClient: client,
      userSessionRepository: FixedUserSessionRepository(testUser),
    );
    final emissions = repository.watch().take(2).toList();
    await Future<void>.delayed(Duration.zero);

    await client.updateSet(
      TweetDocument.collection,
      'new',
      TweetDocument.likedBy,
      add: [testUser.id],
    );

    final latest = (await emissions).last;
    expect(latest.first.likeIt, isTrue);
  });
}
