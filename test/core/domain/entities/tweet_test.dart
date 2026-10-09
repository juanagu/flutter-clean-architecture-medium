import 'package:flutter_test/flutter_test.dart';

import '../../../support/fakes.dart';

void main() {
  group('Tweet.compareTo', () {
    test('orders newest first', () {
      final older = makeTweet(id: 'a', creationDate: DateTime.utc(2024, 1, 1));
      final newer = makeTweet(id: 'b', creationDate: DateTime.utc(2024, 1, 2));

      expect(newer.compareTo(older), lessThan(0));
      expect(older.compareTo(newer), greaterThan(0));
    });

    test('orders most liked first among tweets of the same instant', () {
      final popular = makeTweet(id: 'a', likes: 10);
      final quiet = makeTweet(id: 'b', likes: 1);

      expect(popular.compareTo(quiet), lessThan(0));
      expect(quiet.compareTo(popular), greaterThan(0));
    });

    test('is zero for the same date and likes', () {
      expect(makeTweet(id: 'a').compareTo(makeTweet(id: 'b')), 0);
    });
  });

  group('Tweet.toggleLike', () {
    test('likes an unliked tweet and counts it', () {
      final liked = makeTweet(likes: 2).toggleLike();

      expect(liked.likeIt, isTrue);
      expect(liked.likes, 3);
    });

    test('unlikes a liked tweet and uncounts it', () {
      final unliked = makeTweet(likes: 3, likeIt: true).toggleLike();

      expect(unliked.likeIt, isFalse);
      expect(unliked.likes, 2);
    });

    test('keeps every other field', () {
      final original = makeTweet(id: 'x', content: 'body');

      expect(original.toggleLike().toggleLike(), original);
    });
  });
}
