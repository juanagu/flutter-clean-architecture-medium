import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';
import 'package:meta/meta.dart';

class TweetQualificatorToSorter implements TweetFeedSorter {
  TweetQualificatorToSorter({@required TweetFeedSorter sorter})
      : _sorter = sorter;
  static const int limitToSort = 500;
  final TweetFeedSorter _sorter;

  @override
  List<Tweet> sort(List<Tweet> tweets) {
    if (tweets.length <= limitToSort) {
      return _sorter.sort(tweets);
    }

    var firstTweets = tweets.sublist(0, limitToSort - 1);
    var lastTweets = tweets.sublist(limitToSort, tweets.length - 1);

    var sorted = _sorter.sort(firstTweets);

    return [
      ...sorted,
      ...lastTweets,
    ];
  }
}
