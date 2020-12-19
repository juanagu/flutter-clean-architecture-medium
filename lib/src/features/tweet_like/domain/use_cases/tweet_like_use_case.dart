import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_result.dart';
import 'package:dartz/dartz.dart';

abstract class TweetLikeUseCase {
  Future<Either<TweetLikeFailure, TweetLikeResult>> execute(Tweet tweet);
}
