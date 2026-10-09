sealed class AuthIndexState {
  const AuthIndexState();
}

class AuthIndexInitial extends AuthIndexState {
  const AuthIndexInitial();
}

class AuthIndexAuthorized extends AuthIndexState {
  const AuthIndexAuthorized();
}

class AuthIndexUnauthorized extends AuthIndexState {
  const AuthIndexUnauthorized();
}

class AuthIndexUnexpectedError extends AuthIndexState {
  const AuthIndexUnexpectedError();
}

class AuthIndexMaintenance extends AuthIndexState {
  const AuthIndexMaintenance();
}
