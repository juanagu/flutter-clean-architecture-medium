import 'package:app/src/abstractions/data/data_remote_client.dart';
import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/core/data/tweet_document.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/domain/entities/user.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/core/presentation/formatters/relative_time_formatter.dart';

class RecordingLogger implements Logger {
  final List<String> messages = [];
  final List<Object> errors = [];

  @override
  Future<void> info(String message) async => messages.add('info: $message');

  @override
  Future<void> error(String message) async => messages.add('error: $message');

  @override
  Future<void> recordError(Object error, StackTrace stackTrace) async =>
      errors.add(error);
}

class MapFeatureConfig implements FeatureConfig {
  MapFeatureConfig(this.flags, {this.failure});

  final Map<String, bool> flags;
  final Object? failure;

  @override
  Future<bool> isEnabled(String key) async {
    final failure = this.failure;
    if (failure != null) throw failure;
    return flags[key] ?? false;
  }
}

class FixedUserSessionRepository implements UserSessionRepository {
  FixedUserSessionRepository(this.user);

  final User? user;

  @override
  Future<User?> getCurrentUser() async => user;
}

class FixedRelativeTimeFormatter implements RelativeTimeFormatter {
  const FixedRelativeTimeFormatter([this.value = 'just now']);

  final String value;

  @override
  String format(DateTime dateTime, {required String languageCode}) =>
      languageCode == 'en' ? value : '$languageCode:$value';
}

const User testUser = User(id: 'user-1', email: 'user@example.com');

Tweet makeTweet({
  String id = 'tweet-1',
  String content = 'Hello',
  int likes = 0,
  DateTime? creationDate,
  bool likeIt = false,
}) {
  return Tweet(
    id: id,
    content: content,
    likes: likes,
    owner: testUser,
    creationDate: creationDate ?? DateTime.utc(2024, 1, 1),
    likeIt: likeIt,
  );
}

RemoteDocument makeRemoteTweet(
  String id, {
  String content = 'Hello',
  DateTime? creationDate,
  List<String> likedBy = const [],
}) {
  return RemoteDocument(
    id: id,
    data: TweetDocument.toJson(
      content: content,
      owner: testUser,
      creationDate: creationDate ?? DateTime.utc(2024, 1, 1),
      likedBy: likedBy,
    ),
  );
}
