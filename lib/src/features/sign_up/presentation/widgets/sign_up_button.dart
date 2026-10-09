import 'package:app/src/application/localizations/i18n.dart';
import 'package:flutter/material.dart';

/// Link to the sign-up screen, shown under the sign-in form.
class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key, required this.onPressed});

  final void Function(BuildContext context) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: () => onPressed(context),
        child: Text(I18n.of(context).translate('sign_up_feature.button_title')),
      ),
    );
  }
}
