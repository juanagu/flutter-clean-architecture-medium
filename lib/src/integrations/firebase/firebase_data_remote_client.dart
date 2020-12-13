import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/src/abstractions/data/data_remote_client.dart';

class FirebaseDataRemoteClient implements DataRemoteClient {
  @override
  Future<bool> isAuthenticated() async {
    var currentUser = FirebaseAuth.instance.currentUser;

    return currentUser != null;
  }

  @override
  Future<dynamic> get(String path) async {
    return FirebaseFirestore.instance.collection(path).get();
  }

  @override
  Stream<dynamic> listen(String path) {
    return FirebaseFirestore.instance.collection(path).snapshots();
  }

  @override
  Future<dynamic> post(String path, {data}) {
    return FirebaseFirestore.instance.collection(path).add(data);
  }
}
