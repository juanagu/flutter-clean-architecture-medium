import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:app/src/application/widgets/buttons/pill_button.dart';
import 'package:flutter/material.dart';

/// The compose screen: a borderless text area, a remaining-characters
/// counter and the `Tweet` pill in the app bar. Owns its controller, so the
/// draft survives a failed submit.
class TweetComposer extends StatefulWidget {
  const TweetComposer({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  static const int maxLength = 280;

  final void Function(String content) onSubmit;

  /// While true the text is read-only and the pill shows progress.
  final bool isSubmitting;

  @override
  State<TweetComposer> createState() => _TweetComposerState();
}

class _TweetComposerState extends State<TweetComposer> {
  static const int _nearLimit = 20;
  static const int _minLines = 6;

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
      leading: PageLeading.close,
      canLeave: !widget.isSubmitting,
      gutter: false,
      actions: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (_, value, _) =>
              _buildAction(i18n, hasText: value.text.trim().isNotEmpty),
        ),
      ],
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: _buildField(context, i18n),
      ),
    );
  }

  Widget _buildAction(I18n i18n, {required bool hasText}) {
    return PillButton(
      label: i18n.translate('tweet_creation_feature.submit_button_title'),
      busySemanticsLabel: widget.isSubmitting
          ? i18n.translate('tweet_creation_feature.tweeting_message_semantics')
          : null,
      onPressed: hasText ? _submit : null,
    );
  }

  Widget _buildField(BuildContext context, I18n i18n) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        hintText: i18n.translate('tweet_creation_feature.hint_text'),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Space.s4,
          vertical: Space.s3,
        ),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: widget.isSubmitting ? theme.colorScheme.onSurfaceVariant : null,
      ),
      controller: _controller,
      readOnly: widget.isSubmitting,
      autofocus: true,
      maxLength: TweetComposer.maxLength,
      buildCounter: _buildCounter,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      minLines: _minLines,
    );
  }

  /// Reads what is left, in `error` once 20 or fewer remain.
  Widget _buildCounter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    final remaining = (maxLength ?? TweetComposer.maxLength) - currentLength;
    final isNearLimit = remaining <= _nearLimit;
    final theme = Theme.of(context);
    final label = I18n.of(context)
        .translate('tweet_creation_feature.counter_semantics');
    return Semantics(
      label: label.replaceAll('{n}', '$remaining'),
      excludeSemantics: true,
      child: Text(
        '$remaining',
        style: theme.textTheme.bodySmall?.copyWith(
          color: isNearLimit
              ? theme.colorScheme.error
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isNearLimit ? FontWeight.w600 : null,
        ),
      ),
    );
  }

  void _submit() {
    if (widget.isSubmitting) return;

    final content = _controller.text.trim();
    if (content.isEmpty) return;

    widget.onSubmit(content);
  }
}
