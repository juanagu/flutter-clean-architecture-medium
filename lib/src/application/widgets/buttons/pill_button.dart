import 'package:app/src/application/theme/tokens.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:flutter/material.dart';

/// A compact filled button for an app bar: 36 high in a 48 hit area. While
/// [busySemanticsLabel] is set a spinner replaces the label and the width
/// is kept, so the bar does not shift.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busySemanticsLabel,
  });

  static const double _height = 36;

  final String label;
  final VoidCallback? onPressed;
  final String? busySemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final busySemanticsLabel = this.busySemanticsLabel;
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: const Size(0, _height),
        maximumSize: const Size(double.infinity, _height),
        padding: const EdgeInsets.symmetric(horizontal: Space.s4),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      onPressed: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: busySemanticsLabel == null,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Text(label),
          ),
          if (busySemanticsLabel != null)
            CircularIndicator.inButton(semanticsLabel: busySemanticsLabel),
        ],
      ),
    );
  }
}
