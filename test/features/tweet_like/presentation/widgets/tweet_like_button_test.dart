import 'dart:async';

import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/tweet_like_use_case.dart';
import 'package:app/src/features/tweet_like/presentation/cubits/tweet_like_cubit.dart';
import 'package:app/src/features/tweet_like/presentation/widgets/tweet_like_button.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';
import '../../../../support/localized.dart';

class _PendingUseCase implements TweetLikeUseCase {
  final Completer<Either<TweetLikeFailure, Tweet>> completer = Completer();

  @override
  Future<Either<TweetLikeFailure, Tweet>> execute(Tweet tweet) =>
      completer.future;
}

void main() {
  Widget button(Tweet tweet, _PendingUseCase useCase) {
    return TweetLikeButton(
      tweet: tweet,
      createCubit: (tweet) => TweetLikeCubit(tweet: tweet, useCase: useCase),
    );
  }

  testWidgets('hides the count at zero and shows it once liked', (
    tester,
  ) async {
    final useCase = _PendingUseCase();
    final i18n = await pumpLocalized(
      tester,
      button(makeTweet(likes: 0), useCase),
    );
    expect(find.text('0'), findsNothing);

    await tester.tap(find.byTooltip(i18n.translate('tweet_like_feature.like')));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(
      find.byTooltip(i18n.translate('tweet_like_feature.unlike')),
      findsOneWidget,
    );
    useCase.completer.complete(right(makeTweet(likes: 1, likeIt: true)));
    await tester.pump();
  });

  testWidgets('shows an existing count', (tester) async {
    await pumpLocalized(tester, button(makeTweet(likes: 3), _PendingUseCase()));

    expect(find.text('3'), findsOneWidget);
  });
}
