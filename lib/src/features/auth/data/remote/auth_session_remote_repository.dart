import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/auth/domain/failures/auth_session_failure.dart';
import 'package:app/src/features/auth/domain/repositories/auth_session_repository.dart';
import 'package:dartz/dartz.dart';

class AuthSessionRemoteRepository implements AuthSessionRepository {
  const AuthSessionRemoteRepository({
    required this._authClient,
    required this._logger,
  });

  final AuthClient _authClient;
  final Logger _logger;

  @override
  Future<Either<AuthSessionFailure, Unit>> isAuthorized() async {
    try {
      if (_authClient.currentUser == null) {
        return left(const AuthSessionUnauthorized());
      }
      return right(unit);
    } catch (error, stackTrace) {
      await _logger.recordError(error, stackTrace);
      return left(const AuthSessionUnexpectedError());
    }
  }
}
