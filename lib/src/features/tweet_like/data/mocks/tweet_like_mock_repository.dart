import 'package:app/src/features/tweet_like/domain/failures/tweet_like_result.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/repositories/tweet_like_repository.dart';
import 'package:dartz/dartz.dart';

class TweetLikeMockRepository implements TweetLikeRepository {
  @override
  Future<Either<TweetLikeFailure, TweetLikeResult>> update(Tweet tweet) async {
    await Future.delayed(Duration(seconds: 1));

    return right(TweetLikeResult.sent(tweet));
  }
}
