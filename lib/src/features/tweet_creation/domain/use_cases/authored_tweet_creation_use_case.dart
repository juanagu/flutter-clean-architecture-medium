import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/features/tweet_creation/domain/entities/tweet_draft.dart';
import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:app/src/features/tweet_creation/domain/repositories/tweet_creation_repository.dart';
import 'package:app/src/features/tweet_creation/domain/use_cases/tweet_creation_use_case.dart';
import 'package:dartz/dartz.dart';

typedef Clock = DateTime Function();

/// Stamps the draft with the signed-in user and the current time, then stores
/// it.
class AuthoredTweetCreationUseCase implements TweetCreationUseCase {
  AuthoredTweetCreationUseCase({
    required this._userSessionRepository,
    required this._tweetCreationRepository,
    this._clock = DateTime.now,
  });

  final UserSessionRepository _userSessionRepository;
  final TweetCreationRepository _tweetCreationRepository;
  final Clock _clock;

  @override
  Future<Either<TweetCreationFailure, Unit>> execute(String content) async {
    final currentUser = await _userSessionRepository.getCurrentUser();
    if (currentUser == null) {
      return left(const TweetCreationUnauthenticated());
    }

    final draft = TweetDraft(
      content: content,
      owner: currentUser,
      creationDate: _clock().toUtc(),
    );
    return _tweetCreationRepository.create(draft);
  }
}
