import 'package:app/src/application/theme/app_text_theme.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Component themes derived from a colour scheme. Kept apart from
/// `AppTheme` so each theme stays a short, named block.
abstract final class AppComponentThemes {
  static const double _toolbarHeight = 56;
  static const double _iconSize = 24;
  static const double _focusBorderWidth = 2;
  static const double _hairline = 1;
  static const double _fabSize = 56;
  static const double _fabElevation = 2;
  static const double _fabRaisedElevation = 4;
  static const double _progressStrokeWidth = 2.5;
  static const int _errorMaxLines = 2;
  static const Size _buttonMinimumSize = Size(64, 48);
  static const Size _textButtonMinimumSize = Size(48, 44);
  static const Size _iconButtonMinimumSize = Size(48, 48);

  static const RoundedRectangleBorder _roundedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(Radii.md)),
  );

  static AppBarTheme appBar(ColorScheme colors) {
    return AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: AppTextTheme.titleLarge.copyWith(color: colors.onSurface),
      toolbarHeight: _toolbarHeight,
      titleSpacing: 0,
      iconTheme: IconThemeData(size: _iconSize, color: colors.onSurface),
    );
  }

  /// Colours stay Material defaults so `FilledButton` reads `primary` and
  /// `FilledButton.tonal` reads `secondaryContainer`, which the scheme maps
  /// to `surfaceContainerHighest`.
  static FilledButtonThemeData filledButton(ColorScheme colors) {
    return FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(_buttonMinimumSize),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: Space.s5),
        ),
        shape: const WidgetStatePropertyAll(_roundedShape),
        textStyle: const WidgetStatePropertyAll(AppTextTheme.labelLarge),
        side: WidgetStateProperty.resolveWith(
          (states) => _keyboardFocusSide(colors, states),
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  static TextButtonThemeData textButton(ColorScheme colors) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        textStyle: AppTextTheme.labelLarge,
        minimumSize: _textButtonMinimumSize,
        padding: const EdgeInsets.symmetric(horizontal: Space.s3),
      ),
    );
  }

  static InputDecorationThemeData inputDecoration(ColorScheme colors) {
    return InputDecorationThemeData(
      border: _fieldBorder(colors.outline, _hairline),
      enabledBorder: _fieldBorder(colors.outline, _hairline),
      focusedBorder: _fieldBorder(colors.primary, _focusBorderWidth),
      errorBorder: _fieldBorder(colors.error, _hairline),
      focusedErrorBorder: _fieldBorder(colors.error, _focusBorderWidth),
      filled: false,
      fillColor: colors.surfaceContainerHighest,
      contentPadding: const EdgeInsets.all(Space.s4),
      labelStyle: AppTextTheme.bodyMedium.copyWith(
        color: colors.onSurfaceVariant,
      ),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
        (states) => AppTextTheme.bodySmall.copyWith(
          color: states.contains(WidgetState.error)
              ? colors.error
              : colors.primary,
        ),
      ),
      hintStyle: AppTextTheme.bodyLarge.copyWith(
        color: colors.onSurfaceVariant,
      ),
      helperStyle: AppTextTheme.bodySmall.copyWith(
        color: colors.onSurfaceVariant,
      ),
      errorStyle: AppTextTheme.bodySmall.copyWith(color: colors.error),
      errorMaxLines: _errorMaxLines,
    );
  }

  static FloatingActionButtonThemeData floatingActionButton(
    ColorScheme colors,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Radii.lg)),
      ),
      elevation: _fabElevation,
      hoverElevation: _fabRaisedElevation,
      focusElevation: _fabRaisedElevation,
      sizeConstraints: BoxConstraints.tightFor(
        width: _fabSize,
        height: _fabSize,
      ),
      iconSize: _iconSize,
    );
  }

  static SnackBarThemeData snackBar(ColorScheme colors) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colors.inverseSurface,
      contentTextStyle: AppTextTheme.bodyMedium.copyWith(
        color: colors.onInverseSurface,
      ),
      shape: _roundedShape,
      elevation: 0,
      insetPadding: const EdgeInsets.all(Space.s4),
      actionTextColor: colors.inversePrimary,
    );
  }

  static DividerThemeData divider(ColorScheme colors) {
    return DividerThemeData(
      color: colors.outlineVariant,
      thickness: _hairline,
      space: _hairline,
    );
  }

  static ProgressIndicatorThemeData progressIndicator(ColorScheme colors) {
    return ProgressIndicatorThemeData(
      color: colors.primary,
      strokeWidth: _progressStrokeWidth,
    );
  }

  static IconButtonThemeData iconButton(ColorScheme colors) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colors.onSurface,
        iconSize: _iconSize,
        minimumSize: _iconButtonMinimumSize,
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(Radii.md)),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  /// A visible ring for keyboard focus only; a hovered pointer already gets
  /// the overlay.
  static BorderSide? _keyboardFocusSide(
    ColorScheme colors,
    Set<WidgetState> states,
  ) {
    final isKeyboardFocused =
        states.contains(WidgetState.focused) &&
        !states.contains(WidgetState.hovered);
    if (!isKeyboardFocused) return null;
    return BorderSide(color: colors.primary, width: _focusBorderWidth);
  }
}
