import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

/// Habit visualization component showing weekly progress with streak indicator
/// 
/// Displays:
/// - Week progress visual (7 day circles, filled/unfilled)
/// - Streak counter with flame-like styling
/// - Habit name and completion rate
class HabitChart extends StatelessWidget {
  /// Habit name/title
  final String habitName;

  /// Completion status for each day of the week (0-6, Mon-Sun)
  /// true = completed, false = not completed
  final List<bool> weekProgress;

  /// Current streak count (consecutive days)
  final int streak;

  /// Icon to display for habit (optional)
  final IconData? icon;

  /// Color for the habit (used for progress circles and bar)
  final Color color;

  /// Callback when habit card is tapped
  final VoidCallback? onTap;

  /// Optional completion callback for logging
  final void Function(int dayIndex, bool completed)? onDayTapped;

  const HabitChart({
    required this.habitName,
    required this.weekProgress,
    required this.streak,
    this.icon,
    required this.color,
    this.onTap,
    this.onDayTapped,
    Key? key,
  }) : super(key: key);

  int get _completedDays => weekProgress.where((c) => c).length;
  int get _completionPercentage => (((_completedDays) / 7) * 100).toInt();

  static const List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(
            color: AppColors.border.withValues(alpha:0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon, name, streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (icon != null) ...[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color,
                                  color.withValues(alpha:0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: Spacing.md),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habitName,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foreground,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: Spacing.xs),
                              Text(
                                '$_completedDays/7 completed',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Spacing.md),
                  // Streak badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: color.withValues(alpha:0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: color,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '$streak',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Spacing.md),

              // Week progress circles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final completed = weekProgress[index];
                  return GestureDetector(
                    onTap: () => onDayTapped?.call(index, !completed),
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: completed ? color : AppColors.inputBackground,
                            border: Border.all(
                              color: completed
                                  ? color
                                  : AppColors.border.withValues(alpha:0.3),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: completed
                              ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        SizedBox(height: 4),
                        Text(
                          _dayLabels[index],
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: Spacing.md),

              // Completion percentage bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weekly Progress',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '$_completionPercentage%',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _completionPercentage / 100,
                      minHeight: 6,
                      backgroundColor: AppColors.inputBackground,
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simplified habit chart for grid display (smaller, more compact)
class HabitChartCompact extends StatelessWidget {
  final String habitName;
  final List<bool> weekProgress;
  final int streak;
  final Color color;
  final VoidCallback? onTap;

  const HabitChartCompact({
    required this.habitName,
    required this.weekProgress,
    required this.streak,
    required this.color,
    this.onTap,
    Key? key,
  }) : super(key: key);

  int get _completedDays => weekProgress.where((c) => c).length;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(
            color: AppColors.border.withValues(alpha:0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(Spacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      habitName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: Spacing.xs),
                  Icon(
                    Icons.local_fire_department,
                    size: 12,
                    color: color,
                  ),
                ],
              ),
              SizedBox(height: Spacing.xs),
              // Mini week circles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final completed = weekProgress[index];
                  return Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: completed ? color : AppColors.inputBackground,
                      border: Border.all(
                        color: completed
                            ? color
                            : AppColors.border.withValues(alpha:0.2),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: completed
                        ? Icon(
                            Icons.check,
                            size: 10,
                            color: Colors.white,
                          )
                        : null,
                  );
                }),
              ),
              SizedBox(height: Spacing.xs),
              // Mini progress text
              Text(
                '$_completedDays/7 • 🔥 $streak',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
