import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/domain/entities/user.dart';

/// Schema of a tweet in the `tweets` collection. Shared by the feature that
/// writes tweets and the features that read them, so the field names have one
/// home. Likes are the set of user ids in [likedBy]; the count is derived.
abstract final class TweetDocument {
  static const String collection = 'tweets';
  static const String content = 'content';
  static const String owner = 'owner';
  static const String ownerId = 'id';
  static const String ownerEmail = 'email';
  static const String creationDate = 'creationDate';
  static const String likedBy = 'likedBy';

  static Map<String, dynamic> toJson({
    required String content,
    required User owner,
    required DateTime creationDate,
    List<String> likedBy = const [],
  }) {
    return {
      TweetDocument.content: content,
      TweetDocument.owner: {ownerId: owner.id, ownerEmail: owner.email},
      TweetDocument.creationDate: creationDate.millisecondsSinceEpoch,
      TweetDocument.likedBy: likedBy,
    };
  }

  /// [currentUserId] decides `likeIt`; null means nobody is signed in.
  static Tweet fromRemote(RemoteDocument document, {String? currentUserId}) {
    final data = document.data;
    final ownerData = data[owner] as Map<String, dynamic>? ?? const {};
    final likers = (data[likedBy] as List<Object?>?) ?? const [];
    return Tweet(
      id: document.id,
      content: data[content] as String? ?? '',
      likes: likers.length,
      likeIt: currentUserId != null && likers.contains(currentUserId),
      owner: User(
        id: ownerData[ownerId] as String? ?? '',
        email: ownerData[ownerEmail] as String? ?? '',
      ),
      creationDate: DateTime.fromMillisecondsSinceEpoch(
        data[creationDate] as int? ?? 0,
        isUtc: true,
      ),
    );
  }
}
