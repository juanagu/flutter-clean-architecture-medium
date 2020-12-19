import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app/src/abstractions/failures/failure.dart';

part 'tweet_like_result.freezed.dart';

@freezed
abstract class TweetLikeResult extends Failure with _$TweetLikeResult {
  const factory TweetLikeResult.sent(Tweet tweet) = Sent;
}
