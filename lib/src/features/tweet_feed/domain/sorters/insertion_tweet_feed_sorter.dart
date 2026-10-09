import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';

/// Binary insertion sort by [Tweet.compareTo]. Stable, and cheap on a feed
/// that arrives almost sorted.
class InsertionTweetFeedSorter implements TweetFeedSorter {
  const InsertionTweetFeedSorter();

  @override
  List<Tweet> sort(List<Tweet> tweets) {
    final sorted = List<Tweet>.of(tweets);
    for (var position = 1; position < sorted.length; position++) {
      final element = sorted[position];
      final insertAt = _insertionIndex(sorted, element, position);
      sorted.setRange(insertAt + 1, position + 1, sorted, insertAt);
      sorted[insertAt] = element;
    }
    return sorted;
  }

  int _insertionIndex(List<Tweet> sorted, Tweet element, int end) {
    var min = 0;
    var max = end;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      if (element.compareTo(sorted[mid]) < 0) {
        max = mid;
      } else {
        min = mid + 1;
      }
    }
    return min;
  }
}
