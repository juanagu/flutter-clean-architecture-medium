import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/repositories/tweet_feed_repository.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/tweet_feed_use_case.dart';

class SortedTweetFeedUseCase implements TweetFeedUseCase {
  const SortedTweetFeedUseCase({
    required this._tweetFeedRepository,
    required this._tweetFeedSorter,
  });

  final TweetFeedRepository _tweetFeedRepository;
  final TweetFeedSorter _tweetFeedSorter;

  @override
  Stream<List<Tweet>> execute() {
    return _tweetFeedRepository.watch().map(_tweetFeedSorter.sort);
  }
}
