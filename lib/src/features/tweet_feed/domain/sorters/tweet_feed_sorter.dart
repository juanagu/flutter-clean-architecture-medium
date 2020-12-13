import 'package:app/src/core/domain/entities/tweet.dart';

abstract class TweetFeedSorter {
  List<Tweet> sort(List<Tweet> tweets);
}
