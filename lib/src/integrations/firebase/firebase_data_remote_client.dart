import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:meta/meta.dart';

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
  Future<dynamic> post(
    String path, {
    @required dynamic data,
  }) {
    return FirebaseFirestore.instance.collection(path).add(data);
  }

  @override
  Future put(
    String path,
    String id, {
    @required dynamic data,
  }) {
    return FirebaseFirestore.instance.collection(path).doc(id).set(data);
  }

  @override
  Future patch(
    String path,
    String id, {
    @required dynamic data,
  }) {
    return FirebaseFirestore.instance.collection(path).doc(id).update(data);
  }
}
