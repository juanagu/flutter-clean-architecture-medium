import 'package:app/src/core/domain/entities/tweet.dart';

class TweetItem {
  final Tweet tweet;
  final String timeAgo;
  final String ownerEmail;

  TweetItem(
    this.tweet,
    this.timeAgo,
    this.ownerEmail,
  );

  String get content => tweet.content;
}
