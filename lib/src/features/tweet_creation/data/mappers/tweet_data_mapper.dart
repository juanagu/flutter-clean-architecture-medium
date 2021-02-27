import 'package:app/src/features/tweet_creation/domain/entities/tweet.dart';

class TweetDataMapper {
  TweetDataMapper(this.tweet);
  final Tweet tweet;

  Map<String, dynamic> toJson() {
    return {
      'content': tweet.content,
      'owner': {
        'id': tweet.owner.id,
        'email': tweet.owner.email,
      },
      'creationDate': tweet.creationDate.millisecondsSinceEpoch,
      'likes': tweet.likes,
    };
  }
}
