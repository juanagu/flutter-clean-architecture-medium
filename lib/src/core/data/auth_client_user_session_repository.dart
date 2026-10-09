import 'package:app/src/abstractions/auth/auth_client.dart';
import 'package:app/src/core/domain/entities/user.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';

class AuthClientUserSessionRepository implements UserSessionRepository {
  const AuthClientUserSessionRepository({required this._authClient});

  final AuthClient _authClient;

  @override
  Future<User?> getCurrentUser() async {
    final authUser = _authClient.currentUser;
    if (authUser == null) return null;

    return User(id: authUser.id, email: authUser.email);
  }
}
