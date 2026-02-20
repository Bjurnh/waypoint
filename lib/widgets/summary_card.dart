import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

/// A small card for displaying metrics (streak, prayers, etc.)
/// with icon in gradient box and number display with label.
/// Grid-friendly sizing - matches React's summary cards.
class SummaryCard extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// Gradient start color for icon container
  final Color gradientStart;
  
  /// Gradient end color for icon container
  final Color gradientEnd;
  
  /// The label text below the number
  final String label;
  
  /// The number to display
  final String value;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.label,
    required this.value,
    this.onTap,
  });

  /// Factory for Streak card (orange gradient)
  factory SummaryCard.streak({
    Key? key,
    required String value,
    String label = 'Day Streak',
    VoidCallback? onTap,
  }) {
    return SummaryCard(
      key: key,
      icon: Icons.local_fire_department,
      gradientStart: AppColors.orangeGradientStart,
      gradientEnd: AppColors.orangeGradientEnd,
      label: label,
      value: value,
      onTap: onTap,
    );
  }

  /// Factory for Prayers card (pink gradient)
  factory SummaryCard.prayers({
    Key? key,
    required String value,
    String label = 'Total Prayers',
    VoidCallback? onTap,
  }) {
    return SummaryCard(
      key: key,
      icon: Icons.favorite,
      gradientStart: AppColors.pinkGradientStart,
      gradientEnd: AppColors.pinkGradientEnd,
      label: label,
      value: value,
      onTap: onTap,
    );
  }

  /// Factory for Bible Reading card (blue gradient)
  factory SummaryCard.bibleReading({
    Key? key,
    required String value,
    String label = 'Chapters Read',
    VoidCallback? onTap,
  }) {
    return SummaryCard(
      key: key,
      icon: Icons.menu_book,
      gradientStart: AppColors.blueGradientStart,
      gradientEnd: AppColors.blueGradientEnd,
      label: label,
      value: value,
      onTap: onTap,
    );
  }

  /// Factory for Habits card (green gradient)
  factory SummaryCard.habits({
    Key? key,
    required String value,
    String label = 'Habits',
    VoidCallback? onTap,
  }) {
    return SummaryCard(
      key: key,
      icon: Icons.check_circle,
      gradientStart: AppColors.greenGradientStart,
      gradientEnd: AppColors.greenGradientEnd,
      label: label,
      value: value,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(Spacing.radiusXl),
          border: Border.all(color: AppColors.border),
          boxShadow: Spacing.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon in gradient container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [gradientStart, gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: Spacing.md),
            // Value number
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            // Label
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
