import 'package:app/src/application/widgets/snack_bars.dart';
import 'package:app/src/features/tweet_creation/domain/failures/tweet_creation_failure.dart';
import 'package:app/src/features/tweet_creation/presentation/cubits/tweet_creation_cubit.dart';
import 'package:app/src/features/tweet_creation/presentation/widgets/tweet_composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetCreationPage extends StatelessWidget {
  const TweetCreationPage({
    super.key,
    required this.createCubit,
    required this.onTweeted,
  });

  final TweetCreationCubit Function() createCubit;
  final void Function(BuildContext context) onTweeted;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => createCubit(),
      child: BlocConsumer<TweetCreationCubit, TweetCreationState>(
        listener: _listen,
        builder: _buildByState,
      ),
    );
  }

  void _listen(BuildContext context, TweetCreationState state) {
    switch (state) {
      case TweetCreationTweeted():
        onTweeted(context);
      case TweetCreationFailed(:final failure):
        showTranslatedSnackBar(context, _messageKey(failure));
      case TweetCreationInitial():
      case TweetCreationTweeting():
        break;
    }
  }

  /// The composer stays mounted across every state, so a failed submit
  /// keeps the draft; the final one renders it read-only for its one frame.
  Widget _buildByState(BuildContext context, TweetCreationState state) {
    return TweetComposer(
      isSubmitting: switch (state) {
        TweetCreationTweeting() || TweetCreationTweeted() => true,
        TweetCreationInitial() || TweetCreationFailed() => false,
      },
      onSubmit: context.read<TweetCreationCubit>().tweet,
    );
  }

  String _messageKey(TweetCreationFailure failure) {
    return switch (failure) {
      TweetCreationUnauthenticated() =>
        'tweet_creation_feature.unauthenticated_message',
      TweetCreationUnexpectedError() =>
        'tweet_creation_feature.unexpected_error_message',
    };
  }
}
