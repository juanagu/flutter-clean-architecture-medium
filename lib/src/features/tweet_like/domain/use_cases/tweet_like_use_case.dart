import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:dartz/dartz.dart';

abstract class TweetLikeUseCase {
  Future<Either<TweetLikeFailure, Tweet>> execute(Tweet tweet);
}
