import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/presentation/formatters/relative_time_formatter.dart';
import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';

class TweetItemMapper {
  const TweetItemMapper({required this._relativeTimeFormatter});

  final RelativeTimeFormatter _relativeTimeFormatter;

  TweetItem fromTweet(Tweet tweet, {required String languageCode}) {
    return TweetItem(
      tweet: tweet,
      timeAgo: _relativeTimeFormatter.format(
        tweet.creationDate,
        languageCode: languageCode,
      ),
    );
  }

  List<TweetItem> fromTweetList(
    List<Tweet> tweets, {
    required String languageCode,
  }) {
    return tweets
        .map((tweet) => fromTweet(tweet, languageCode: languageCode))
        .toList();
  }
}
