import 'package:app/src/application/theme/app_color_schemes.dart';
import 'package:app/src/application/theme/app_component_themes.dart';
import 'package:app/src/application/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

/// Builds the light and dark themes from the token set. Widgets read every
/// colour, text style and component shape from here through `Theme.of`.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColorSchemes.light);

  static ThemeData dark() => _build(AppColorSchemes.dark);

  static ThemeData _build(ColorScheme colors) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: AppTextTheme.textTheme,
      appBarTheme: AppComponentThemes.appBar(colors),
      filledButtonTheme: AppComponentThemes.filledButton(colors),
      textButtonTheme: AppComponentThemes.textButton(colors),
      inputDecorationTheme: AppComponentThemes.inputDecoration(colors),
      floatingActionButtonTheme: AppComponentThemes.floatingActionButton(
        colors,
      ),
      snackBarTheme: AppComponentThemes.snackBar(colors),
      dividerTheme: AppComponentThemes.divider(colors),
      progressIndicatorTheme: AppComponentThemes.progressIndicator(colors),
      iconButtonTheme: AppComponentThemes.iconButton(colors),
    );
  }
}
