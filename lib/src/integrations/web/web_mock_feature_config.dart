import 'package:app/src/abstractions/features/feature_config.dart';

class WebMockFeatureConfig implements FeatureConfig {
  @override
  Future<bool> isEnabled(String key) async {
    return true;
  }
}
