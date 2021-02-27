import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/tweet_like_use_case.dart';
import 'package:app/src/features/tweet_like/presentation/cubits/tweet_like_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

export 'tweet_like_state.dart';

class TweeLikeCubit extends Cubit<TweetLikeState> {
  TweeLikeCubit({
    @required Tweet tweet,
    @required TweetLikeUseCase tweetLikeUseCase,
  })  : _tweet = tweet,
        _tweetLikeUseCase = tweetLikeUseCase,
        super(const TweetLikeState.initial());

  Tweet _tweet;
  final TweetLikeUseCase _tweetLikeUseCase;

  Future<void> changeLike() async {
    emit(const TweetLikeState.sending());
    final either = await _tweetLikeUseCase.execute(_tweet);
    either.fold(
      (error) => emit(const TweetLikeState.unexpectedError()),
      (success) {
        _tweet = success.tweet;
        emit(TweetLikeState.sent(_tweet.likeIt));
      },
    );
  }
}
