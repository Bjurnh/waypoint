import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

/// A custom card widget with gradient background, shadows, and borders.
/// Matches React's card design: "bg-white rounded-3xl p-6 shadow-lg border border-blue-100"
class GradientCard extends StatelessWidget {
  /// Child widget content
  final Widget child;
  
  /// Padding inside the card
  final EdgeInsets padding;
  
  /// Border radius
  final double borderRadius;
  
  /// Whether to show shadow
  final bool showShadow;
  
  /// Shadow intensity level: xs, sm, md, lg, xl
  final String shadowLevel;
  
  /// Border color
  final Color? borderColor;
  
  /// Background color override
  final Color? backgroundColor;
  
  /// Start gradient color for custom gradients
  final Color? gradientStart;
  
  /// End gradient color for custom gradients
  final Color? gradientEnd;
  
  /// Whether this is a flat white card (no gradient)
  final bool flat;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Spacing.lg),
    this.borderRadius = 20,
    this.showShadow = true,
    this.shadowLevel = 'md',
    this.borderColor,
    this.backgroundColor,
    this.gradientStart,
    this.gradientEnd,
    this.flat = false,
    this.onTap,
  });

  /// Factory for home screen cards (blue border)
  factory GradientCard.home({
    Key? key,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(Spacing.lg),
  }) {
    return GradientCard(
      key: key,
      child: child,
      padding: padding,
      borderColor: AppColors.cardBorderHome,
    );
  }

  /// Factory for prayer screen cards (pink border)
  factory GradientCard.prayer({
    Key? key,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(Spacing.lg),
  }) {
    return GradientCard(
      key: key,
      child: child,
      padding: padding,
      borderColor: AppColors.cardBorderPrayer,
    );
  }

  /// Factory for progress screen cards (purple border)
  factory GradientCard.progress({
    Key? key,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(Spacing.lg),
  }) {
    return GradientCard(
      key: key,
      child: child,
      padding: padding,
      borderColor: AppColors.cardBorderProgress,
    );
  }

  /// Factory for habit screen cards (green border)
  factory GradientCard.habit({
    Key? key,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(Spacing.lg),
  }) {
    return GradientCard(
      key: key,
      child: child,
      padding: padding,
      borderColor: AppColors.cardBorderHabit,
    );
  }

  /// Factory for plan screen cards (violet border)
  factory GradientCard.plan({
    Key? key,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(Spacing.lg),
  }) {
    return GradientCard(
      key: key,
      child: child,
      padding: padding,
      borderColor: AppColors.cardBorderPlan,
    );
  }

  /// Factory for cards with custom gradient
  factory GradientCard.withGradient({
    Key? key,
    required Widget child,
    required Color gradientStart,
    required Color gradientEnd,
    EdgeInsets padding = const EdgeInsets.all(Spacing.lg),
    double borderRadius = 20,
  }) {
    return GradientCard(
      key: key,
      child: child,
      padding: padding,
      gradientStart: gradientStart,
      gradientEnd: gradientEnd,
      borderRadius: borderRadius,
    );
  }

  List<BoxShadow> _getShadow() {
    if (!showShadow) return [];
    
    switch (shadowLevel) {
      case 'xs':
        return Spacing.shadowXs;
      case 'sm':
        return Spacing.shadowSm;
      case 'md':
        return Spacing.shadowMd;
      case 'lg':
        return Spacing.shadowLg;
      case 'xl':
        return Spacing.shadowXl;
      default:
        return Spacing.shadowMd;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.card;
    final bColor = borderColor ?? AppColors.border;
    
    final cardWidget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: flat ? null : (gradientStart != null ? null : bgColor),
        gradient: (gradientStart != null && gradientEnd != null)
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradientStart!, gradientEnd!],
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: bColor, width: 1),
        boxShadow: _getShadow(),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
