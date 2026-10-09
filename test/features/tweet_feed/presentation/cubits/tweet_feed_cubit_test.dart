import 'dart:async';

import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/tweet_feed_use_case.dart';
import 'package:app/src/features/tweet_feed/presentation/cubits/tweet_feed_cubit.dart';
import 'package:app/src/features/tweet_feed/presentation/mappers/tweet_item_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';

class _StreamUseCase implements TweetFeedUseCase {
  final StreamController<List<Tweet>> controller = StreamController.broadcast();

  @override
  Stream<List<Tweet>> execute() => controller.stream;
}

void main() {
  late _StreamUseCase useCase;
  late RecordingLogger logger;
  late TweetFeedCubit cubit;

  setUp(() {
    useCase = _StreamUseCase();
    logger = RecordingLogger();
    cubit = TweetFeedCubit(
      tweetFeedUseCase: useCase,
      tweetItemMapper: const TweetItemMapper(
        relativeTimeFormatter: FixedRelativeTimeFormatter('2 min ago'),
      ),
      logger: logger,
    );
  });

  tearDown(() async {
    await cubit.close();
    await useCase.controller.close();
  });

  test('loads, then maps tweets into items', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<TweetFeedLoading>(),
        isA<TweetFeedFound>().having(
          (state) => state.items.single.timeAgo,
          'timeAgo',
          '2 min ago',
        ),
      ]),
    );

    cubit.subscribe(languageCode: 'en');
    useCase.controller.add([makeTweet()]);

    await expectation;
  });

  test('emits empty for an empty feed', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<TweetFeedLoading>(), isA<TweetFeedEmpty>()]),
    );

    cubit.subscribe(languageCode: 'en');
    useCase.controller.add([]);

    await expectation;
  });

  test('reports a stream error and logs it', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<TweetFeedLoading>(), isA<TweetFeedUnexpectedError>()]),
    );

    cubit.subscribe(languageCode: 'en');
    useCase.controller.addError(StateError('boom'));

    await expectation;
    expect(logger.errors.single, isA<StateError>());
  });

  test('cancels its subscription on close', () async {
    cubit.subscribe(languageCode: 'en');
    expect(useCase.controller.hasListener, isTrue);

    await cubit.close();

    expect(useCase.controller.hasListener, isFalse);
  });
}
