import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:app/src/features/tweet_feed/presentation/cubits/tweet_feed_cubit.dart';
import 'package:app/src/features/tweet_feed/presentation/models/tweet_item.dart';
import 'package:app/src/features/tweet_feed/presentation/widgets/tweet_feed_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetFeedComponent extends StatelessWidget {
  final TweetFeedCubit cubit;

  const TweetFeedComponent({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit..fetch(),
      child: BlocBuilder<TweetFeedCubit, TweetFeedState>(
        builder: _buildByState,
      ),
    );
  }

  Widget _buildByState(
    BuildContext context,
    TweetFeedState state,
  ) {
    return state.maybeWhen(
      found: (items) => _buildFoundView(items, context),
      orElse: () => _buildLoadingView(context),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: CircularIndicator(
        semanticsValue:
            I18n.of(context).translate('tweed_feed_loading_message_semantics'),
      ),
    );
  }

  Widget _buildFoundView(List<TweetItem> items, BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) =>
          TweetFeedListItem(tweetItem: items[index]),
      separatorBuilder: (context, index) => Divider(),
    );
  }
}
