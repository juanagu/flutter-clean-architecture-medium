import 'dart:async';

import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/tweet_feed_use_case.dart';
import 'package:app/src/features/tweet_feed/presentation/cubits/tweet_feed_state.dart';
import 'package:app/src/features/tweet_feed/presentation/mappers/tweet_item_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'tweet_feed_state.dart';

class TweetFeedCubit extends Cubit<TweetFeedState> {
  TweetFeedCubit({
    required this._tweetFeedUseCase,
    required this._tweetItemMapper,
    required this._logger,
  }) : super(const TweetFeedInitial());

  final TweetFeedUseCase _tweetFeedUseCase;
  final TweetItemMapper _tweetItemMapper;
  final Logger _logger;
  StreamSubscription<List<Tweet>>? _subscription;
  String _languageCode = 'en';

  /// Starts (or restarts) listening to the feed. [languageCode] drives the
  /// relative time strings, which have no access to the widget tree.
  void subscribe({required String languageCode}) {
    _languageCode = languageCode;
    emit(const TweetFeedLoading());
    unawaited(_subscription?.cancel());
    _subscription = _tweetFeedUseCase.execute().listen(
      _onTweets,
      onError: _onError,
    );
  }

  void _onTweets(List<Tweet> tweets) {
    if (tweets.isEmpty) {
      emit(const TweetFeedEmpty());
      return;
    }
    emit(
      TweetFeedFound(
        _tweetItemMapper.fromTweetList(tweets, languageCode: _languageCode),
      ),
    );
  }

  Future<void> _onError(Object error, StackTrace stackTrace) async {
    await _logger.recordError(error, stackTrace);
    if (!isClosed) emit(const TweetFeedUnexpectedError());
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
