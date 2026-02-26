import 'package:flutter/material.dart';

/// Design system spacing, radii, shadows and helpers
class Spacing {
  Spacing._();

  // Basic spacing values (px)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Alternative names
  static const double space1 = xs;
  static const double space2 = sm;
  static const double space3 = md;
  static const double space4 = lg;
  static const double space5 = xl;
  static const double space6 = xxl;
  static const double space8 = xxxl;

  // Border radius sizes
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 10.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;
  static const double radiusFull = 9999.0;

  // BorderRadius constants
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusXxl = BorderRadius.all(Radius.circular(radiusXxl));
  static const BorderRadius borderRadiusFull = BorderRadius.all(Radius.circular(radiusFull));

  // Shadow definitions (use withAlpha to avoid deprecated withOpacity)
  static List<BoxShadow> get shadowXs => [
        BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 4, offset: const Offset(0, 1)),
      ];

  static List<BoxShadow> get shadowSm => [
        BoxShadow(color: Colors.black.withAlpha((0.08 * 255).round()), blurRadius: 8, offset: const Offset(0, 2)),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(color: Colors.black.withAlpha((0.10 * 255).round()), blurRadius: 12, offset: const Offset(0, 4)),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(color: Colors.black.withAlpha((0.12 * 255).round()), blurRadius: 20, offset: const Offset(0, 8)),
      ];

  static List<BoxShadow> get shadowXl => [
        BoxShadow(color: Colors.black.withAlpha((0.15 * 255).round()), blurRadius: 30, offset: const Offset(0, 12)),
      ];

  // Elevation constants
  static const double elevationNone = 0;
  static const double elevationXs = 1;
  static const double elevationSm = 2;
  static const double elevationMd = 4;
  static const double elevationLg = 8;
  static const double elevationXl = 16;

  // Gap widgets
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);

  // Horizontal/vertical gap helpers
  static const SizedBox gapHorizontalSm = SizedBox(width: sm);
  static const SizedBox gapHorizontalMd = SizedBox(width: md);
  static const SizedBox gapHorizontalLg = SizedBox(width: lg);

  static const SizedBox gapVerticalSm = SizedBox(height: sm);
  static const SizedBox gapVerticalMd = SizedBox(height: md);
  static const SizedBox gapVerticalLg = SizedBox(height: lg);

  // Responsive helpers
  static double responsiveValue({required double width, required double mobile, required double tablet, required double desktop}) {
    if (width < 600) return mobile;
    if (width < 900) return tablet;
    return desktop;
  }

  static EdgeInsets responsivePadding({required double width, double mobile = 16, double tablet = 24, double desktop = 32}) {
    final p = responsiveValue(width: width, mobile: mobile, tablet: tablet, desktop: desktop);
    return EdgeInsets.all(p);
  }
}

