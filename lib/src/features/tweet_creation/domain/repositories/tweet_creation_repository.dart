import 'package:app/src/features/tweet_creation/domain/entities/tweet_draft.dart';
import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:dartz/dartz.dart';

abstract class TweetCreationRepository {
  Future<Either<TweetCreationFailure, Unit>> create(TweetDraft draft);
}
