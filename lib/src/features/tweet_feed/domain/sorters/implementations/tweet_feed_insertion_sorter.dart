import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';

class TweetFeedInsertionSorter implements TweetFeedSorter {
  @override
  List<Tweet> sort(List<Tweet> tweets) {
    var end = tweets.length;
    var start = 0;
    for (var pos = start + 1; pos < end; pos++) {
      var min = start;
      var max = pos;
      var element = tweets[pos];
      while (min < max) {
        var mid = min + ((max - min) >> 1);
        var comparison = element.compareTo(tweets[mid]);
        if (comparison < 0) {
          max = mid;
        } else {
          min = mid + 1;
        }
      }
      tweets.setRange(min + 1, pos + 1, tweets, min);
      tweets[min] = element;
    }

    return tweets;
  }
}
