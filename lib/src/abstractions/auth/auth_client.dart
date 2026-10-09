enum AuthErrorCode {
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  unknown,
}

class AuthClientException implements Exception {
  const AuthClientException(this.code, [this.message]);

  final AuthErrorCode code;
  final String? message;

  @override
  String toString() {
    final detail = message == null ? '' : ': $message';
    return 'AuthClientException(${code.name}$detail)';
  }
}

class AuthUser {
  const AuthUser({required this.id, required this.email});

  final String id;
  final String email;
}

/// Port over the identity provider. Failures surface as [AuthClientException]
/// with a vendor-neutral [AuthErrorCode].
abstract class AuthClient {
  AuthUser? get currentUser;

  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> signUp({required String email, required String password});
}
