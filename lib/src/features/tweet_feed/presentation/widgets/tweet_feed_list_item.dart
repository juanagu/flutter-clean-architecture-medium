import 'package:app/src/application/theme/tokens.dart';
import 'package:app/src/application/widgets/avatars/initial_avatar.dart';
import 'package:app/src/application/widgets/hover_tint.dart';
import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';
import 'package:flutter/material.dart';

/// One feed row: avatar, owner and time, content, like control. Padded on
/// every side so the list's dividers can run edge to edge.
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
    return HoverTint(
      child: Padding(
        padding: const EdgeInsets.all(Space.s4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InitialAvatar(text: tweetItem.ownerEmail),
            const SizedBox(width: Space.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: Space.s1),
                  _buildContent(context),
                  const SizedBox(height: Space.s2),
                  likeAction,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            tweetItem.ownerEmail,
            style: theme.textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.s1),
          child: Text('·', style: secondary),
        ),
        Text(tweetItem.timeAgo, style: secondary, maxLines: 1),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      tweetItem.content,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
