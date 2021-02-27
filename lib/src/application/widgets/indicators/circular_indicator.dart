import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({
    Key key,
    @required this.semanticsValue,
  }) : super(key: key);

  final String semanticsValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      width: 24.0,
      child: CircularProgressIndicator(
        semanticsValue: semanticsValue,
      ),
    );
  }
}
