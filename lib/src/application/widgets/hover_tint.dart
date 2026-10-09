import 'package:flutter/material.dart';

/// Tints [child] with `surfaceContainer` while a pointer hovers it. For
/// rows that have no tap action, where an `InkWell` would stay inert.
class HoverTint extends StatefulWidget {
  const HoverTint({super.key, required this.child});

  final Widget child;

  @override
  State<HoverTint> createState() => _HoverTintState();
}

class _HoverTintState extends State<HoverTint> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ColoredBox(
        color: _isHovered
            ? Theme.of(context).colorScheme.surfaceContainer
            : Colors.transparent,
        child: widget.child,
      ),
    );
  }
}
