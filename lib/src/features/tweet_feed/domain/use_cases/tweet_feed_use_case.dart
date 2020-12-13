import 'package:app/src/core/domain/entities/tweet.dart';

abstract class TweetFeedUseCase {
  Stream<List<Tweet>> execute();
}
