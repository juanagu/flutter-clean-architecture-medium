import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';
import 'package:flutter/material.dart';

class TweetFeedListItem extends StatelessWidget {
  final TweetItem tweetItem;

  const TweetFeedListItem({
    Key key,
    @required this.tweetItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildUserAvatar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildContent(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      child: Icon(Icons.person),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildUserEmail(context),
        _buildTimeago(context),
      ],
    );
  }

  Widget _buildUserEmail(BuildContext context) {
    return Text(
      tweetItem.ownerEmail,
      style: Theme.of(context).textTheme.subtitle2,
      textAlign: TextAlign.end,
    );
  }

  Widget _buildTimeago(BuildContext context) {
    return Text(
      tweetItem.timeAgo,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        tweetItem.content,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
