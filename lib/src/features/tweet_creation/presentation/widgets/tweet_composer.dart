import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:flutter/material.dart';

/// The compose screen body: a bounded text area and a submit action in the
/// app bar. Owns its controller, so the draft survives a failed submit.
class TweetComposer extends StatefulWidget {
  const TweetComposer({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  static const int maxLength = 280;

  final void Function(String content) onSubmit;

  /// While true the text is read-only and the action shows progress.
  final bool isSubmitting;

  @override
  State<TweetComposer> createState() => _TweetComposerState();
}

class _TweetComposerState extends State<TweetComposer> {
  static const int _visibleLines = 8;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context);
    return PageContainer(
      title: i18n.translate('tweet_creation_feature.title'),
      actions: [_buildAction(i18n)],
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: i18n.translate('tweet_creation_feature.hint_text'),
              ),
              controller: _controller,
              readOnly: widget.isSubmitting,
              autofocus: true,
              maxLength: TweetComposer.maxLength,
              keyboardType: TextInputType.multiline,
              maxLines: _visibleLines,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(I18n i18n) {
    if (widget.isSubmitting) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: CircularIndicator(
          semanticsLabel: i18n.translate(
            'tweet_creation_feature.tweeting_message_semantics',
          ),
        ),
      );
    }
    return IconButton(
      tooltip: i18n.translate('tweet_creation_feature.submit_button_title'),
      icon: const Icon(Icons.check),
      onPressed: _submit,
    );
  }

  void _submit() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    widget.onSubmit(content);
  }
}
