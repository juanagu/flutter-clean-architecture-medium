import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';

sealed class TweetLikeState {
  const TweetLikeState(this.tweet);

  /// The tweet as the UI should show it, including an optimistic like.
  final Tweet tweet;
}

class TweetLikeIdle extends TweetLikeState {
  const TweetLikeIdle(super.tweet);
}

class TweetLikeSending extends TweetLikeState {
  const TweetLikeSending(super.tweet);
}

class TweetLikeFailed extends TweetLikeState {
  const TweetLikeFailed(super.tweet, this.failure);

  final TweetLikeFailure failure;
}
