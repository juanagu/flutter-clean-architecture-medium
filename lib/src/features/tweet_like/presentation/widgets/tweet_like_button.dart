import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:app/src/application/widgets/snack_bars.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:app/src/features/tweet_like/presentation/cubits/tweet_like_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Heart plus count for one tweet. Keeps its cubit across feed updates and
/// hands each newer [tweet] to it.
class TweetLikeButton extends StatefulWidget {
  const TweetLikeButton({
    super.key,
    required this.tweet,
    required this.createCubit,
  });

  final Tweet tweet;
  final TweetLikeCubit Function(Tweet tweet) createCubit;

  @override
  State<TweetLikeButton> createState() => _TweetLikeButtonState();
}

class _TweetLikeButtonState extends State<TweetLikeButton> {
  static const double _iconSize = 20;
  static const double _targetSize = 44;

  late final TweetLikeCubit _cubit = widget.createCubit(widget.tweet);

  @override
  void didUpdateWidget(TweetLikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tweet != oldWidget.tweet) _cubit.sync(widget.tweet);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TweetLikeCubit, TweetLikeState>(
      bloc: _cubit,
      listener: _listen,
      builder: _buildByState,
    );
  }

  void _listen(BuildContext context, TweetLikeState state) {
    if (state is! TweetLikeFailed) return;

    final key = switch (state.failure) {
      TweetLikeUnauthenticated() =>
        'tweet_like_feature.unauthenticated_message',
      TweetLikeUnexpectedError() => 'tweet_like_feature.unexpected_message',
    };
    showTranslatedSnackBar(context, key);
  }

  /// While a like is in flight the control ignores taps but keeps its
  /// colours: the flip already happened, a grey flash would read as failure.
  Widget _buildByState(BuildContext context, TweetLikeState state) {
    final tweet = state.tweet;
    final isSending = state is TweetLikeSending;
    final theme = Theme.of(context);
    final color = tweet.likeIt
        ? theme.colorScheme.tertiary
        : theme.colorScheme.onSurfaceVariant;
    final action = I18n.of(context).translate(
      tweet.likeIt ? 'tweet_like_feature.unlike' : 'tweet_like_feature.like',
    );
    return Semantics(
      button: true,
      toggled: tweet.likeIt,
      enabled: !isSending,
      label: '$action, ${tweet.likes}',
      excludeSemantics: true,
      onTap: isSending ? null : _cubit.toggle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeart(
            tweet,
            color: color,
            tooltip: action,
            enabled: !isSending,
          ),
          if (tweet.likes > 0) _buildCount(theme, tweet.likes, color: color),
        ],
      ),
    );
  }

  Widget _buildHeart(
    Tweet tweet, {
    required Color color,
    required String tooltip,
    required bool enabled,
  }) {
    return IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: _targetSize,
        minHeight: _targetSize,
      ),
      alignment: Alignment.centerLeft,
      iconSize: _iconSize,
      color: color,
      disabledColor: color,
      isSelected: tweet.likeIt,
      icon: const Icon(Icons.favorite_border),
      selectedIcon: const Icon(Icons.favorite),
      onPressed: enabled ? _cubit.toggle : null,
    );
  }

  Widget _buildCount(ThemeData theme, int likes, {required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(left: Space.s1),
      child: Text(
        '$likes',
        style: theme.textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}
