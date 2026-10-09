class RemoteDocument {
  const RemoteDocument({required this.id, required this.data});

  final String id;
  final Map<String, dynamic> data;
}

/// Port over the document store. A collection is addressed by name; documents
/// are plain maps so no vendor type crosses this boundary.
abstract class DataRemoteClient {
  /// Adds [data] to [collection] and returns the generated document id.
  Future<String> add(String collection, Map<String, dynamic> data);

  Future<void> update(String collection, String id, Map<String, dynamic> data);

  /// Atomically adds and removes members of a set-valued [field], so
  /// concurrent writers never overwrite each other.
  Future<void> updateSet(
    String collection,
    String id,
    String field, {
    List<Object> add = const [],
    List<Object> remove = const [],
  });

  Stream<List<RemoteDocument>> watch(
    String collection, {
    required String orderBy,
    bool descending = false,
  });
}
