import 'package:app/src/core/domain/entities/user.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserSessionFirebaseRepository implements UserSessionRepository {
  @override
  Future<User> getCurrentUser() async {
    var currentUser = firebase.FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    return User(
      currentUser.uid,
      currentUser.email,
    );
  }
}
