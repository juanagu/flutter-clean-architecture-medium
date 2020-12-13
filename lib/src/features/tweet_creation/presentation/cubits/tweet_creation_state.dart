import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweet_creation_state.freezed.dart';

@freezed
abstract class TweetCreationState with _$TweetCreationState {
  const factory TweetCreationState.initial() = Initial;

  const factory TweetCreationState.tweeting() = Tweeting;

  const factory TweetCreationState.tweeted() = Tweeted;

  const factory TweetCreationState.unexpectedError() = UnexpectedError;
}
