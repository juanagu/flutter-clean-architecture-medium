import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweet_feed_state.freezed.dart';

@freezed
abstract class TweetFeedState with _$TweetFeedState {
  const factory TweetFeedState.initial() = Initial;

  const factory TweetFeedState.loading() = Loading;

  const factory TweetFeedState.found(List<TweetItem> items) = Found;

  const factory TweetFeedState.unexpectedError() = Unexpectederror;
}
