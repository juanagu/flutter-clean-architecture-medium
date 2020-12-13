import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/features/tweet_creation/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:app/src/features/tweet_creation/domain/repositories/tweet_creation_repository.dart';
import 'package:app/src/features/tweet_creation/domain/use_cases/tweet_creation_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class TweetCreationV1UseCase implements TweetCreationUseCase {
  final UserSessionRepository _userSessionRepository;
  final TweetCreationRepository _tweetCreationRepository;

  TweetCreationV1UseCase({
    @required UserSessionRepository userSessionRepository,
    @required TweetCreationRepository tweetCreationRepository,
  })  : _userSessionRepository = userSessionRepository,
        _tweetCreationRepository = tweetCreationRepository;

  @override
  Future<Either<TweetCreationFailure, bool>> execute(String content) async {
    var currentUser = await _userSessionRepository.getCurrentUser();

    var tweet = Tweet.createNew(content, currentUser);
    return await _tweetCreationRepository.create(tweet);
  }
}
