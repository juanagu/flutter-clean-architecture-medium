import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({super.key, required this.semanticsLabel});

  static const double _size = 24;

  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _size,
      width: _size,
      child: CircularProgressIndicator(semanticsLabel: semanticsLabel),
    );
  }
}
