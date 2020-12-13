import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/presentation/helpers/time_ago_helper.dart';
import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';

import 'package:meta/meta.dart';

class TweetItemMapper {
  final TimeagoHelper _timeagoHelper;

  TweetItemMapper({@required TimeagoHelper timeagoHelper})
      : _timeagoHelper = timeagoHelper;

  TweetItem fromTweet(Tweet tweet) {
    return TweetItem(
      tweet,
      _timeagoHelper.format(tweet.creationDate),
      tweet.owner.email,
    );
  }

  List<TweetItem> fromTweetList(List<Tweet> tweets) {
    if (tweets == null) return [];

    return tweets.map(fromTweet).toList();
  }
}
