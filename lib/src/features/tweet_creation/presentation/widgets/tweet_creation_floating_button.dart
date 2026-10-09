import 'package:app/src/application/localizations/i18n.dart';
import 'package:flutter/material.dart';

/// Opens the compose screen from the home screen.
class TweetCreationFloatingButton extends StatelessWidget {
  const TweetCreationFloatingButton({super.key, required this.onPressed});

  final void Function(BuildContext context) onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: I18n.of(context).translate('tweet_creation_feature.title'),
      onPressed: () => onPressed(context),
      child: const Icon(Icons.add_comment),
    );
  }
}
