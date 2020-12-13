import 'package:app/src/core/domain/entities/user.dart';

class Tweet {
  final String content;
  final DateTime creationDate;
  final User owner;
  final int likes;

  Tweet(
    this.content,
    this.owner,
    this.creationDate,
    this.likes,
  );

  factory Tweet.createNew(String content, User owner) {
    return Tweet(
      content,
      owner,
      DateTime.now().toUtc(),
      0,
    );
  }
}
