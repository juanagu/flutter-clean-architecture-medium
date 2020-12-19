import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweet_like_state.freezed.dart';

@freezed
abstract class TweetLikeState with _$TweetLikeState {
  const factory TweetLikeState.initial() = Initial;

  const factory TweetLikeState.disabled() = Disabled;

  const factory TweetLikeState.sending() = Sending;

  const factory TweetLikeState.sent(bool likeIt) = Sent;

  const factory TweetLikeState.unexpectedError() = Unexpectederror;
}
