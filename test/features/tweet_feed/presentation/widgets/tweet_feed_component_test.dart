import 'dart:async';

import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/tweet_feed_use_case.dart';
import 'package:app/src/features/tweet_feed/presentation/cubits/tweet_feed_cubit.dart';
import 'package:app/src/features/tweet_feed/presentation/mappers/tweet_item_mapper.dart';
import 'package:app/src/features/tweet_feed/presentation/widgets/tweet_feed_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';
import '../../../../support/localized.dart';

class _StreamUseCase implements TweetFeedUseCase {
  final StreamController<List<Tweet>> controller = StreamController.broadcast();

  @override
  Stream<List<Tweet>> execute() => controller.stream;
}

void main() {
  late _StreamUseCase useCase;

  setUp(() => useCase = _StreamUseCase());
  tearDown(() => useCase.controller.close());

  Widget component() {
    return TweetFeedComponent(
      createCubit: () => TweetFeedCubit(
        tweetFeedUseCase: useCase,
        tweetItemMapper: const TweetItemMapper(
          relativeTimeFormatter: FixedRelativeTimeFormatter('5 min ago'),
        ),
        logger: RecordingLogger(),
      ),
      likeActionBuilder: (tweet) => Text('like ${tweet.id}'),
    );
  }

  testWidgets('shows a spinner, then the rows with their like action', (
    tester,
  ) async {
    await pumpLocalized(tester, component());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    useCase.controller.add([makeTweet(id: 't1', content: 'First!')]);
    await tester.pump();
    await tester.pump();

    expect(find.text('First!'), findsOneWidget);
    expect(find.text('5 min ago'), findsOneWidget);
    expect(find.text(testUser.email), findsOneWidget);
    expect(find.text('like t1'), findsOneWidget);
  });

  testWidgets('shows the empty state', (tester) async {
    final i18n = await pumpLocalized(tester, component());

    useCase.controller.add([]);
    await tester.pump();
    await tester.pump();

    expect(
      find.text(i18n.translate('tweet_feed_feature.empty_message')),
      findsOneWidget,
    );
  });

  testWidgets('shows the error state with a retry that resubscribes', (
    tester,
  ) async {
    final i18n = await pumpLocalized(tester, component());

    useCase.controller.addError(StateError('offline'));
    await tester.pump();
    await tester.pump();
    expect(
      find.text(i18n.translate('tweet_feed_feature.unexpected_message')),
      findsOneWidget,
    );

    await tester.tap(find.text(i18n.translate('retry_button_title')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
