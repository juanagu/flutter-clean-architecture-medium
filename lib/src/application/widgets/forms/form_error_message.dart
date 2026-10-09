import 'package:app/src/application/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Inline block for a form-level failure the user fixes by retyping, shown
/// between the fields and the submit button. A live region, so it is read
/// out when it appears.
class FormErrorMessage extends StatelessWidget {
  const FormErrorMessage({super.key, required this.message});

  static const double _iconSize = 20;

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: const BorderRadius.all(Radius.circular(Radii.sm)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.s3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline,
                size: _iconSize,
                color: colors.onErrorContainer,
              ),
              const SizedBox(width: Space.s2),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
