import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/application/feature_flags.dart';
import 'package:app/src/application/widgets/feature_gate.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/features/tweet_creation/data/remote/tweet_creation_remote_repository.dart';
import 'package:app/src/features/tweet_creation/domain/repositories/tweet_creation_repository.dart';
import 'package:app/src/features/tweet_creation/domain/use_cases/authored_tweet_creation_use_case.dart';
import 'package:app/src/features/tweet_creation/domain/use_cases/tweet_creation_use_case.dart';
import 'package:app/src/features/tweet_creation/presentation/cubits/tweet_creation_cubit.dart';
import 'package:app/src/features/tweet_creation/presentation/pages/tweet_creation_page.dart';
import 'package:app/src/features/tweet_creation/presentation/widgets/tweet_creation_floating_button.dart';
import 'package:flutter/material.dart';

/// Composition root of the compose screen and of the button that opens it.
class TweetCreationFeature {
  static const String route = '/tweet';

  static Map<String, WidgetBuilder> generateRoutes() {
    return {route: (context) => TweetCreationFeature().buildPage()};
  }

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context).pushNamed(route);
  }

  Widget buildPage() {
    return TweetCreationPage(
      createCubit: _provideCubit,
      onTweeted: (context) => Navigator.of(context).pop(),
    );
  }

  /// Hidden while the tweet-creation toggle is off.
  Widget buildFloatingButton() {
    return FeatureGate(
      featureConfig: Injector.instance.resolve<FeatureConfig>(),
      flag: FeatureFlags.tweetCreation,
      child: const TweetCreationFloatingButton(onPressed: navigate),
    );
  }

  TweetCreationCubit _provideCubit() {
    return TweetCreationCubit(useCase: _provideUseCase());
  }

  TweetCreationUseCase _provideUseCase() {
    return AuthoredTweetCreationUseCase(
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
