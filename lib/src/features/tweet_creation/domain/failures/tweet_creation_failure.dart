import 'package:app/src/abstractions/failures/failure.dart';

sealed class TweetCreationFailure extends Failure {
  const TweetCreationFailure();
}

class TweetCreationUnauthenticated extends TweetCreationFailure {
  const TweetCreationUnauthenticated();
}

class TweetCreationUnexpectedError extends TweetCreationFailure {
  const TweetCreationUnexpectedError();
}
