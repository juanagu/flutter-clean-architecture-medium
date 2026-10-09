import 'package:app/src/abstractions/failures/failure.dart';

sealed class TweetLikeFailure extends Failure {
  const TweetLikeFailure();
}

class TweetLikeUnauthenticated extends TweetLikeFailure {
  const TweetLikeUnauthenticated();
}

class TweetLikeUnexpectedError extends TweetLikeFailure {
  const TweetLikeUnexpectedError();
}
