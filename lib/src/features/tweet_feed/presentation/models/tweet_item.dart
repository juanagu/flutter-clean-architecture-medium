import 'package:app/src/core/domain/entities/tweet.dart';

class TweetItem {
  TweetItem(
    this.tweet,
    this.timeAgo,
    this.ownerEmail,
  );
  final Tweet tweet;
  final String timeAgo;
  final String ownerEmail;

  String get content => tweet.content;
}
