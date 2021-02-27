import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/tweet_creation/data/mappers/tweet_data_mapper.dart';
import 'package:app/src/features/tweet_creation/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:app/src/features/tweet_creation/domain/repositories/tweet_creation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class TweetCreationRemoteRepository implements TweetCreationRepository {
  TweetCreationRemoteRepository({
    @required DataRemoteClient dataRemoteClient,
    @required Logger logger,
  })  : _dataRemoteClient = dataRemoteClient,
        _logger = logger;

  static const String tweetCollection = 'tweets';

  final DataRemoteClient _dataRemoteClient;
  final Logger _logger;

  @override
  Future<Either<TweetCreationFailure, bool>> create(Tweet tweet) async {
    try {
      var response = await _post(tweet);

      if (response != null) return right(true);

      return left(const TweetCreationFailure.unexpectedError());
    } catch (error, stackTrace) {
      await _logger.recordError(error, stackTrace);

      return left(const TweetCreationFailure.unexpectedError());
    }
  }

  Future<dynamic> _post(Tweet tweet) async {
    return await _dataRemoteClient.post(
      tweetCollection,
      data: TweetDataMapper(tweet).toJson(),
    );
  }
}
