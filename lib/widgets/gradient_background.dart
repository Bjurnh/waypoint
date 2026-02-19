import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Gradient type enum for different gradient directions
enum GradientType {
  vertical,      // Top to bottom (bg-gradient-to-b)
  diagonal,      // Top-left to bottom-right
}

/// Screen gradient presets matching React app screens
enum ScreenGradient {
  home,
  prayer,
  progress,
  habit,
  profile,
  plan,
}

/// A reusable gradient background widget that matches the React app design
/// Supports different gradient colors and decorative blur elements
class GradientBackground extends StatelessWidget {
  /// The child widget to render on top of the gradient
  final Widget child;
  
  /// Gradient type - vertical or diagonal
  final GradientType gradientType;
  
  /// Start color of the gradient
  final Color startColor;
  
  /// Middle color of the gradient (optional, for 3-color gradients)
  final Color? midColor;
  
  /// End color of the gradient
  final Color endColor;
  
  /// Whether to show decorative blur elements (default: true)
  final bool showDecorative;
  
  /// Decorative blur color 1
  final Color? decorativeColor1;
  
  /// Decorative blur color 2  
  final Color? decorativeColor2;
  
  /// Position of first decorative blur (top-right, top-left, etc.)
  final AlignmentGeometry? decorativePosition1;
  
  /// Position of second decorative blur
  final AlignmentGeometry? decorativePosition2;

  const GradientBackground({
    super.key,
    required this.child,
    this.gradientType = GradientType.vertical,
    required this.startColor,
    this.midColor,
    required this.endColor,
    this.showDecorative = true,
    this.decorativeColor1,
    this.decorativeColor2,
    this.decorativePosition1,
    this.decorativePosition2,
  });

  /// Factory constructor for Home screen gradient
  factory GradientBackground.home({
    Key? key,
    required Widget child,
    bool showDecorative = true,
  }) {
    return GradientBackground(
      key: key,
      child: child,
      startColor: AppColors.homeGradientStart,
      midColor: AppColors.homeGradientMid,
      endColor: AppColors.homeGradientEnd,
      showDecorative: showDecorative,
      decorativeColor1: AppColors.blueDecorative,
      decorativeColor2: AppColors.purpleDecorative,
      decorativePosition1: Alignment.topRight,
      decorativePosition2: Alignment.topLeft,
    );
  }

  /// Factory constructor for Prayer Log screen gradient
  factory GradientBackground.prayer({
    Key? key,
    required Widget child,
    bool showDecorative = true,
  }) {
    return GradientBackground(
      key: key,
      child: child,
      startColor: AppColors.prayerGradientStart,
      midColor: AppColors.prayerGradientMid,
      endColor: AppColors.prayerGradientEnd,
      showDecorative: showDecorative,
      decorativeColor1: AppColors.pinkDecorative,
      decorativeColor2: AppColors.purpleDecorative,
      decorativePosition1: Alignment.topLeft,
      decorativePosition2: null,
    );
  }

  /// Factory constructor for Progress Dashboard screen gradient
  factory GradientBackground.progress({
    Key? key,
    required Widget child,
    bool showDecorative = true,
  }) {
    return GradientBackground(
      key: key,
      child: child,
      startColor: AppColors.progressGradientStart,
      midColor: AppColors.progressGradientMid,
      endColor: AppColors.progressGradientEnd,
      showDecorative: showDecorative,
      decorativeColor1: AppColors.indigoDecorative,
      decorativeColor2: AppColors.purpleDecorative,
      decorativePosition1: Alignment.topLeft,
      decorativePosition2: null,
    );
  }

  /// Factory constructor for Habit Tracking screen gradient
  factory GradientBackground.habit({
    Key? key,
    required Widget child,
    bool showDecorative = true,
  }) {
    return GradientBackground(
      key: key,
      child: child,
      startColor: AppColors.habitGradientStart,
      midColor: AppColors.habitGradientMid,
      endColor: AppColors.habitGradientEnd,
      showDecorative: showDecorative,
      decorativeColor1: AppColors.greenGradientStart,
      decorativeColor2: AppColors.tealGradientStart,
      decorativePosition1: Alignment.topRight,
      decorativePosition2: Alignment.bottomLeft,
    );
  }

  /// Factory constructor for Profile screen gradient
  factory GradientBackground.profile({
    Key? key,
    required Widget child,
    bool showDecorative = true,
  }) {
    return GradientBackground(
      key: key,
      child: child,
      startColor: AppColors.profileGradientStart,
      midColor: AppColors.profileGradientMid,
      endColor: AppColors.profileGradientEnd,
      showDecorative: showDecorative,
      decorativeColor1: AppColors.orangeGradientStart,
      decorativeColor2: AppColors.orangeGradientEnd,
      decorativePosition1: Alignment.topRight,
      decorativePosition2: null,
    );
  }

  /// Factory constructor for Plan Generation screen gradient
  factory GradientBackground.plan({
    Key? key,
    required Widget child,
    bool showDecorative = true,
  }) {
    return GradientBackground(
      key: key,
      child: child,
      startColor: AppColors.planGradientStart,
      midColor: AppColors.planGradientMid,
      endColor: AppColors.planGradientEnd,
      showDecorative: showDecorative,
      decorativeColor1: AppColors.purpleDecorative,
      decorativeColor2: AppColors.blueDecorative,
      decorativePosition1: Alignment.topRight,
      decorativePosition2: Alignment.bottomLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _buildGradient(),
      ),
      child: Stack(
        children: [
          // Decorative blur elements
          if (showDecorative) ...[
            if (decorativeColor1 != null)
              Positioned(
                top: 0,
                right: decorativePosition1 == Alignment.topRight || decorativePosition1 == Alignment.centerRight ? 0 : null,
                left: decorativePosition1 == Alignment.topLeft || decorativePosition1 == Alignment.centerLeft ? 0 : null,
                child: _buildDecorativeBlur(decorativeColor1!, 256, 256),
              ),
            if (decorativeColor2 != null && decorativePosition2 != null)
              Positioned(
                top: decorativePosition2 == Alignment.topLeft || decorativePosition2 == Alignment.topCenter ? 0 : null,
                bottom: decorativePosition2 == Alignment.bottomLeft || decorativePosition2 == Alignment.bottomCenter ? 0 : null,
                left: decorativePosition2 == Alignment.topLeft || decorativePosition2 == Alignment.centerLeft ? 0 : null,
                right: decorativePosition2 == Alignment.topRight || decorativePosition2 == Alignment.centerRight ? 0 : null,
                child: _buildDecorativeBlur(decorativeColor2!, 192, 192),
              ),
          ],
          // Main content
          child,
        ],
      ),
    );
  }

  LinearGradient _buildGradient() {
    if (midColor != null) {
      // 3-color gradient
      return LinearGradient(
        begin: gradientType == GradientType.vertical 
            ? Alignment.topCenter 
            : Alignment.topLeft,
        end: gradientType == GradientType.vertical 
            ? Alignment.bottomCenter 
            : Alignment.bottomRight,
        colors: [
          startColor,
          midColor!,
          endColor,
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    } else {
      // 2-color gradient
      return LinearGradient(
        begin: gradientType == GradientType.vertical 
            ? Alignment.topCenter 
            : Alignment.topLeft,
        end: gradientType == GradientType.vertical 
            ? Alignment.bottomCenter 
            : Alignment.bottomRight,
        colors: [startColor, endColor],
      );
    }
  }

  Widget _buildDecorativeBlur(Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.0),
          ],
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
