import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/domain/entities/user.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:dartz/dartz.dart';

abstract class TweetLikeRepository {
  /// Records that [user] likes [tweet], or no longer does.
  Future<Either<TweetLikeFailure, Unit>> setLiked(
    Tweet tweet, {
    required User user,
    required bool liked,
  });
}
