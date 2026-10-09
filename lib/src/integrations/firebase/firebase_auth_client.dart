import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthClient implements AuthClient {
  const FirebaseAuthClient();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  @override
  AuthUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _toAuthUser(user);
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    return _guard(() async {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _requireUser(credential);
    });
  }

  @override
  Future<AuthUser> signUp({required String email, required String password}) {
    return _guard(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _requireUser(credential);
    });
  }

  Future<AuthUser> _guard(Future<AuthUser> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (error) {
      throw AuthClientException(_codeFrom(error.code), error.message);
    }
  }

  AuthUser _requireUser(UserCredential credential) {
    final user = credential.user;
    if (user == null) {
      throw const AuthClientException(
        AuthErrorCode.unknown,
        'Credential without user',
      );
    }
    return _toAuthUser(user);
  }

  AuthUser _toAuthUser(User user) =>
      AuthUser(id: user.uid, email: user.email ?? '');

  static AuthErrorCode _codeFrom(String code) {
    return switch (code) {
      'invalid-credential' ||
      'invalid-email' ||
      'user-not-found' ||
      'wrong-password' ||
      'user-disabled' => AuthErrorCode.invalidCredentials,
      'email-already-in-use' => AuthErrorCode.emailAlreadyInUse,
      'weak-password' => AuthErrorCode.weakPassword,
      _ => AuthErrorCode.unknown,
    };
  }
}
