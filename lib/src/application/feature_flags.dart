/// Feature-toggle keys and the value each takes when the remote source is
/// unavailable. The strings match the parameters defined in Firebase Remote
/// Config, so renaming one here means renaming it there.
abstract final class FeatureFlags {
  static const String appIsActive = 'appIsActive';
  static const String signUp = 'signUpFeatureIsActive';
  static const String tweetCreation = 'tweetCreationIsActive';

  static const Map<String, bool> defaults = {
    appIsActive: true,
    signUp: true,
    tweetCreation: true,
  };
}
