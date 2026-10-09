import 'package:app/src/core/domain/entities/user.dart';

/// A tweet before it is stored: it has no id and no likes yet.
class TweetDraft {
  const TweetDraft({
    required this.content,
    required this.owner,
    required this.creationDate,
  });

  final String content;
  final User owner;
  final DateTime creationDate;
}
