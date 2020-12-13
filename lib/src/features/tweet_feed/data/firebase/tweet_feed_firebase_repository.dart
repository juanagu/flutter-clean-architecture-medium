import 'dart:async';

import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/domain/entities/user.dart';
import 'package:app/src/features/tweet_feed/domain/repositories/tweet_feed_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TweetFeedFirebaseRepository implements TweetFeedRepository {
  final StreamController<List<Tweet>> _controller =
      StreamController<List<Tweet>>();

  @override
  Stream<List<Tweet>> fetch() {
    FirebaseFirestore.instance
        .collection('tweets')
        .orderBy('creationDate', descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      var list = querySnapshot.docs.map(
        (e) {
          var json = e.data();
          return Tweet(
            json['udid'],
            json['content'],
            json['likes'],
            User(json['owner']['id'], json['owner']['email']),
            DateTime.fromMillisecondsSinceEpoch(json['creationDate']),
          );
        },
      ).toList();
      _controller.add(list);
    });

    return _controller.stream;
  }
}
