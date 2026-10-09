import 'dart:async';

import 'package:app/src/core/data/tweet_document.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/data/remote/tweet_like_remote_repository.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/toggle_tweet_like_use_case.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/tweet_like_use_case.dart';
import 'package:app/src/features/tweet_like/presentation/cubits/tweet_like_cubit.dart';
import 'package:app/src/integrations/in_memory/in_memory_data_remote_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

class _ControlledUseCase implements TweetLikeUseCase {
  final Completer<Either<TweetLikeFailure, Tweet>> completer = Completer();
  int calls = 0;

  @override
  Future<Either<TweetLikeFailure, Tweet>> execute(Tweet tweet) {
    calls++;
    return completer.future;
  }
}

void main() {
  group('ToggleTweetLikeUseCase + remote repository', () {
    late InMemoryDataRemoteClient client;
    late ToggleTweetLikeUseCase useCase;

    setUp(() {
      client = InMemoryDataRemoteClient(
        seed: {
          TweetDocument.collection: [
            makeRemoteTweet('t1', likedBy: ['someone-else']),
          ],
        },
      );
      useCase = ToggleTweetLikeUseCase(
        tweetLikeRepository: TweetLikeRemoteRepository(
          dataRemoteClient: client,
          logger: RecordingLogger(),
        ),
        userSessionRepository: FixedUserSessionRepository(testUser),
      );
    });

    Future<Tweet> stored() async {
      final documents = await client
          .watch(TweetDocument.collection, orderBy: TweetDocument.creationDate)
          .first;
      return TweetDocument.fromRemote(
        documents.single,
        currentUserId: testUser.id,
      );
    }

    test(
      'liking adds the user to likedBy and returns the toggled tweet',
      () async {
        final result = await useCase.execute(makeTweet(id: 't1', likes: 1));

        expect(result.isRight(), isTrue);
        final tweet = await stored();
        expect(tweet.likeIt, isTrue);
        expect(tweet.likes, 2);
      },
    );

    test('unliking removes the user and never goes below the others', () async {
      await useCase.execute(makeTweet(id: 't1', likes: 1));

      await useCase.execute(makeTweet(id: 't1', likes: 2, likeIt: true));

      final tweet = await stored();
      expect(tweet.likeIt, isFalse);
      expect(tweet.likes, 1);
    });

    test('fails without a session and writes nothing', () async {
      final anonymous = ToggleTweetLikeUseCase(
        tweetLikeRepository: TweetLikeRemoteRepository(
          dataRemoteClient: client,
          logger: RecordingLogger(),
        ),
        userSessionRepository: FixedUserSessionRepository(null),
      );

      final result = await anonymous.execute(makeTweet(id: 't1'));

      expect(
        result,
        left<TweetLikeFailure, Tweet>(const TweetLikeUnauthenticated()),
      );
      expect((await stored()).likes, 1);
    });
  });

  group('TweetLikeCubit', () {
    test(
      'shows the like optimistically, then settles on the stored tweet',
      () async {
        final useCase = _ControlledUseCase();
        final cubit = TweetLikeCubit(
          tweet: makeTweet(likes: 1),
          useCase: useCase,
        );

        final toggling = cubit.toggle();
        expect(cubit.state, isA<TweetLikeSending>());
        expect(cubit.state.tweet.likeIt, isTrue);
        expect(cubit.state.tweet.likes, 2);

        useCase.completer.complete(right(makeTweet(likes: 2, likeIt: true)));
        await toggling;

        expect(cubit.state, isA<TweetLikeIdle>());
        expect(cubit.state.tweet.likes, 2);
      },
    );

    test('rolls back on failure and carries the failure', () async {
      final useCase = _ControlledUseCase();
      final cubit = TweetLikeCubit(
        tweet: makeTweet(likes: 1),
        useCase: useCase,
      );

      final toggling = cubit.toggle();
      useCase.completer.complete(left(const TweetLikeUnexpectedError()));
      await toggling;

      expect(
        cubit.state,
        isA<TweetLikeFailed>().having(
          (state) => state.failure,
          'failure',
          isA<TweetLikeUnexpectedError>(),
        ),
      );
      expect(cubit.state.tweet.likeIt, isFalse);
      expect(cubit.state.tweet.likes, 1);
    });

    test('ignores a toggle while one is in flight', () async {
      final useCase = _ControlledUseCase();
      final cubit = TweetLikeCubit(tweet: makeTweet(), useCase: useCase);

      final first = cubit.toggle();
      await cubit.toggle();
      useCase.completer.complete(right(makeTweet(likeIt: true, likes: 1)));
      await first;

      expect(useCase.calls, 1);
    });

    test(
      'adopts a newer tweet from the feed unless a like is in flight',
      () async {
        final useCase = _ControlledUseCase();
        final cubit = TweetLikeCubit(
          tweet: makeTweet(likes: 1),
          useCase: useCase,
        );

        cubit.sync(makeTweet(likes: 5));
        expect(cubit.state.tweet.likes, 5);

        final toggling = cubit.toggle();
        cubit.sync(makeTweet(likes: 9));
        expect(cubit.state.tweet.likes, 6);

        useCase.completer.complete(right(makeTweet(likes: 6, likeIt: true)));
        await toggling;
      },
    );
  });
}
