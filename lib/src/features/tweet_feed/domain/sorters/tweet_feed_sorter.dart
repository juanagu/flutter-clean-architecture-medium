import 'package:app/src/core/domain/entities/tweet.dart';

abstract class TweetFeedSorter {
  /// Returns a new list; the input is left untouched.
  List<Tweet> sort(List<Tweet> tweets);
}
