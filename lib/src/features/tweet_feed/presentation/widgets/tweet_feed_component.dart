import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:app/src/application/widgets/views/message_view.dart';
import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/features/tweet_feed/presentation/cubits/tweet_feed_cubit.dart';
import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';
import 'package:app/src/features/tweet_feed/presentation/widgets/tweet_feed_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef LikeActionBuilder = Widget Function(Tweet tweet);

class TweetFeedComponent extends StatelessWidget {
  const TweetFeedComponent({
    super.key,
    required this.createCubit,
    required this.likeActionBuilder,
  });

  final TweetFeedCubit Function() createCubit;

  /// Builds the like control of a row; the feature that owns likes provides it.
  final LikeActionBuilder likeActionBuilder;

  @override
  Widget build(BuildContext context) {
    final languageCode = _languageCode(context);
    return BlocProvider(
      create: (_) => createCubit()..subscribe(languageCode: languageCode),
      child: BlocBuilder<TweetFeedCubit, TweetFeedState>(
        builder: _buildByState,
      ),
    );
  }

  static String _languageCode(BuildContext context) =>
      Localizations.localeOf(context).languageCode;

  Widget _buildByState(BuildContext context, TweetFeedState state) {
    return switch (state) {
      TweetFeedInitial() || TweetFeedLoading() => _buildLoading(context),
      TweetFeedFound(:final items) => _buildList(items),
      TweetFeedEmpty() => _buildEmpty(context),
      TweetFeedUnexpectedError() => _buildError(context),
    };
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularIndicator(
        semanticsLabel: I18n.of(context)
            .translate('tweet_feed_feature.loading_message_semantics'),
      ),
    );
  }

  Widget _buildList(List<TweetItem> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return TweetFeedListItem(
          key: ValueKey(item.tweet.id),
          tweetItem: item,
          likeAction: likeActionBuilder(item.tweet),
        );
      },
      separatorBuilder: (_, _) => const Divider(),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return MessageView(
      icon: Icons.chat_bubble_outline,
      message: I18n.of(context).translate('tweet_feed_feature.empty_message'),
    );
  }

  Widget _buildError(BuildContext context) {
    final i18n = I18n.of(context);
    return MessageView(
      icon: Icons.error_outline,
      message: i18n.translate('tweet_feed_feature.unexpected_message'),
      action: FilledButton.tonal(
        onPressed: () => context.read<TweetFeedCubit>().subscribe(
          languageCode: _languageCode(context),
        ),
        child: Text(i18n.translate('retry_button_title')),
      ),
    );
  }
}
