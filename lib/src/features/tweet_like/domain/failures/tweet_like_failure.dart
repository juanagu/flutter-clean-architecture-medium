import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app/src/abstractions/failures/failure.dart';

part 'tweet_like_failure.freezed.dart';

@freezed
abstract class TweetLikeFailure extends Failure with _$TweetLikeFailure {
  const factory TweetLikeFailure.unexpectedError() = UnexpectedError;
}
