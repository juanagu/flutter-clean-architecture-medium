import 'package:app/src/abstractions/failures/failure.dart';

sealed class SignUpFailure extends Failure {
  const SignUpFailure();
}

class SignUpEmailAlreadyInUse extends SignUpFailure {
  const SignUpEmailAlreadyInUse();
}

class SignUpWeakPassword extends SignUpFailure {
  const SignUpWeakPassword();
}

class SignUpUnexpectedError extends SignUpFailure {
  const SignUpUnexpectedError();
}
