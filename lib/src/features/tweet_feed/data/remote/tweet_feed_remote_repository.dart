import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/core/data/tweet_document.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/features/tweet_feed/domain/repositories/tweet_feed_repository.dart';

class TweetFeedRemoteRepository implements TweetFeedRepository {
  const TweetFeedRemoteRepository({
    required this._dataRemoteClient,
    required this._userSessionRepository,
  });

  final DataRemoteClient _dataRemoteClient;
  final UserSessionRepository _userSessionRepository;

  /// The signed-in user is resolved once per subscription so each tweet can
  /// say whether that user liked it.
  @override
  Stream<List<Tweet>> watch() {
    return Stream.fromFuture(_userSessionRepository.getCurrentUser())
        .asyncExpand((user) => _watchAs(user?.id));
  }

  Stream<List<Tweet>> _watchAs(String? currentUserId) {
    return _dataRemoteClient
        .watch(
          TweetDocument.collection,
          orderBy: TweetDocument.creationDate,
          descending: true,
        )
        .map(
          (documents) => documents
              .map(
                (document) => TweetDocument.fromRemote(
                  document,
                  currentUserId: currentUserId,
                ),
              )
              .toList(),
        );
  }
}
