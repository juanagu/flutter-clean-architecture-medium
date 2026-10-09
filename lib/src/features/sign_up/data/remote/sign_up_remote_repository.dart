import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/sign_up/domain/failures/sign_up_failure.dart';
import 'package:app/src/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:dartz/dartz.dart';

class SignUpRemoteRepository implements SignUpRepository {
  const SignUpRemoteRepository({
    required this._authClient,
    required this._logger,
  });

  final AuthClient _authClient;
  final Logger _logger;

  @override
  Future<Either<SignUpFailure, Unit>> signUp(
    String email,
    String password,
  ) async {
    try {
      await _authClient.signUp(email: email, password: password);
      return right(unit);
    } on AuthClientException catch (error, stackTrace) {
      switch (error.code) {
        case AuthErrorCode.emailAlreadyInUse:
          return left(const SignUpEmailAlreadyInUse());
        case AuthErrorCode.weakPassword:
          return left(const SignUpWeakPassword());
        case AuthErrorCode.invalidCredentials:
        case AuthErrorCode.unknown:
          await _logger.recordError(error, stackTrace);
          return left(const SignUpUnexpectedError());
      }
    } catch (error, stackTrace) {
      await _logger.recordError(error, stackTrace);
      return left(const SignUpUnexpectedError());
    }
  }
}
