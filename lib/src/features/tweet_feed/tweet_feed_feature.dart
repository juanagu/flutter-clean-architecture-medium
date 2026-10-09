import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/core/presentation/formatters/relative_time_formatter.dart';
import 'package:app/src/features/tweet_feed/data/remote/tweet_feed_remote_repository.dart';
import 'package:app/src/features/tweet_feed/domain/repositories/tweet_feed_repository.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/bounded_tweet_feed_sorter.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/insertion_tweet_feed_sorter.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/tweet_feed_sorter.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/sorted_tweet_feed_use_case.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/tweet_feed_use_case.dart';
import 'package:app/src/features/tweet_feed/presentation/cubits/tweet_feed_cubit.dart';
import 'package:app/src/features/tweet_feed/presentation/mappers/tweet_item_mapper.dart';
import 'package:app/src/features/tweet_feed/presentation/widgets/tweet_feed_component.dart';
import 'package:app/src/features/tweet_like/tweet_like_feature.dart';
import 'package:flutter/material.dart';

/// Composition root of the feed. Has no route of its own: the home screen
/// embeds it.
class TweetFeedFeature {
  Widget build() {
    return TweetFeedComponent(
      createCubit: _provideCubit,
      likeActionBuilder: TweetLikeFeature().build,
    );
  }

  TweetFeedCubit _provideCubit() {
    final injector = Injector.instance;
    return TweetFeedCubit(
      tweetFeedUseCase: _provideUseCase(injector),
      tweetItemMapper: TweetItemMapper(
        relativeTimeFormatter: injector.resolve<RelativeTimeFormatter>(),
      ),
      logger: injector.resolve<Logger>(),
    );
  }

  TweetFeedUseCase _provideUseCase(Injector injector) {
    return SortedTweetFeedUseCase(
      tweetFeedRepository: _provideRepository(injector),
      tweetFeedSorter: _provideSorter(),
    );
  }

  TweetFeedSorter _provideSorter() {
    return const BoundedTweetFeedSorter(sorter: InsertionTweetFeedSorter());
  }

  TweetFeedRepository _provideRepository(Injector injector) {
    return TweetFeedRemoteRepository(
      dataRemoteClient: injector.resolve<DataRemoteClient>(),
      userSessionRepository: injector.resolve<UserSessionRepository>(),
    );
  }
}
