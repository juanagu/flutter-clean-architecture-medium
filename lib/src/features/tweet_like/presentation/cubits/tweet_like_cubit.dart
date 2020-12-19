import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/tweet_like_use_case.dart';
import 'package:app/src/features/tweet_like/presentation/cubits/tweet_like_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
export 'tweet_like_state.dart';
import 'package:meta/meta.dart';

class TweeLikeCubit extends Cubit<TweetLikeState> {
  Tweet _tweet;
  final TweetLikeUseCase _tweetLikeUseCase;

  TweeLikeCubit({
    @required Tweet tweet,
    @required TweetLikeUseCase tweetLikeUseCase,
  })  : _tweet = tweet,
        _tweetLikeUseCase = tweetLikeUseCase,
        super(TweetLikeState.initial());

  Future<void> changeLike() async {
    emit(TweetLikeState.sending());
    final either = await _tweetLikeUseCase.execute(_tweet);
    either.fold(
      (error) => emit(TweetLikeState.unexpectedError()),
      (success) {
        _tweet = success.tweet;
        emit(TweetLikeState.sent(_tweet.likeIt));
      },
    );
  }
}
