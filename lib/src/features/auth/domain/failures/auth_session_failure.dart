import 'package:app/src/abstractions/failures/failure.dart';

sealed class AuthSessionFailure extends Failure {
  const AuthSessionFailure();
}

class AuthSessionUnauthorized extends AuthSessionFailure {
  const AuthSessionUnauthorized();
}

class AuthSessionUnexpectedError extends AuthSessionFailure {
  const AuthSessionUnexpectedError();
}
