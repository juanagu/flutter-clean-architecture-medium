import 'package:flutter/material.dart';

/// Type scale on the platform default family (Roboto / SF). Only the roles
/// the screens use are set; the rest keep Material defaults. Colours come
/// from the colour scheme when `ThemeData` merges this in.
abstract final class AppTextTheme {
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  static const TextStyle labelLarge = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const TextTheme textTheme = TextTheme(
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
  );
}
