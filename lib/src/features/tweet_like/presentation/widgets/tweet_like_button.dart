import 'package:app/src/application/localizations/i18n.dart';
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
  static const double _iconSize = 16;

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

  Widget _buildByState(BuildContext context, TweetLikeState state) {
    final tweet = state.tweet;
    final isSending = state is TweetLikeSending;
    final tooltipKey = tweet.likeIt
        ? 'tweet_like_feature.unlike'
        : 'tweet_like_feature.like';
    return Row(
      children: [
        IconButton(
          tooltip: I18n.of(context).translate(tooltipKey),
          iconSize: _iconSize,
          isSelected: tweet.likeIt,
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(Icons.favorite),
          onPressed: isSending ? null : _cubit.toggle,
        ),
        Text('${tweet.likes}', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
