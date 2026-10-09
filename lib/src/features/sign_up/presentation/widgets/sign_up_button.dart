import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Prompt plus link to the sign-up screen, centred under the sign-in form.
/// Wraps to two lines when the copy or the text scale needs it.
class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key, required this.onPressed});

  final void Function(BuildContext context) onPressed;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context);
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: Space.s1,
      children: [
        Text(
          i18n.translate('sign_up_feature.button_prompt'),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () => onPressed(context),
          child: Text(
            i18n.translate('sign_up_feature.button_title'),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
