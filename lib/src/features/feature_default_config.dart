import 'package:app/src/features/sign_up/sign_up_feature.dart';
import 'package:app/src/features/tweet_creation/tweet_creation_feature.dart';

import 'auth/auth_index_feature.dart';

abstract class FeatureDefaultConfig {
  static Map<String, dynamic> value = {
    AuthIndexFeature.key: true,
    SignUpFeature.key: true,
    TweetCreationFeature.key: true,
  };
}
