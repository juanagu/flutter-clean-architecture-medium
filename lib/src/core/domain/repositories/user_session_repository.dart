import 'package:app/src/core/domain/entities/user.dart';

abstract class UserSessionRepository {
  /// The signed-in user, or null when there is no session.
  Future<User?> getCurrentUser();
}
