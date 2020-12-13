import 'package:app/src/core/domain/entities/user.dart';

abstract class UserSessionRepository {
  Future<User> getCurrentUser();
}
