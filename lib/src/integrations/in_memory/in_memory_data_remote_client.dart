import 'dart:async';

import 'package:app/src/abstractions/data/data_remote_client.dart';

/// Document store that lives in the process. Lets the app run with no
/// Firebase project; every document disappears on restart.
class InMemoryDataRemoteClient implements DataRemoteClient {
  InMemoryDataRemoteClient({
    Map<String, List<RemoteDocument>> seed = const {},
  }) {
    seed.forEach((collection, documents) {
      _collections[collection] = List.of(documents);
    });
  }

  final Map<String, List<RemoteDocument>> _collections = {};
  final Map<String, StreamController<void>> _changes = {};
  int _nextId = 1;

  @override
  Future<String> add(String collection, Map<String, dynamic> data) async {
    final document = RemoteDocument(id: 'doc-${_nextId++}', data: Map.of(data));
    _documents(collection).add(document);
    _notify(collection);
    return document.id;
  }

  @override
  Future<void> update(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    _replace(collection, id, (current) => {...current, ...data});
  }

  @override
  Future<void> updateSet(
    String collection,
    String id,
    String field, {
    List<Object> add = const [],
    List<Object> remove = const [],
  }) async {
    _replace(collection, id, (current) {
      final members = {...?(current[field] as List<Object?>?)}
        ..addAll(add)
        ..removeAll(remove);
      return {...current, field: members.toList()};
    });
  }

  /// Emits the current documents on listen, then again after every change.
  @override
  Stream<List<RemoteDocument>> watch(
    String collection, {
    required String orderBy,
    bool descending = false,
  }) {
    late final StreamController<List<RemoteDocument>> controller;
    StreamSubscription<void>? changes;
    List<RemoteDocument> snapshot() =>
        _ordered(collection, orderBy, descending);

    controller = StreamController(
      onListen: () {
        controller.add(snapshot());
        changes = _changesOf(collection).stream
            .listen((_) => controller.add(snapshot()));
      },
      onCancel: () => changes?.cancel(),
    );
    return controller.stream;
  }

  void _replace(
    String collection,
    String id,
    Map<String, dynamic> Function(Map<String, dynamic> current) change,
  ) {
    final documents = _documents(collection);
    final index = documents.indexWhere((document) => document.id == id);
    if (index < 0) throw StateError('No document $id in $collection');

    documents[index] = RemoteDocument(
      id: id,
      data: change(documents[index].data),
    );
    _notify(collection);
  }

  List<RemoteDocument> _documents(String collection) =>
      _collections.putIfAbsent(collection, () => []);

  StreamController<void> _changesOf(String collection) =>
      _changes.putIfAbsent(collection, StreamController<void>.broadcast);

  void _notify(String collection) => _changesOf(collection).add(null);

  List<RemoteDocument> _ordered(
    String collection,
    String orderBy,
    bool descending,
  ) {
    final ordered = List.of(_documents(collection))
      ..sort((a, b) {
        final left = a.data[orderBy] as Comparable<Object>;
        final right = b.data[orderBy] as Comparable<Object>;
        return descending ? right.compareTo(left) : left.compareTo(right);
      });
    return ordered;
  }
}
