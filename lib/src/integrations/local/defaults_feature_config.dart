import 'package:app/src/abstractions/features/feature_config.dart';

/// Answers from a fixed map. Used where Remote Config is unavailable.
class DefaultsFeatureConfig implements FeatureConfig {
  const DefaultsFeatureConfig({required this._defaults});

  final Map<String, bool> _defaults;

  @override
  Future<bool> isEnabled(String key) async => _defaults[key] ?? false;
}
