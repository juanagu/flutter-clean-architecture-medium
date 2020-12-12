import 'package:dartz/dartz.dart';
import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/auth/domain/failures/auth_session_failure.dart';
import 'package:app/src/features/auth/domain/repositories/auth_session_repository.dart';
import 'package:meta/meta.dart';

class AuthSessionRemoteRepository implements AuthSessionRepository {
  final DataRemoteClient _dataRemoteClient;
  final Logger _logger;

  AuthSessionRemoteRepository({
    @required DataRemoteClient dataRemoteClient,
    @required Logger logger,
  })  : _dataRemoteClient = dataRemoteClient,
        _logger = logger;

  @override
  Future<Either<AuthSessionFailure, bool>> isAuthorized() async {
    try {
      var result = await _dataRemoteClient.isAuthenticated();

      if (result) {
        return right(result);
      } else {
        return left(AuthSessionFailure.unauthorized());
      }
    } catch (error, stackTrace) {
      await _logger.recordError(error, stackTrace);
      return left(AuthSessionFailure.unexpectedError());
    }
  }
}
