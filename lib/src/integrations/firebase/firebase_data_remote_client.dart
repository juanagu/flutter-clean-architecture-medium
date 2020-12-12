import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/src/abstractions/data/data_remote_client.dart';

class FirebaseDataRemoteClient implements DataRemoteClient {
  @override
  Future<bool> isAuthenticated() async {
    var currentUser = FirebaseAuth.instance.currentUser;

    return currentUser != null;
  }
}
