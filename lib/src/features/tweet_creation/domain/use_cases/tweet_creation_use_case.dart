import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:dartz/dartz.dart';

abstract class TweetCreationUseCase {
  Future<Either<TweetCreationFailure, bool>> execute(String content);
}
