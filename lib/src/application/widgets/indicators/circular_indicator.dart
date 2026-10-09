import 'package:flutter/material.dart';

enum _SpinnerTone { primary, onPrimary }

/// A labelled spinner. [CircularIndicator.page] is the 32 one that stands
/// alone while a screen loads; [CircularIndicator.inButton] is the 20 one
/// in `onPrimary` that replaces a filled button's label while it submits.
class CircularIndicator extends StatelessWidget {
  const CircularIndicator({super.key, required this.semanticsLabel})
    : size = _defaultSize,
      _tone = _SpinnerTone.primary;

  const CircularIndicator.page({super.key, required this.semanticsLabel})
    : size = _pageSize,
      _tone = _SpinnerTone.primary;

  const CircularIndicator.inButton({super.key, required this.semanticsLabel})
    : size = _buttonSize,
      _tone = _SpinnerTone.onPrimary;

  static const double _defaultSize = 24;
  static const double _pageSize = 32;
  static const double _buttonSize = 20;

  final String semanticsLabel;
  final double size;
  final _SpinnerTone _tone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        semanticsLabel: semanticsLabel,
        color: _color(context),
      ),
    );
  }

  /// Null reads the progress indicator theme (`primary`).
  Color? _color(BuildContext context) {
    return switch (_tone) {
      _SpinnerTone.primary => null,
      _SpinnerTone.onPrimary => Theme.of(context).colorScheme.onPrimary,
    };
  }
}
