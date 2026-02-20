import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

/// A medium-sized card for actions with icon, title, description,
/// rounded corners and shadows. Used for quick actions section.
class FeatureCard extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// Gradient start color
  final Color gradientStart;
  
  /// Gradient end color
  final Color gradientEnd;
  
  /// Title text
  final String title;
  
  /// Description text
  final String? description;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.title,
    this.description,
    this.onTap,
  });

  /// Factory for Bible Reading Plan card
  factory FeatureCard.bibleReading({
    Key? key,
    String title = 'Bible Reading Plan',
    String? description = 'Start your daily reading journey',
    VoidCallback? onTap,
  }) {
    return FeatureCard(
      key: key,
      icon: Icons.menu_book,
      gradientStart: AppColors.blueGradientStart,
      gradientEnd: AppColors.blueGradientEnd,
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  /// Factory for Add Prayer card
  factory FeatureCard.addPrayer({
    Key? key,
    String title = 'Add Prayer',
    String? description = 'Record a new prayer request',
    VoidCallback? onTap,
  }) {
    return FeatureCard(
      key: key,
      icon: Icons.add_circle,
      gradientStart: AppColors.pinkGradientStart,
      gradientEnd: AppColors.pinkGradientEnd,
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  /// Factory for Habit Tracker card
  factory FeatureCard.habitTracker({
    Key? key,
    String title = 'Habit Tracker',
    String? description = 'Track your daily habits',
    VoidCallback? onTap,
  }) {
    return FeatureCard(
      key: key,
      icon: Icons.check_circle,
      gradientStart: AppColors.purpleGradientStart,
      gradientEnd: AppColors.purpleGradientEnd,
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  /// Factory for Progress Dashboard card
  factory FeatureCard.progressDashboard({
    Key? key,
    String title = 'Progress Dashboard',
    String? description = 'View your spiritual growth',
    VoidCallback? onTap,
  }) {
    return FeatureCard(
      key: key,
      icon: Icons.insights,
      gradientStart: AppColors.indigoGradientStart,
      gradientEnd: AppColors.indigoGradientEnd,
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: Spacing.shadowMd,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Row(
                children: [
                  // Icon in gradient container
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [gradientStart, gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(Spacing.radiusXl),
                      boxShadow: [
                        BoxShadow(
                          color: gradientStart.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: Spacing.md),
                  // Title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (description != null) ...[
                          const SizedBox(height: Spacing.xs),
                          Text(
                            description!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Arrow icon
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
