import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';
import 'package:meta/meta.dart';

class TweetQualificatorToSorter implements TweetFeedSorter {
  static const int LimitToSort = 500;
  final TweetFeedSorter _sorter;

  TweetQualificatorToSorter({@required TweetFeedSorter sorter})
      : _sorter = sorter;

  @override
  List<Tweet> sort(List<Tweet> tweets) {
    if (tweets.length <= LimitToSort) {
      return _sorter.sort(tweets);
    }

    var firstTweets = tweets.sublist(0, LimitToSort - 1);
    var lastTweets = tweets.sublist(LimitToSort, tweets.length - 1);

    var sorted = _sorter.sort(firstTweets);

    return [
      ...sorted,
      ...lastTweets,
    ];
  }
}
