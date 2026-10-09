import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/core/data/tweet_document.dart';
import 'package:app/src/core/domain/entities/user.dart';

/// Sample data for the in-memory backend so the feed is not empty on first
/// run.
abstract final class InMemorySeed {
  static const String demoEmail = 'demo@example.com';
  static const String demoPassword = 'password';

  static const User _demoUser = User(id: demoEmail, email: demoEmail);
  static const List<String> _otherLikers = [
    'ana@example.com',
    'bo@example.com',
  ];

  static Map<String, String> accounts() => const {demoEmail: demoPassword};

  static Map<String, List<RemoteDocument>> collections({DateTime? now}) {
    final reference = (now ?? DateTime.now()).toUtc();
    return {
      TweetDocument.collection: [
        _tweet(
          'seed-1',
          'Hello from the in-memory backend!',
          reference,
          likedBy: _otherLikers,
        ),
        _tweet(
          'seed-2',
          'Every layer behind this screen is a port with a fake behind it.',
          reference.subtract(const Duration(minutes: 42)),
          likedBy: [_otherLikers.first],
        ),
        _tweet(
          'seed-3',
          'Sign out and back in with demo@example.com / password.',
          reference.subtract(const Duration(hours: 5)),
        ),
      ],
    };
  }

  static RemoteDocument _tweet(
    String id,
    String content,
    DateTime creationDate, {
    List<String> likedBy = const [],
  }) {
    return RemoteDocument(
      id: id,
      data: TweetDocument.toJson(
        content: content,
        owner: _demoUser,
        creationDate: creationDate,
        likedBy: likedBy,
      ),
    );
  }
}
