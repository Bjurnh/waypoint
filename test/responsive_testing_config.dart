/// Responsive Testing Configuration
/// Defines test screen sizes for testing on phones, tablets, and larger devices

class ResponsiveScreenSize {
  final String name;
  final double width;
  final double height;
  final double devicePixelRatio;
  final String deviceType;

  const ResponsiveScreenSize({
    required this.name,
    required this.width,
    required this.height,
    required this.devicePixelRatio,
    required this.deviceType,
  });

  @override
  String toString() => '$name (${width}x${height}@${devicePixelRatio}x) - $deviceType';
}

class ResponsiveTestConfig {
  /// iPhone 13 Mini
  static final ResponsiveScreenSize iPhone13Mini = ResponsiveScreenSize(
    name: 'iPhone 13 Mini',
    width: 375,
    height: 812,
    devicePixelRatio: 3.0,
    deviceType: 'phone',
  );

  /// iPhone 14 (standard)
  static final ResponsiveScreenSize iPhone14 = ResponsiveScreenSize(
    name: 'iPhone 14',
    width: 390,
    height: 844,
    devicePixelRatio: 3.0,
    deviceType: 'phone',
  );

  /// iPhone 14 Pro Max (large phone)
  static final ResponsiveScreenSize iPhone14ProMax = ResponsiveScreenSize(
    name: 'iPhone 14 Pro Max',
    width: 430,
    height: 932,
    devicePixelRatio: 3.0,
    deviceType: 'phone',
  );

  /// Samsung Galaxy S21
  static final ResponsiveScreenSize galaxyS21 = ResponsiveScreenSize(
    name: 'Samsung Galaxy S21',
    width: 360,
    height: 800,
    devicePixelRatio: 2.625,
    deviceType: 'phone',
  );

  /// Samsung Galaxy S23 Ultra (large Android phone)
  static final ResponsiveScreenSize galaxyS23Ultra = ResponsiveScreenSize(
    name: 'Samsung Galaxy S23 Ultra',
    width: 480,
    height: 1440,
    devicePixelRatio: 3.5,
    deviceType: 'phone',
  );

  /// iPad Mini
  static final ResponsiveScreenSize iPadMini = ResponsiveScreenSize(
    name: 'iPad Mini',
    width: 768,
    height: 1024,
    devicePixelRatio: 2.0,
    deviceType: 'tablet',
  );

  /// iPad Air
  static final ResponsiveScreenSize iPadAir = ResponsiveScreenSize(
    name: 'iPad Air',
    width: 820,
    height: 1180,
    devicePixelRatio: 2.0,
    deviceType: 'tablet',
  );

  /// iPad Pro 11"
  static final ResponsiveScreenSize iPadPro11 = ResponsiveScreenSize(
    name: 'iPad Pro 11"',
    width: 834,
    height: 1194,
    devicePixelRatio: 2.0,
    deviceType: 'tablet',
  );

  /// iPad Pro 12.9"
  static final ResponsiveScreenSize iPadPro129 = ResponsiveScreenSize(
    name: 'iPad Pro 12.9"',
    width: 1024,
    height: 1366,
    devicePixelRatio: 2.0,
    deviceType: 'tablet',
  );

  /// Samsung Galaxy Tab S8
  static final ResponsiveScreenSize galaxyTabS8 = ResponsiveScreenSize(
    name: 'Samsung Galaxy Tab S8',
    width: 800,
    height: 1280,
    devicePixelRatio: 1.5,
    deviceType: 'tablet',
  );

  /// All test screen sizes
  static final List<ResponsiveScreenSize> allScreenSizes = [
    iPhone13Mini,
    iPhone14,
    iPhone14ProMax,
    galaxyS21,
    galaxyS23Ultra,
    iPadMini,
    iPadAir,
    iPadPro11,
    iPadPro129,
    galaxyTabS8,
  ];

  /// Phone-only test sizes
  static final List<ResponsiveScreenSize> phoneSizes = [
    iPhone13Mini,
    iPhone14,
    iPhone14ProMax,
    galaxyS21,
    galaxyS23Ultra,
  ];

  /// Tablet-only test sizes
  static final List<ResponsiveScreenSize> tabletSizes = [
    iPadMini,
    iPadAir,
    iPadPro11,
    iPadPro129,
    galaxyTabS8,
  ];
}

/// Standard test breakpoints
class TestBreakpoints {
  static const double phoneMaxWidth = 500;
  static const double tabletMinWidth = 500;
  static const double tabletMaxWidth = 1200;
  static const double desktopMinWidth = 1200;
}

/// Performance baseline targets
class PerformanceBaselines {
  /// Maximum time for screen build (milliseconds)
  static const int screenBuildTimeMax = 500;

  /// Minimum FPS for smooth animations (should target 60)
  static const double animationFPSTarget = 60.0;

  /// Maximum acceptable jank (dropped frames)
  static const int maxJank = 5;

  /// Maximum memory usage per screen (MB)
  static const int maxMemoryUsageMB = 200;

  /// Acceptable animation duration (milliseconds)
  static const int animationDurationMs = 300;
}
