import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';

sealed class TweetFeedState {
  const TweetFeedState();
}

class TweetFeedInitial extends TweetFeedState {
  const TweetFeedInitial();
}

class TweetFeedLoading extends TweetFeedState {
  const TweetFeedLoading();
}

class TweetFeedFound extends TweetFeedState {
  const TweetFeedFound(this.items);

  final List<TweetItem> items;
}

class TweetFeedEmpty extends TweetFeedState {
  const TweetFeedEmpty();
}

class TweetFeedUnexpectedError extends TweetFeedState {
  const TweetFeedUnexpectedError();
}
