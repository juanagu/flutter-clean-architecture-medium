import 'package:app/src/features/tweet_creation/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:dartz/dartz.dart';

abstract class TweetCreationRepository {
  Future<Either<TweetCreationFailure, bool>> create(Tweet tweet);
}
