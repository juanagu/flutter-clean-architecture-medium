sealed class SignInState {
  const SignInState();
}

class SignInInitial extends SignInState {
  const SignInInitial();
}

class SignInAuthenticating extends SignInState {
  const SignInAuthenticating();
}

class SignInAuthorized extends SignInState {
  const SignInAuthorized();
}

class SignInUnauthorized extends SignInState {
  const SignInUnauthorized();
}

class SignInUnexpectedError extends SignInState {
  const SignInUnexpectedError();
}
