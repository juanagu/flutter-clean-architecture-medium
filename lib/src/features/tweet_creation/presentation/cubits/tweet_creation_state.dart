import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';

sealed class TweetCreationState {
  const TweetCreationState();
}

class TweetCreationInitial extends TweetCreationState {
  const TweetCreationInitial();
}

class TweetCreationTweeting extends TweetCreationState {
  const TweetCreationTweeting();
}

class TweetCreationTweeted extends TweetCreationState {
  const TweetCreationTweeted();
}

class TweetCreationFailed extends TweetCreationState {
  const TweetCreationFailed(this.failure);

  final TweetCreationFailure failure;
}
