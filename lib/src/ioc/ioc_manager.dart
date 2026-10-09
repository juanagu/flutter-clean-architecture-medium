import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/application/feature_flags.dart';
import 'package:app/src/core/data/auth_client_user_session_repository.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/core/presentation/formatters/relative_time_formatter.dart';
import 'package:app/src/integrations/firebase/firebase_auth_client.dart';
import 'package:app/src/integrations/firebase/firebase_crashlytics_logger.dart';
import 'package:app/src/integrations/firebase/firebase_data_remote_client.dart';
import 'package:app/src/integrations/firebase/firebase_remote_feature_config.dart';
import 'package:app/src/integrations/get_it/get_it_injector.dart';
import 'package:app/src/integrations/in_memory/in_memory_auth_client.dart';
import 'package:app/src/integrations/in_memory/in_memory_data_remote_client.dart';
import 'package:app/src/integrations/in_memory/in_memory_seed.dart';
import 'package:app/src/integrations/local/defaults_feature_config.dart';
import 'package:app/src/integrations/local/developer_log_logger.dart';
import 'package:app/src/integrations/timeago/timeago_relative_time_formatter.dart';
import 'package:flutter/foundation.dart';

/// App-wide composition root: binds every port to the adapter for the
/// backend the app runs against.
abstract final class IocManager {
  /// `--dart-define=IN_MEMORY_BACKEND=true` runs the app without Firebase.
  static const bool useInMemoryBackend = bool.fromEnvironment(
    'IN_MEMORY_BACKEND',
  );

  static Injector register() {
    final injector = Injector.register(GetItInjector());

    if (useInMemoryBackend) {
      _registerInMemory(injector);
    } else {
      _requireFirebaseSupport();
      _registerFirebase(injector);
    }
    _registerCommons(injector);

    return injector;
  }

  /// Firebase on web needs generated options that this repo does not ship,
  /// so a web build without the in-memory backend stops here with a message
  /// instead of failing deep inside `Firebase.initializeApp`.
  static void _requireFirebaseSupport() {
    if (!kIsWeb) return;

    throw UnsupportedError(
      'Firebase is not configured for web. Run with '
      '--dart-define=IN_MEMORY_BACKEND=true, or run `flutterfire configure` '
      'and pass its options to Firebase.initializeApp (docs/development.md).',
    );
  }

  static void _registerFirebase(Injector injector) {
    injector
      ..registerLazySingleton<Logger>(FirebaseCrashlyticsLogger.new)
      ..registerLazySingleton<FeatureConfig>(
        () => FirebaseRemoteFeatureConfig(
          defaults: FeatureFlags.defaults,
          logger: injector.resolve<Logger>(),
        ),
      )
      ..registerLazySingleton<AuthClient>(FirebaseAuthClient.new)
      ..registerLazySingleton<DataRemoteClient>(FirebaseDataRemoteClient.new);
  }

  static void _registerInMemory(Injector injector) {
    injector
      ..registerLazySingleton<Logger>(DeveloperLogLogger.new)
      ..registerLazySingleton<FeatureConfig>(
        () => const DefaultsFeatureConfig(defaults: FeatureFlags.defaults),
      )
      ..registerLazySingleton<AuthClient>(
        () => InMemoryAuthClient(accounts: InMemorySeed.accounts()),
      )
      ..registerLazySingleton<DataRemoteClient>(
        () => InMemoryDataRemoteClient(seed: InMemorySeed.collections()),
      );
  }

  static void _registerCommons(Injector injector) {
    injector
      ..registerFactory<UserSessionRepository>(
        () => AuthClientUserSessionRepository(
          authClient: injector.resolve<AuthClient>(),
        ),
      )
      ..registerLazySingleton<RelativeTimeFormatter>(
        TimeagoRelativeTimeFormatter.new,
      );
  }
}
