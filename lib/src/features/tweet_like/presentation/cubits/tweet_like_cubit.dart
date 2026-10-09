import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/tweet_like_use_case.dart';
import 'package:app/src/features/tweet_like/presentation/cubits/tweet_like_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'tweet_like_state.dart';

class TweetLikeCubit extends Cubit<TweetLikeState> {
  TweetLikeCubit({required Tweet tweet, required this._useCase})
    : super(TweetLikeIdle(tweet));

  final TweetLikeUseCase _useCase;

  /// Adopts a newer version of the tweet from the feed, unless a like is in
  /// flight: then the optimistic value wins until the write settles.
  void sync(Tweet tweet) {
    if (state is TweetLikeSending) return;
    if (tweet == state.tweet) return;

    emit(TweetLikeIdle(tweet));
  }

  Future<void> toggle() async {
    if (state is TweetLikeSending) return;

    final before = state.tweet;
    emit(TweetLikeSending(before.toggleLike()));
    final result = await _useCase.execute(before);
    emit(
      result.fold(
        (failure) => TweetLikeFailed(before, failure),
        TweetLikeIdle.new,
      ),
    );
  }
}
