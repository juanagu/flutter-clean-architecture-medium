import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/core/data/tweet_document.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/domain/entities/user.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:app/src/features/tweet_like/domain/repositories/tweet_like_repository.dart';
import 'package:dartz/dartz.dart';

class TweetLikeRemoteRepository implements TweetLikeRepository {
  const TweetLikeRemoteRepository({
    required this._dataRemoteClient,
    required this._logger,
  });

  final DataRemoteClient _dataRemoteClient;
  final Logger _logger;

  @override
  Future<Either<TweetLikeFailure, Unit>> setLiked(
    Tweet tweet, {
    required User user,
    required bool liked,
  }) async {
    try {
      await _dataRemoteClient.updateSet(
        TweetDocument.collection,
        tweet.id,
        TweetDocument.likedBy,
        add: liked ? [user.id] : const [],
        remove: liked ? const [] : [user.id],
      );
      return right(unit);
    } catch (error, stackTrace) {
      await _logger.recordError(error, stackTrace);
      return left(const TweetLikeUnexpectedError());
    }
  }
}
