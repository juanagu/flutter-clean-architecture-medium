import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/features/tweet_like/data/remote/tweet_like_remote_repository.dart';
import 'package:app/src/features/tweet_like/domain/repositories/tweet_like_repository.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/toggle_tweet_like_use_case.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/tweet_like_use_case.dart';
import 'package:app/src/features/tweet_like/presentation/cubits/tweet_like_cubit.dart';
import 'package:app/src/features/tweet_like/presentation/widgets/tweet_like_button.dart';
import 'package:flutter/material.dart';

/// Composition root of the like control shown on every feed row.
class TweetLikeFeature {
  Widget build(Tweet tweet) {
    return TweetLikeButton(
      key: ValueKey('like-${tweet.id}'),
      tweet: tweet,
      createCubit: _provideCubit,
    );
  }

  TweetLikeCubit _provideCubit(Tweet tweet) {
    return TweetLikeCubit(tweet: tweet, useCase: _provideUseCase());
  }

  TweetLikeUseCase _provideUseCase() {
    return ToggleTweetLikeUseCase(
      tweetLikeRepository: _provideRepository(),
      userSessionRepository: Injector.instance.resolve<UserSessionRepository>(),
    );
  }

  TweetLikeRepository _provideRepository() {
    final injector = Injector.instance;
    return TweetLikeRemoteRepository(
      dataRemoteClient: injector.resolve<DataRemoteClient>(),
      logger: injector.resolve<Logger>(),
    );
  }
}
