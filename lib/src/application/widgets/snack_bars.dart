import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:flutter/material.dart';

const double _wideSnackBarWidth = 400;

/// Shows the translation of [key] in the nearest ScaffoldMessenger. On a
/// wide viewport the bar takes a fixed width instead of the side margins.
void showTranslatedSnackBar(BuildContext context, String key) {
  final isWide = MediaQuery.sizeOf(context).width >= kTabletBreakpoint;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(I18n.of(context).translate(key)),
      width: isWide ? _wideSnackBarWidth : null,
    ),
  );
}
