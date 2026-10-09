import 'package:app/src/core/domain/entities/tweet.dart';

abstract class TweetFeedRepository {
  /// Emits the whole feed every time it changes. Errors are delivered on the
  /// stream.
  Stream<List<Tweet>> watch();
}
