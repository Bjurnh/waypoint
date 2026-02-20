import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

/// Animated celebration dialog for streak milestones and achievements
/// Shows achievement content with animation and celebration effects
class StreakCelebrationDialog extends StatefulWidget {
  /// Current streak count
  final int streak;

  /// Milestone number (optional, e.g., 7, 14, 30)
  final int? milestone;

  /// Achievement title
  final String? title;

  /// Achievement message/description
  final String? message;

  /// Achievement type for custom styling
  final AchievementType type;

  /// Callback when dialog closes
  final VoidCallback? onClose;

  /// Whether to show confetti animation
  final bool showAnimation;

  const StreakCelebrationDialog({
    super.key,
    required this.streak,
    this.milestone,
    this.title,
    this.message,
    this.type = AchievementType.streak,
    this.onClose,
    this.showAnimation = true,
  });

  @override
  State<StreakCelebrationDialog> createState() =>
      _StreakCelebrationDialogState();
}

enum AchievementType {
  streak,
  prayer,
  reading,
  habit,
  custom,
}

class _StreakCelebrationDialogState extends State<StreakCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _accentColor {
    switch (widget.type) {
      case AchievementType.streak:
        return const Color(0xFFFB923C); // orange
      case AchievementType.prayer:
        return AppColors.pinkGradientStart;
      case AchievementType.reading:
        return AppColors.blueGradientStart;
      case AchievementType.habit:
        return AppColors.greenGradientStart;
      case AchievementType.custom:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case AchievementType.streak:
        return Icons.whatshot;
      case AchievementType.prayer:
        return Icons.favorite;
      case AchievementType.reading:
        return Icons.auto_stories;
      case AchievementType.habit:
        return Icons.check_circle;
      case AchievementType.custom:
        return Icons.star;
    }
  }

  String get _defaultTitle {
    switch (widget.type) {
      case AchievementType.streak:
        if (widget.milestone != null && widget.streak >= widget.milestone!) {
          return '🔥 ${widget.milestone} Day Streak!';
        }
        return '🔥 Keep Going!';
      case AchievementType.prayer:
        return '💝 Amazing Prayer Dedication!';
      case AchievementType.reading:
        return '📖 Reading Master!';
      case AchievementType.habit:
        return '✨ Habit Champion!';
      case AchievementType.custom:
        return '🏆 Achievement Unlocked!';
    }
  }

  String get _defaultMessage {
    switch (widget.type) {
      case AchievementType.streak:
        return 'You\'ve been consistent for ${widget.streak} days!\n\nKeep up the amazing work!';
      case AchievementType.prayer:
        return 'Your prayers matter. Thank you for staying\ndevoted to your spiritual journey.';
      case AchievementType.reading:
        return 'You\'re making incredible progress\nwith your daily Bible reading!';
      case AchievementType.habit:
        return 'Building habits takes dedication.\nYou\'re doing fantastic!';
      case AchievementType.custom:
        return 'You\'ve achieved something amazing!\nCelebrate this win.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusXxxl),
      ),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Spacing.radiusXxxl),
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated icon
                  ScaleTransition(
                    scale: Tween(begin: 0.0, end: 1.2)
                        .animate(_animationController),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            _accentColor,
                            _accentColor.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _icon,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: Spacing.lg),

                  // Title
                  Text(
                    widget.title ?? _defaultTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),

                  const SizedBox(height: Spacing.md),

                  // Message
                  Text(
                    widget.message ?? _defaultMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                  ),

                  const SizedBox(height: Spacing.lg),

                  // Streak counter (if relevant)
                  if (widget.type == AchievementType.streak)
                    Container(
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Spacing.radiusLg),
                        border: Border.all(
                          color: _accentColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today,
                              color: _accentColor, size: 20),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            '${widget.streak} day streak',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: Spacing.lg),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Spacing.radiusLg),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onClose?.call();
                      },
                      child: const Text(
                        'Celebrate! 🎉',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
