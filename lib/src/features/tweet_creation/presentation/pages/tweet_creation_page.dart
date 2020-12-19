import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:app/src/features/tweet_creation/presentation/cubits/tweet_creation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetCreationPage extends StatelessWidget {
  final TweetCreationCubit cubit;
  final Function(BuildContext) onTweeted;

  final TextEditingController _tweetController = TextEditingController();

  TweetCreationPage({
    Key key,
    @required this.cubit,
    @required this.onTweeted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit,
      child: BlocConsumer<TweetCreationCubit, TweetCreationState>(
        listener: _listenByState,
        builder: _buildByState,
      ),
    );
  }

  void _listenByState(
    BuildContext context,
    TweetCreationState state,
  ) {
    state.maybeWhen(
        tweeted: () => onTweeted(context),
        unexpectedError: () => _showUnexpectedError(context),
        orElse: () {});
  }

  Widget _buildByState(
    BuildContext context,
    TweetCreationState state,
  ) {
    return state.maybeWhen(
      tweeting: () => _buildTweetingView(context),
      tweeted: () => _buildTweetedView(context),
      orElse: () => _buildTweetPageView(context),
    );
  }

  Widget _buildTweetPageView(BuildContext context) {
    return PageContainer(
      title: I18n.of(context).translate('tweet_creation_feature.title'),
      body: _buildBody(context),
      actions: [
        _buildTweetSubmitButton(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SizedBox(
            height: 250.0,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,
                hintText: I18n.of(context)
                    .translate('tweet_creation_feature.hint_text'),
              ),
              controller: _tweetController,
              autofocus: true,
              maxLength: 280,
              keyboardType: TextInputType.multiline,
              maxLines: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTweetSubmitButton(BuildContext context) {
    return IconButton(
      tooltip: I18n.of(context)
          .translate('tweet_creation_feature.submit_button_title'),
      icon: Icon(
        Icons.check,
      ),
      onPressed: _onSubmit,
    );
  }

  void _onSubmit() {
    if (_tweetController.text.trim().isNotEmpty) {
      cubit.tweet(_tweetController.text.trimLeft().trimRight());
    }
  }

  void _showUnexpectedError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          I18n.of(context)
              .translate('tweet_creation_feature.unexpected_error_message'),
        ),
      ),
    );
  }

  Widget _buildTweetingView(BuildContext context) {
    return PageContainer(
      body: Center(
        child: CircularIndicator(
          semanticsValue: I18n.of(context)
              .translate('tweet_creation_feature.tweeting_message_semantics'),
        ),
      ),
    );
  }

  Widget _buildTweetedView(BuildContext context) {
    return PageContainer(
      body: Center(
        child: Icon(Icons.check),
      ),
    );
  }
}
