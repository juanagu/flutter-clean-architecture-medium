import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteFeatureConfig implements FeatureConfig {
  FirebaseRemoteFeatureConfig({
    required this._defaults,
    required this._logger,
    this.fetchTimeout = const Duration(seconds: 10),
    this.minimumFetchInterval = const Duration(minutes: 1),
  });

  final Map<String, bool> _defaults;
  final Logger _logger;
  final Duration fetchTimeout;
  final Duration minimumFetchInterval;
  Future<void>? _ready;

  FirebaseRemoteConfig get _remoteConfig => FirebaseRemoteConfig.instance;

  @override
  Future<bool> isEnabled(String key) async {
    await _ensureReady();
    return _remoteConfig.getBool(key);
  }

  /// A failed setup is forgotten so the next call can retry it.
  Future<void> _ensureReady() => _ready ??= _init();

  Future<void> _init() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: fetchTimeout,
          minimumFetchInterval: minimumFetchInterval,
        ),
      );
      await _remoteConfig.setDefaults(_defaults);
    } catch (_) {
      _ready = null;
      rethrow;
    }
    await _fetchAndActivate();
  }

  /// A failed fetch is not fatal: the defaults set above still answer.
  Future<void> _fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (error, stackTrace) {
      await _logger.error('Remote Config fetch failed, using defaults');
      await _logger.recordError(error, stackTrace);
    }
  }
}
