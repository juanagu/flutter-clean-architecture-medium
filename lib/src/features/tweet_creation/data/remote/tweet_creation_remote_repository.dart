import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/core/data/tweet_document.dart';
import 'package:app/src/features/tweet_creation/domain/entities/tweet_draft.dart';
import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:app/src/features/tweet_creation/domain/repositories/tweet_creation_repository.dart';
import 'package:dartz/dartz.dart';

class TweetCreationRemoteRepository implements TweetCreationRepository {
  const TweetCreationRemoteRepository({
    required this._dataRemoteClient,
    required this._logger,
  });

  final DataRemoteClient _dataRemoteClient;
  final Logger _logger;

  @override
  Future<Either<TweetCreationFailure, Unit>> create(TweetDraft draft) async {
    try {
      await _dataRemoteClient.add(
        TweetDocument.collection,
        TweetDocument.toJson(
          content: draft.content,
          owner: draft.owner,
          creationDate: draft.creationDate,
        ),
      );
      return right(unit);
    } catch (error, stackTrace) {
      await _logger.recordError(error, stackTrace);
      return left(const TweetCreationUnexpectedError());
    }
  }
}
