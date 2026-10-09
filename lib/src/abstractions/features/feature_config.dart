/// Port over the feature-toggle source. Keys are listed in `FeatureFlags`.
abstract class FeatureConfig {
  Future<bool> isEnabled(String key);
}
