import 'dart:async';

import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/repositories/tweet_feed_repository.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/tweet_feed_use_case.dart';
import 'package:meta/meta.dart';

class V1TweetFeedUseCase implements TweetFeedUseCase {
  final TweetFeedRepository _tweetFeedRepository;
  final TweetFeedSorter _tweetFeedSorter;

  final StreamController<List<Tweet>> _controller =
      StreamController<List<Tweet>>();

  V1TweetFeedUseCase({
    @required TweetFeedRepository tweetFeedRepository,
    @required TweetFeedSorter tweetFeedSorter,
  })  : _tweetFeedRepository = tweetFeedRepository,
        _tweetFeedSorter = tweetFeedSorter;

  @override
  Stream<List<Tweet>> execute() {
    _tweetFeedRepository.fetch().listen((tweets) {
      final sorted = _tweetFeedSorter.sort(tweets);
      _controller.add(sorted);
    });
    return _controller.stream;
  }
}
