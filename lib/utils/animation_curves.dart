import 'package:flutter/material.dart';

/// Reusable animation definitions for consistent animations throughout the app
/// Matches React's CSS transition patterns with standardized curves and durations
class AppAnimationCurves {
  AppAnimationCurves._();

  // ============================================
  // Duration Constants (matching React patterns)
  // ============================================

  /// 200ms - Quick interactions (hover, active states)
  static const Duration durationQuick = Duration(milliseconds: 200);

  /// 300ms - Standard transitions (card animations, state changes)
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// 500ms - Longer animations (expansion, celebration effects)
  static const Duration durationLong = Duration(milliseconds: 500);

  /// 800ms - Slow animations (celebration dialogs, complex reveals)
  static const Duration durationSlow = Duration(milliseconds: 800);

  /// 1000ms - Very slow animations (stream completions, major state changes)
  static const Duration durationVerySlow = Duration(milliseconds: 1000);

  // ============================================
  // Curve Definitions
  // ============================================

  /// Ease out curve - swift start, slow end (default for most UI)
  /// Similar to React's default `ease-out`
  static const Curve easeOut = Curves.easeOut;

  /// Ease in curve - slow start, swift end
  static const Curve easeIn = Curves.easeIn;

  /// Ease in-out curve - slow start and end, swift middle
  static const Curve easeInOut = Curves.easeInOut;

  /// Linear curve - constant speed (for continuous animations like rotating)
  static const Curve linear = Curves.linear;

  /// Elastic curve - bouncy effect with overshoot
  static const Curve elastic = Curves.elasticOut;

  /// Bounce curve - bouncy effect at end
  static const Curve bounce = Curves.bounceOut;

  /// Fast out, slow in - common for UI (material standard)
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // ============================================
  // Common Animation Combinations
  // ============================================

  /// Quick fade - 200ms easeOut (button hover states)
  static const AnimationConfiguration quickFade = AnimationConfiguration(
    duration: durationQuick,
    curve: easeOut,
  );

  /// Standard fade - 300ms easeOut (card appears)
  static const AnimationConfiguration standardFade = AnimationConfiguration(
    duration: durationMedium,
    curve: easeOut,
  );

  /// Scale animation - 300ms easeOut (button press effect)
  static const AnimationConfiguration scaleAnimation = AnimationConfiguration(
    duration: durationMedium,
    curve: easeOut,
  );

  /// Celebration animation - 800ms elasticOut (streak milestone, achievement)
  static const AnimationConfiguration celebration = AnimationConfiguration(
    duration: durationSlow,
    curve: elastic,
  );

  /// Slide animation - 300ms easeOut (drawer, modal entry)
  static const AnimationConfiguration slideAnimation = AnimationConfiguration(
    duration: durationMedium,
    curve: easeOut,
  );

  /// Chart animation - 1000ms easeOut (data visualization load)
  static const AnimationConfiguration chartAnimation = AnimationConfiguration(
    duration: durationVerySlow,
    curve: easeOut,
  );

  // ============================================
  // Tween Definitions (reusable animation values)
  // ============================================

  /// Scale from 0.98 to 1.0 (active/press effect)
  /// React equivalent: active:scale-[0.98]
  static Tween<double> activePressScale() {
    return Tween<double>(begin: 0.98, end: 1.0);
  }

  /// Scale from 1.0 to 1.02 (hover effect)
  /// React equivalent: hover:scale-[1.02]
  static Tween<double> hoverScale() {
    return Tween<double>(begin: 1.0, end: 1.02);
  }

  /// Opacity animation from 0 to 1 (fade in)
  static Tween<double> fadeIn() {
    return Tween<double>(begin: 0.0, end: 1.0);
  }

  /// Offset animation from left (-50) to 0 (slide in from left)
  static Tween<Offset> slideInFromLeft() {
    return Tween<Offset>(begin: const Offset(-0.5, 0.0), end: Offset.zero);
  }

  /// Offset animation from right (50) to 0 (slide in from right)
  static Tween<Offset> slideInFromRight() {
    return Tween<Offset>(begin: const Offset(0.5, 0.0), end: Offset.zero);
  }

  /// Offset animation from bottom to 0 (slide in from bottom)
  static Tween<Offset> slideInFromBottom() {
    return Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero);
  }

  /// Rotation from 0 to full rotation (360 degrees)
  static Tween<double> fullRotation() {
    return Tween<double>(begin: 0.0, end: 1.0);
  }

  // ============================================
  // Animation Builders Helper Methods
  // ============================================

  /// Create a complete fade-in animation
  /// Usage: animateWithCurve(fadeIn(), durationMedium, easeOut)
  static Animation<double> createFadeInAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: easeOut),
    );
  }

  /// Create a scale animation for button press effect
  /// Usage: provides visual feedback when tapping buttons
  static Animation<double> createScaleAnimation(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: controller, curve: easeOut),
    );
  }

  /// Create a celebration bounce animation
  /// Usage: for milestone achievements, streaks, etc.
  static Animation<double> createCelebrationAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: elastic),
    );
  }
}

/// Simple animation configuration class to hold duration + curve
class AnimationConfiguration {
  final Duration duration;
  final Curve curve;

  const AnimationConfiguration({
    required this.duration,
    required this.curve,
  });
}
