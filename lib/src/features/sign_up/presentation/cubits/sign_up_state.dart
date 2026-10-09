sealed class SignUpState {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpCreating extends SignUpState {
  const SignUpCreating();
}

class SignUpRegistered extends SignUpState {
  const SignUpRegistered();
}

class SignUpEmailAlreadyInUse extends SignUpState {
  const SignUpEmailAlreadyInUse();
}

class SignUpWeakPassword extends SignUpState {
  const SignUpWeakPassword();
}

class SignUpUnexpectedError extends SignUpState {
  const SignUpUnexpectedError();
}
