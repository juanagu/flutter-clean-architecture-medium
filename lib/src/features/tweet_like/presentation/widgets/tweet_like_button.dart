import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TweetLikeButton extends StatelessWidget {
  final Tweet tweet;
  const TweetLikeButton({
    Key key,
    this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        tweet.likeIt ? FlutterIcons.heart_faw : FlutterIcons.heart_faw5,
        size: 16.0,
      ),
      onPressed: _onPressed,
    );
  }

  void _onPressed() {}
}
