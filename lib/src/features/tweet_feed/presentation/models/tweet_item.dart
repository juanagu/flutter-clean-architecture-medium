import 'package:app/src/core/domain/entities/tweet.dart';

/// What a feed row shows: the tweet plus its presentation-ready fields.
class TweetItem {
  const TweetItem({required this.tweet, required this.timeAgo});

  final Tweet tweet;
  final String timeAgo;

  String get content => tweet.content;

  String get ownerEmail => tweet.owner.email;
}
