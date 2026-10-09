/// Spacing scale, 4-based. Every gap and padding in a widget reads one of
/// these instead of a literal.
abstract final class Space {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 24;
  static const double s6 = 32;
  static const double s7 = 48;
}

abstract final class Radii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 999;
}

/// Width of the centred content column a page caps itself at.
const double kColumnWidthForm = 400;
const double kColumnWidthFeed = 600;

/// Viewport width from which snackbars get a fixed width instead of margins.
const double kTabletBreakpoint = 768;
