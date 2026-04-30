import 'package:flutter/material.dart';
import 'package:waypoint_app/models/day_reading.dart';
import 'package:provider/provider.dart';
import 'package:waypoint_app/state/app_state.dart';
import '../models/plan_config.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';
import '../widgets/reading_progress_chart.dart';
import '../widgets/summary_card.dart';

class BiblePlanScreen extends StatelessWidget {
  const BiblePlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final readings = app.readings;
    final config = app.config ??
        PlanConfig(length: 30, startDate: DateTime.now(), style: 'sequential');
    final completedDays = readings.where((r) => r.completed).length;
    final completionPercentage =
        (completedDays / (readings.isEmpty ? 1 : readings.length) * 100)
            .toInt();
    final weeklyProgress = _getWeeklyProgress(readings);

    // If no readings, show plan generation prompt
    if (readings.isEmpty) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Bible Reading Plan'),
          leading: BackButton(onPressed: () => Navigator.maybePop(context)),
        ),
        body: Stack(
          children: [
            GradientBackground(
              startColor: Colors.indigo.withValues(alpha: 0.05),
              midColor: Colors.blue.withValues(alpha: 0.05),
              endColor: Colors.white,
              child: Container(),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_stories,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: Spacing.lg),
                    const Text(
                      'No Reading Plan Yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    const Text(
                      'Create your personalized Bible reading plan to start your journey.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xl),
                    FilledButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/generate-plan'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xl,
                          vertical: Spacing.md,
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        'Create Reading Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Bible Reading Plan'),
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
      ),
      body: Stack(
        children: [
          GradientBackground(
            startColor: Colors.indigo.withValues(alpha: 0.05),
            midColor: Colors.blue.withValues(alpha: 0.05),
            endColor: Colors.white,
            child: Container(),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + Spacing.lg,
              left: Spacing.lg,
              right: Spacing.lg,
              bottom: Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top summary row (Days / Streak / Completed)
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha: 0.2),
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard.bibleReading(
                              value: '${readings.length}',
                              label: 'Days',
                              onTap: null,
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: SummaryCard.streak(
                              value: '${app.currentStreak}',
                              label: 'Streak',
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: SummaryCard.habits(
                              value: '$completedDays',
                              label: 'Completed',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${config.length}-Day Plan',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: Spacing.xs),
                              Text(
                                  'Started ${config.startDate.toIso8601String().split('T').first}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.textSecondary)),
                            ],
                          ),
                          Text('$completionPercentage%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                // Weekly Stats
                Row(
                  children: [
                    Expanded(
                      child: GradientCard(
                        borderColor: AppColors.border.withValues(alpha: 0.2),
                        child: Column(
                          children: [
                            Text(
                              'This Week',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: Spacing.sm),
                            Text(
                              '${weeklyProgress.where((c) => c).length}/7',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                            ),
                            const SizedBox(height: Spacing.xs),
                            Text(
                              'days completed',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: GradientCard(
                        borderColor: AppColors.border.withValues(alpha: 0.2),
                        child: Column(
                          children: [
                            Text(
                              'Days Left',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: Spacing.sm),
                            Text(
                              '${readings.length - completedDays}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                            ),
                            const SizedBox(height: Spacing.xs),
                            Text(
                              'readings',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.lg),

                // Reading Progress Chart
                ReadingProgressIndicator(
                  label: 'Bible Reading Progress',
                  chaptersRead: _calculateCompletedChapters(readings),
                  totalChapters: _calculateTotalChapters(readings),
                  currentBook: _getCurrentBook(readings),
                  color: AppColors.primary,
                ),
                const SizedBox(height: Spacing.lg),

                // Generate New Plan Button
                FilledButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/generate-plan'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'Generate New Reading Plan',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                // Reading Schedule header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reading Schedule',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm, vertical: Spacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(config.style,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary)),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),

                // Schedule list
                Column(
                  children: readings.map((day) {
                    // day.date is a DateTime now
                    final dayDate = day.date;
                    final formattedDate =
                        dayDate.toIso8601String().split('T').first;
                    final available = !dayDate.isAfter(DateTime.now());
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GradientCard.plan(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // circle indicator
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.border),
                                  ),
                                ),
                                const SizedBox(width: Spacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Day $formattedDate',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600)),
                                      const SizedBox(height: Spacing.xs),
                                      Text(formattedDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color:
                                                      AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: Spacing.md),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.md,
                                      vertical: Spacing.xs),
                                  decoration: BoxDecoration(
                                    color: day.completed
                                        ? AppColors.primary
                                            .withValues(alpha: 0.12)
                                        : AppColors.inputBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                      day.completed
                                          ? 'Completed'
                                          : 'Not Completed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: AppColors.textSecondary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: Spacing.md),
                            // Chapters
                            Column(
                              children: day.chapters
                                  .map((c) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Spacing.md,
                                              vertical: Spacing.sm),
                                          decoration: BoxDecoration(
                                            color: AppColors.inputBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.menu_book,
                                                  color: AppColors.primary,
                                                  size: 18),
                                              const SizedBox(width: Spacing.md),
                                              Expanded(
                                                  child: Text(c,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium)),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: Spacing.md),
                            // action area
                            available
                                ? FilledButton(
                                    onPressed: day.completed
                                        ? null
                                        : () {
                                            context
                                                .read<AppState>()
                                                .toggleReadingCompletion(
                                                    day.id);
                                          },
                                    style: FilledButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: Spacing.md)),
                                    child: Text(
                                        day.completed
                                            ? 'Completed'
                                            : 'Mark as Complete',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(color: Colors.white)),
                                  )
                                : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Spacing.md),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputBackground,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                        child: Text(
                                            'Available on $formattedDate',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: AppColors
                                                        .textSecondary))),
                                  ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<bool> _getWeeklyProgress(List<DayReading> readings) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final checkDate = weekStart.add(Duration(days: i));
      // compare date fields instead of string equality
      return readings.any((r) =>
          r.date.year == checkDate.year &&
          r.date.month == checkDate.month &&
          r.date.day == checkDate.day);
    });
  }

  // Helper methods for progress calculation
  int _calculateCompletedChapters(List<DayReading> readings) {
    return readings
        .where((reading) => reading.completed)
        .fold<int>(0, (sum, reading) => sum + reading.chapters.length);
  }

  int _calculateTotalChapters(List<DayReading> readings) {
    return readings.fold<int>(
        0, (sum, reading) => sum + reading.chapters.length);
  }

  String _getCurrentBook(List<DayReading> readings) {
    if (readings.isEmpty) return 'Genesis';

    // Find the last completed reading or the first upcoming reading
    final lastCompleted = readings.lastWhere(
      (reading) => reading.completed,
      orElse: () => readings.first,
    );

    if (lastCompleted.chapters.isNotEmpty) {
      // Extract book name from chapter label (e.g., "Genesis 1" -> "Genesis")
      final chapterLabel = lastCompleted.chapters.first;
      final parts = chapterLabel.split(' ');
      if (parts.length >= 2) {
        return parts.sublist(0, parts.length - 1).join(' ');
      }
    }

    return 'Genesis';
  }
}
