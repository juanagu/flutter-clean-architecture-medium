import 'package:app/src/features/tweet_feed/domain/use_cases/tweet_feed_use_case.dart';
import 'package:app/src/features/tweet_feed/presentation/cubits/tweet_feed_state.dart';
import 'package:app/src/features/tweet_feed/presentation/mappers/tweet_item_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
export 'tweet_feed_state.dart';

class TweetFeedCubit extends Cubit<TweetFeedState> {
  TweetFeedCubit({
    @required TweetFeedUseCase tweetFeedUseCase,
    @required TweetItemMapper tweetItemMapper,
  })  : _tweetFeedUseCase = tweetFeedUseCase,
        _tweetItemMapper = tweetItemMapper,
        super(const TweetFeedState.initial());

  final TweetFeedUseCase _tweetFeedUseCase;
  final TweetItemMapper _tweetItemMapper;

  void fetch() async {
    emit(const TweetFeedState.loading());
    _tweetFeedUseCase.execute().listen(
      (tweets) {
        if (tweets != null && tweets.isNotEmpty) {
          emit(TweetFeedState.found(_tweetItemMapper.fromTweetList(tweets)));
        }
      },
    );
  }
}
