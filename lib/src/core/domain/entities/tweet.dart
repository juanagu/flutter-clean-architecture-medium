import 'package:app/src/core/domain/entities/user.dart';

class Tweet implements Comparable<Tweet> {
  const Tweet({
    required this.id,
    required this.content,
    required this.likes,
    required this.owner,
    required this.creationDate,
    this.likeIt = false,
  });

  final String id;
  final String content;
  final int likes;
  final User owner;
  final DateTime creationDate;
  final bool likeIt;

  /// Feed order: newest first, most liked first among tweets of the same
  /// instant.
  @override
  int compareTo(Tweet other) {
    final byDate = other.creationDate.compareTo(creationDate);
    if (byDate != 0) return byDate;
    return other.likes.compareTo(likes);
  }

  Tweet toggleLike() {
    final nowLiked = !likeIt;
    return copyWith(likeIt: nowLiked, likes: nowLiked ? likes + 1 : likes - 1);
  }

  Tweet copyWith({int? likes, bool? likeIt}) {
    return Tweet(
      id: id,
      content: content,
      likes: likes ?? this.likes,
      owner: owner,
      creationDate: creationDate,
      likeIt: likeIt ?? this.likeIt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Tweet &&
      other.id == id &&
      other.content == content &&
      other.likes == likes &&
      other.owner == owner &&
      other.creationDate == creationDate &&
      other.likeIt == likeIt;

  @override
  int get hashCode =>
      Object.hash(id, content, likes, owner, creationDate, likeIt);
}
