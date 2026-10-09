import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/integrations/in_memory/in_memory_data_remote_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryDataRemoteClient client;

  setUp(() {
    client = InMemoryDataRemoteClient(
      seed: {
        'items': [
          const RemoteDocument(id: 'a', data: {'order': 2}),
          const RemoteDocument(id: 'b', data: {'order': 1}),
        ],
      },
    );
  });

  test('watch emits the ordered seed first', () async {
    final first = await client.watch('items', orderBy: 'order').first;

    expect(first.map((d) => d.id), ['b', 'a']);
  });

  test('watch honours descending order', () async {
    final first = await client
        .watch('items', orderBy: 'order', descending: true)
        .first;

    expect(first.map((d) => d.id), ['a', 'b']);
  });

  test('add assigns an id and re-emits', () async {
    final emissions = client.watch('items', orderBy: 'order').take(2).toList();

    final id = await client.add('items', {'order': 3});

    final last = (await emissions).last;
    expect(id, isNotEmpty);
    expect(last.map((d) => d.id), ['b', 'a', id]);
  });

  test('updateSet adds and removes members atomically', () async {
    await client.updateSet('items', 'a', 'tags', add: ['x', 'y']);
    await client.updateSet(
      'items',
      'a',
      'tags',
      add: ['y', 'z'],
      remove: ['x'],
    );

    final first = await client.watch('items', orderBy: 'order').first;
    final updated = first.firstWhere((d) => d.id == 'a');
    expect(updated.data['tags'], unorderedEquals(['y', 'z']));
  });

  test('update merges fields and re-emits', () async {
    final emissions = client.watch('items', orderBy: 'order').take(2).toList();

    await client.update('items', 'a', {'likes': 5});

    final updated = (await emissions).last.firstWhere((d) => d.id == 'a');
    expect(updated.data, {'order': 2, 'likes': 5});
  });

  test('update rejects an unknown id', () {
    expect(client.update('items', 'zzz', {}), throwsStateError);
  });
}
