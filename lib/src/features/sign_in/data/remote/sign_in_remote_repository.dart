import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/sign_in/domain/failures/sign_in_failure.dart';
import 'package:app/src/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:dartz/dartz.dart';

class SignInRemoteRepository implements SignInRepository {
  const SignInRemoteRepository({
    required this._authClient,
    required this._logger,
  });

  final AuthClient _authClient;
  final Logger _logger;

  @override
  Future<Either<SignInFailure, Unit>> signIn(
    String email,
    String password,
  ) async {
    try {
      await _authClient.signIn(email: email, password: password);
      return right(unit);
    } on AuthClientException catch (error, stackTrace) {
      if (error.code == AuthErrorCode.invalidCredentials) {
        return left(const SignInUnauthorized());
      }
      await _logger.recordError(error, stackTrace);
      return left(const SignInUnexpectedError());
    } catch (error, stackTrace) {
      await _logger.recordError(error, stackTrace);
      return left(const SignInUnexpectedError());
    }
  }
}
