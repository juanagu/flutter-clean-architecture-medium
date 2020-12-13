import 'package:app/src/core/domain/entities/tweet.dart';

abstract class TweetFeedRepository {
  Stream<List<Tweet>> fetch();
}
