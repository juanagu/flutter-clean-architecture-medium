import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:meta/meta.dart';

class FirebaseRemoteFeatureConfig implements FeatureConfig {
  final Map<String, dynamic> _defaultConfig;
  RemoteConfig _instance;

  FirebaseRemoteFeatureConfig({
    @required Map<String, dynamic> defaultConfig,
  }) : _defaultConfig = defaultConfig;

  @override
  Future<bool> isEnabled(String key) async {
    var remoteConfig = await _getInstance();
    return remoteConfig.getBool(key);
  }

  Future<RemoteConfig> _getInstance() async {
    await _init();
    return _instance;
  }

  Future<void> _init() async {
    if (_instance == null) {
      _instance = await RemoteConfig.instance;
      //await _instance.setConfigSettings(RemoteConfigSettings());

      await _instance.setDefaults(_defaultConfig);
      await _instance.fetch(expiration: Duration(minutes: 1));
      await _instance.activateFetched();
    }
  }
}
