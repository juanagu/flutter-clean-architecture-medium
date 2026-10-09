import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';

/// Sorts only the first [limit] tweets and appends the rest untouched, so a
/// very long feed never blocks the UI thread. The source already arrives in
/// date order, so the tail is close enough.
class BoundedTweetFeedSorter implements TweetFeedSorter {
  const BoundedTweetFeedSorter({
    required this._sorter,
    this.limit = defaultLimit,
  });

  static const int defaultLimit = 500;

  final TweetFeedSorter _sorter;
  final int limit;

  @override
  List<Tweet> sort(List<Tweet> tweets) {
    if (tweets.length <= limit) return _sorter.sort(tweets);

    return [
      ..._sorter.sort(tweets.sublist(0, limit)),
      ...tweets.sublist(limit),
    ];
  }
}
