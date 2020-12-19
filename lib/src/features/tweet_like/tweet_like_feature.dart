import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/presentation/widgets/tweet_like_button.dart';
import 'package:flutter/material.dart';

class TweetLikeFeature {
  Widget build(Tweet tweet) {
    return TweetLikeButton(
      tweet: tweet,
    );
  }
}
