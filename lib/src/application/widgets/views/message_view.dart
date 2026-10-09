import 'package:flutter/material.dart';

/// Centered icon plus message, with an optional action. Used for empty and
/// error states so they all look the same.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.message,
    this.action,
  });

  static const double _iconSize = 48;

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: _iconSize,
            color: Theme.of(context).colorScheme.outline,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(message, textAlign: TextAlign.center),
          ),
          if (action != null)
            Padding(padding: const EdgeInsets.only(top: 16), child: action),
        ],
      ),
    );
  }
}
