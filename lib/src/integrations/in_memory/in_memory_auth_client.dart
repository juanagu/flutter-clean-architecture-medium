import 'package:app/src/abstractions/auth/auth_client.dart';

/// Identity provider that lives in the process. Lets the app run with no
/// Firebase project; every account disappears on restart.
class InMemoryAuthClient implements AuthClient {
  InMemoryAuthClient({Map<String, String> accounts = const {}})
    : _passwords = Map.of(accounts);

  static const int minPasswordLength = 6;

  final Map<String, String> _passwords;
  AuthUser? _currentUser;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final stored = _passwords[email];
    if (stored == null || stored != password) {
      throw const AuthClientException(AuthErrorCode.invalidCredentials);
    }
    return _currentUser = AuthUser(id: email, email: email);
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    if (_passwords.containsKey(email)) {
      throw const AuthClientException(AuthErrorCode.emailAlreadyInUse);
    }
    if (password.length < minPasswordLength) {
      throw const AuthClientException(AuthErrorCode.weakPassword);
    }
    _passwords[email] = password;
    return _currentUser = AuthUser(id: email, email: email);
  }
}
