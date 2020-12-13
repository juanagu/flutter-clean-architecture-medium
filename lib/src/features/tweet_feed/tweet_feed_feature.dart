import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/core/presentation/helpers/time_ago_helper.dart';
import 'package:app/src/features/tweet_feed/data/firebase/tweet_feed_firebase_repository.dart';
import 'package:app/src/features/tweet_feed/domain/repositories/tweet_feed_repository.dart';
import 'package:app/src/features/tweet_feed/domain/sorters/implementations/tweet_feed_insertion_sorter.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/implementaions/v1_tweet_feed_use_case.dart';
import 'package:app/src/features/tweet_feed/domain/use_cases/tweet_feed_use_case.dart';
import 'package:app/src/features/tweet_feed/presentation/cubits/tweet_feed_cubit.dart';
import 'package:app/src/features/tweet_feed/presentation/mappers/tweet_item_mapper.dart';
import 'package:flutter/material.dart';

import 'presentation/widgets/tweet_feed_component.dart';

class TweetFeedFeature {
  Widget build() {
    return Container(
      child: TweetFeedComponent(
        cubit: _provideCubit(),
      ),
    );
  }

  TweetFeedCubit _provideCubit() {
    return TweetFeedCubit(
      tweetFeedUseCase: _provideUseCase(),
      tweetItemMapper: provideMapper(),
    );
  }

  TweetFeedUseCase _provideUseCase() {
    return V1TweetFeedUseCase(
      tweetFeedRepository: _provideRepository(),
      tweetFeedSorter: _provideSorter(),
    );
  }

  TweetFeedInsertionSorter _provideSorter() => TweetFeedInsertionSorter();

  TweetItemMapper provideMapper() {
    return TweetItemMapper(
      timeagoHelper: Injector.instance.resolve<TimeagoHelper>(),
    );
  }

  TweetFeedRepository _provideRepository() {
    return TweetFeedFirebaseRepository();
  }
}
