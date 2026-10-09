import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/bounded_tweet_feed_sorter.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/insertion_tweet_feed_sorter.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';

List<Tweet> _tweets(int count) {
  return List.generate(
    count,
    (index) => makeTweet(
      id: '$index',
      creationDate: DateTime.utc(2024, 1, 1).add(Duration(minutes: index)),
    ),
  );
}

void main() {
  group('InsertionTweetFeedSorter', () {
    const sorter = InsertionTweetFeedSorter();

    test('sorts newest first', () {
      final shuffled = _tweets(20)..shuffle();

      final sorted = sorter.sort(shuffled);

      expect(
        sorted.map((tweet) => tweet.id),
        _tweets(20).reversed.map((t) => t.id),
      );
    });

    test('does not mutate its input', () {
      final input = _tweets(5);
      final snapshot = List.of(input);

      sorter.sort(input);

      expect(input, snapshot);
    });

    test('handles empty and single-element lists', () {
      expect(sorter.sort([]), isEmpty);
      expect(sorter.sort([makeTweet()]), [makeTweet()]);
    });
  });

  group('BoundedTweetFeedSorter', () {
    test('delegates fully when under the limit', () {
      final sorter = BoundedTweetFeedSorter(
        sorter: _ReversingSorter(),
        limit: 5,
      );

      final sorted = sorter.sort(_tweets(3));

      expect(sorted.map((t) => t.id), ['2', '1', '0']);
    });

    test('sorts only the first `limit` tweets and keeps every element', () {
      final sorter = BoundedTweetFeedSorter(
        sorter: _ReversingSorter(),
        limit: 3,
      );

      final sorted = sorter.sort(_tweets(6));

      expect(sorted.map((t) => t.id), ['2', '1', '0', '3', '4', '5']);
      expect(sorted, hasLength(6));
    });
  });
}

class _ReversingSorter implements TweetFeedSorter {
  @override
  List<Tweet> sort(List<Tweet> tweets) => tweets.reversed.toList();
}
