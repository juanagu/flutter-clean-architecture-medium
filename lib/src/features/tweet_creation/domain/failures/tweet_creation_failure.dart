import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app/src/abstractions/failures/failure.dart';

part 'tweet_creation_failure.freezed.dart';

@freezed
abstract class TweetCreationFailure extends Failure
    with _$TweetCreationFailure {
  const factory TweetCreationFailure.unexpectedError() = UnexpectedError;
}
