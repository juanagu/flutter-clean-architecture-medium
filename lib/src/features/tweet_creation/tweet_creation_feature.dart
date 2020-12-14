import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/features/tweet_creation/data/remote/tweet_creation_remote_repository.dart';
import 'package:app/src/features/tweet_creation/domain/repositories/tweet_creation_repository.dart';
import 'package:app/src/features/tweet_creation/domain/use_cases/tweet_creation_use_case.dart';
import 'package:app/src/features/tweet_creation/domain/use_cases/implementations/tweet_creation_v1_use_case.dart';
import 'package:app/src/features/tweet_creation/presentation/cubits/tweet_creation_cubit.dart';
import 'package:app/src/features/tweet_creation/presentation/pages/tweet_creation_page.dart';
import 'package:flutter/material.dart';

import 'presentation/widgets/tweet_creation_floating_button.dart';

class TweetCreationFeature {
  static const String Route = '/tweet';
  static const String Key = 'tweetCreationIsActive';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {
      Route: (context) => TweetCreationFeature().buildPage(),
    };
  }

  static Future<dynamic> navigate(BuildContext context) {
    return Navigator.of(context).pushNamed(Route);
  }

  Widget buildPage() {
    return TweetCreationPage(
      cubit: _provideCubit(),
      onTweeted: (context) => Navigator.of(context).pop(),
    );
  }

  Widget buildFloatingButton() {
    return TweetCreationFloatingButton(
      featureConfig: Injector.instance.resolve<FeatureConfig>(),
    );
  }

  TweetCreationCubit _provideCubit() {
    return TweetCreationCubit(
      useCase: _provideUseCase(),
    );
  }

  TweetCreationUseCase _provideUseCase() {
    return TweetCreationV1UseCase(
      userSessionRepository: Injector.instance.resolve<UserSessionRepository>(),
      tweetCreationRepository: _provideRepository(),
    );
  }

  TweetCreationRepository _provideRepository() {
    final injector = Injector.instance;
    return TweetCreationRemoteRepository(
      dataRemoteClient: injector.resolve<DataRemoteClient>(),
      logger: injector.resolve<Logger>(),
    );
  }
}
