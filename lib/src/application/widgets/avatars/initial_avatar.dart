import 'package:flutter/material.dart';

/// A circle with the first letter of [text], for rows that have a name or
/// an email but no picture. Decorative: the text next to it carries the
/// meaning.
class InitialAvatar extends StatelessWidget {
  const InitialAvatar({super.key, required this.text});

  static const double _size = 40;

  final String text;

  String get _initial =>
      text.isEmpty ? '' : text.characters.first.toUpperCase();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExcludeSemantics(
      child: Container(
        width: _size,
        height: _size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Text(
          _initial,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
