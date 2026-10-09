import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataRemoteClient implements DataRemoteClient {
  const FirebaseDataRemoteClient();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  @override
  Future<String> add(String collection, Map<String, dynamic> data) async {
    final reference = await _firestore.collection(collection).add(data);
    return reference.id;
  }

  @override
  Future<void> update(String collection, String id, Map<String, dynamic> data) {
    return _firestore.collection(collection).doc(id).update(data);
  }

  @override
  Future<void> updateSet(
    String collection,
    String id,
    String field, {
    List<Object> add = const [],
    List<Object> remove = const [],
  }) async {
    final document = _firestore.collection(collection).doc(id);
    if (add.isNotEmpty) {
      await document.update({field: FieldValue.arrayUnion(add)});
    }
    if (remove.isNotEmpty) {
      await document.update({field: FieldValue.arrayRemove(remove)});
    }
  }

  @override
  Stream<List<RemoteDocument>> watch(
    String collection, {
    required String orderBy,
    bool descending = false,
  }) {
    return _firestore
        .collection(collection)
        .orderBy(orderBy, descending: descending)
        .snapshots()
        .map(_toDocuments);
  }

  List<RemoteDocument> _toDocuments(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs
        .map((doc) => RemoteDocument(id: doc.id, data: doc.data()))
        .toList();
  }
}
