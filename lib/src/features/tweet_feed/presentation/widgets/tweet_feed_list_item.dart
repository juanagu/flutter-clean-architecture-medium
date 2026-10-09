import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';
import 'package:flutter/material.dart';

class TweetFeedListItem extends StatelessWidget {
  const TweetFeedListItem({
    super.key,
    required this.tweetItem,
    required this.likeAction,
  });

  final TweetItem tweetItem;
  final Widget likeAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildContent(context),
                  likeAction,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            tweetItem.ownerEmail,
            style: textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(tweetItem.timeAgo, style: textTheme.bodySmall),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        tweetItem.content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
