import 'package:app/src/features/tweet_creation/domain/entities/tweet_draft.dart';
import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:app/src/features/tweet_creation/domain/repositories/tweet_creation_repository.dart';
import 'package:app/src/features/tweet_creation/domain/use_cases/authored_tweet_creation_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';

class _RecordingRepository implements TweetCreationRepository {
  final List<TweetDraft> drafts = [];

  @override
  Future<Either<TweetCreationFailure, Unit>> create(TweetDraft draft) async {
    drafts.add(draft);
    return right(unit);
  }
}

void main() {
  final now = DateTime(2024, 5, 6, 7, 8);

  test('stamps the draft with the signed-in user and the clock', () async {
    final repository = _RecordingRepository();
    final useCase = AuthoredTweetCreationUseCase(
      userSessionRepository: FixedUserSessionRepository(testUser),
      tweetCreationRepository: repository,
      clock: () => now,
    );

    final result = await useCase.execute('hello');

    expect(result.isRight(), isTrue);
    final draft = repository.drafts.single;
    expect(draft.content, 'hello');
    expect(draft.owner, testUser);
    expect(draft.creationDate, now.toUtc());
  });

  test('fails without a session and stores nothing', () async {
    final repository = _RecordingRepository();
    final useCase = AuthoredTweetCreationUseCase(
      userSessionRepository: FixedUserSessionRepository(null),
      tweetCreationRepository: repository,
    );

    final result = await useCase.execute('hello');

    expect(
      result,
      left<TweetCreationFailure, Unit>(const TweetCreationUnauthenticated()),
    );
    expect(repository.drafts, isEmpty);
  });
}
