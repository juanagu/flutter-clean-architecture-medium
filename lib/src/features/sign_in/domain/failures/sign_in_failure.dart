import 'package:app/src/abstractions/failures/failure.dart';

sealed class SignInFailure extends Failure {
  const SignInFailure();
}

class SignInUnauthorized extends SignInFailure {
  const SignInUnauthorized();
}

class SignInUnexpectedError extends SignInFailure {
  const SignInUnexpectedError();
}
