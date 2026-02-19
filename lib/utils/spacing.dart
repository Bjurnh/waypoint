import 'package:flutter/material.dart';

/// Spacing, border radius, and shadow constants matching React/Tailwind CSS
/// Part of the Design System Foundation
class Spacing {
  Spacing._();

  // ============================================
  // Spacing Constants (matching Tailwind spacing scale)
  // ============================================
  
  /// 4px
  static const double xs = 4;
  
  /// 8px
  static const double sm = 8;
  
  /// 12px
  static const double md = 12;
  
  /// 16px
  static const double lg = 16;
  
  /// 20px
  static const double xl = 20;
  
  /// 24px
  static const double xxl = 24;
  
  /// 32px
  static const double xxxl = 32;
  
  /// 40px
  static const double xxxxl = 40;
  
  /// 48px
  static const double huge = 48;
  
  // Alternative naming convention (matching app_theme.dart)
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;

  // ============================================
  // Border Radius Constants
  // ============================================
  
  /// 4px - Small elements like badges, chips
  static const double radiusXs = 4;
  
  /// 8px - Buttons, inputs, small cards
  static const double radiusSm = 8;
  
  /// 10px - Medium cards
  static const double radiusMd = 10;
  
  /// 12px - Large cards, modals
  static const double radiusLg = 12;
  
  /// 16px - Buttons, inputs
  static const double radiusXl = 16;
  
  /// 20px - Cards, containers
  static const double radiusXxl = 20;
  
  /// 24px - Large containers
  static const double radiusXxxl = 24;
  
  /// Fully rounded (9999px)
  static const double radiusFull = 9999;

  // Border Radius Objects
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(4));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(10));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(12));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(16));
  static const BorderRadius borderRadiusXxl = BorderRadius.all(Radius.circular(20));
  static const BorderRadius borderRadiusXxxl = BorderRadius.all(Radius.circular(24));
  static const BorderRadius borderRadiusFull = BorderRadius.all(Radius.circular(9999));

  // ============================================
  // Shadow/Elevation Definitions
  // ============================================
  
  /// Very small shadow - subtle elevation
  static List<BoxShadow> get shadowXs => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  /// Small shadow - cards, buttons
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Medium shadow - elevated cards
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Large shadow - modals, popovers
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Extra large shadow - dialogs
  static List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 30,
      offset: const Offset(0, 12),
    ),
  ];

  // Material 3 Elevation Overrides
  static const double elevationNone = 0;
  static const double elevationXs = 1;
  static const double elevationSm = 2;
  static const double elevationMd = 4;
  static const double elevationLg = 8;
  static const double elevationXl = 16;
  static const double elevationXxl = 24;

  // ============================================
  // Gap Spacing Utilities (for Row/Column spacing)
  // ============================================
  
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXxl = SizedBox(width: xxl, height: xxxl);

  // Horizontal gaps only
  static const SizedBox gapHorizontalXs = SizedBox(width: xs);
  static const SizedBox gapHorizontalSm = SizedBox(width: sm);
  static const SizedBox gapHorizontalMd = SizedBox(width: md);
  static const SizedBox gapHorizontalLg = SizedBox(width: lg);
  static const SizedBox gapHorizontalXl = SizedBox(width: xl);
  static const SizedBox gapHorizontalXxl = SizedBox(width: xxl);

  // Vertical gaps only
  static const SizedBox gapVerticalXs = SizedBox(height: xs);
  static const SizedBox gapVerticalSm = SizedBox(height: sm);
  static const SizedBox gapVerticalMd = SizedBox(height: md);
  static const SizedBox gapVerticalLg = SizedBox(height: lg);
  static const SizedBox gapVerticalXl = SizedBox(height: xl);
  static const SizedBox gapVerticalXxl = SizedBox(height: xxl);

  // ============================================
  // Responsive Sizing Utilities
  // ============================================
  
  /// Get responsive value based on screen width
  static double responsive({
    required double mobile,
    required double tablet,
    required double desktop,
    required double width,
  }) {
    if (width < 600) return mobile;
    if (width < 900) return tablet;
    return desktop;
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding({
    required double width,
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
  }) {
    final padding = responsive(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      width: width,
    );
    return EdgeInsets.all(padding);
  }

  /// Get responsive horizontal padding
  static EdgeInsets responsiveHorizontalPadding({
    required double width,
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
  }) {
    final padding = responsive(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      width: width,
    );
    return EdgeInsets.symmetric(horizontal: padding);
  }

  /// Get responsive vertical padding
  static EdgeInsets responsiveVerticalPadding({
    required double width,
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
  }) {
    final padding = responsive(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      width: width,
    );
    return EdgeInsets.symmetric(vertical: padding);
  }
}
