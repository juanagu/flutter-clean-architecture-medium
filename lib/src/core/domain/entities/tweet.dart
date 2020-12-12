import 'package:app/src/core/domain/entities/user.dart';

class Tweet {
  final String id;
  final String content;
  final int likes;
  final User createdUser;
  final DateTime createdDateTime;

  Tweet(
    this.id,
    this.content,
    this.likes,
    this.createdUser,
    this.createdDateTime,
  );
}
