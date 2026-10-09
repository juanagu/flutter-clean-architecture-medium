import 'package:app/src/features/auth/domain/failures/auth_session_failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthSessionRepository {
  Future<Either<AuthSessionFailure, Unit>> isAuthorized();
}
