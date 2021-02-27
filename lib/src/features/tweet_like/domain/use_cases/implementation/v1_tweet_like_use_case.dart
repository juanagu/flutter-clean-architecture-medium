import 'package:app/src/features/tweet_like/domain/failures/tweet_like_result.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/repositories/tweet_like_repository.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/tweet_like_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class V1TweetLikeUseCase implements TweetLikeUseCase {
  V1TweetLikeUseCase({
    @required TweetLikeRepository tweetLikeRepository,
  }) : _tweetLikeRepository = tweetLikeRepository;

  final TweetLikeRepository _tweetLikeRepository;

  @override
  Future<Either<TweetLikeFailure, TweetLikeResult>> execute(Tweet tweet) {
    return _tweetLikeRepository.update(tweet.changeLike());
  }
}
