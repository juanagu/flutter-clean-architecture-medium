import 'package:dartz/dartz.dart';
import 'package:app/src/features/auth/domain/failures/auth_session_failure.dart';

abstract class AuthSessionRepository {
  Future<Either<AuthSessionFailure, bool>> isAuthorized();
}
