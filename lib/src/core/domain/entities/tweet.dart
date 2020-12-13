import 'package:app/src/core/domain/entities/user.dart';

class Tweet {
  final String id;
  final String content;
  final int likes;
  final User owner;
  final DateTime creationDate;

  Tweet(
    this.id,
    this.content,
    this.likes,
    this.owner,
    this.creationDate,
  );
}
