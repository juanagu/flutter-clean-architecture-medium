import 'package:app/src/core/domain/entities/user.dart';

class Tweet implements Comparable {
  final String id;
  final String content;
  final int likes;
  final User owner;
  final DateTime creationDate;
  final bool likeIt;

  Tweet(
    this.id,
    this.content,
    this.likes,
    this.owner,
    this.creationDate, {
    this.likeIt = false,
  });

  @override
  int compareTo(other) {
    if (other is Tweet) {
      final compareCreationDate = other.creationDate.millisecondsSinceEpoch -
          creationDate.millisecondsSinceEpoch;
      final compareContent = content.length - other.content.length;
      final compareLikes = likes - other.likes;

      return compareCreationDate -
          compareContent * compareCreationDate -
          compareLikes;
    }

    return 0;
  }

  Tweet changeLike() {
    final _likeIt = !likeIt;
    final _likes = _likeIt ? likes + 1 : likes - 1;
    return Tweet(
      id,
      content,
      _likes,
      owner,
      creationDate,
      likeIt: _likeIt,
    );
  }
}
