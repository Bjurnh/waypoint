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
    final planSubtitle = readings.isEmpty
        ? 'Create your personalized Bible reading plan to start your journey.'
        : 'Continue your daily journey through Scripture';

    return GradientBackground.home(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Bible Reading Plan'),
          leading: BackButton(onPressed: () => Navigator.maybePop(context)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.lg,
            ),
            child: readings.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Spacing.xl),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Spacing.sm),
                        child: Container(
                          padding: const EdgeInsets.all(Spacing.lg),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: Spacing.shadowLg,
                            border: Border.all(color: AppColors.cardBorderPlan),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_stories,
                                size: 72,
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
                                onPressed: () => Navigator.pushNamed(
                                    context, '/generate-plan'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.xl,
                                    vertical: Spacing.md,
                                  ),
                                  backgroundColor: AppColors.homeGradientStart,
                                  foregroundColor: AppColors.textPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
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
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.lg,
                      vertical: Spacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Bible Reading Plan',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          planSubtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: Spacing.xl),
                        GradientCard.withGradient(
                          gradientStart: AppColors.blueGradientStart,
                          gradientEnd: AppColors.blueGradientEnd,
                          padding: const EdgeInsets.all(Spacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.blueGradientStart,
                                          AppColors.blueGradientEnd,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: const Icon(
                                      Icons.menu_book,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: Spacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Today’s Progress',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: Spacing.xs),
                                        Text(
                                          '$completionPercentage% complete',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Spacing.md),
                              Text(
                                completedDays == readings.length
                                    ? 'Amazing work! All chapters completed for the plan.'
                                    : 'Keep going — ${readings.length - completedDays} readings left.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard.bibleReading(
                                value: '${readings.length}',
                                label: 'Days',
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
                        const SizedBox(height: Spacing.lg),
                        GradientCard.plan(
                          padding: const EdgeInsets.all(Spacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bible Reading Progress',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: Spacing.md),
                              ReadingProgressIndicator(
                                label: 'Chapters read',
                                chaptersRead:
                                    _calculateCompletedChapters(readings),
                                totalChapters:
                                    _calculateTotalChapters(readings),
                                currentBook: _getCurrentBook(readings),
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        FilledButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/generate-plan'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: Spacing.md),
                            backgroundColor: AppColors.homeGradientStart,
                            foregroundColor: AppColors.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Generate New Reading Plan',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reading Schedule',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                                vertical: Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.inputBackground,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                config.style,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.md),
                        Column(
                          children: readings.map((day) {
                            final dayDate = day.date;
                            final formattedDate =
                                dayDate.toIso8601String().split('T').first;
                            final available = !dayDate.isAfter(DateTime.now());
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: Spacing.lg),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: AppColors.cardBorderPlan),
                                  boxShadow: Spacing.shadowMd,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Spacing.lg),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 54,
                                            height: 54,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppColors.blueGradientStart,
                                                  AppColors.blueGradientEnd,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Spacing.radiusXl),
                                            ),
                                            child: const Icon(
                                              Icons.menu_book,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: Spacing.md),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Day ${day.id}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                                const SizedBox(
                                                    height: Spacing.xs),
                                                Text(
                                                  formattedDate,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color: AppColors
                                                              .textSecondary),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Spacing.sm,
                                              vertical: Spacing.xs,
                                            ),
                                            decoration: BoxDecoration(
                                              color: day.completed
                                                  ? AppColors.primary
                                                      .withOpacity(0.12)
                                                  : AppColors.inputBackground,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              day.completed
                                                  ? 'Completed'
                                                  : available
                                                      ? 'Pending'
                                                      : 'Upcoming',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: day.completed
                                                        ? AppColors.textSuccess
                                                        : AppColors
                                                            .textSecondary,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (day.chapters.isNotEmpty) ...[
                                        const SizedBox(height: Spacing.md),
                                        Wrap(
                                          spacing: Spacing.sm,
                                          runSpacing: Spacing.sm,
                                          children: day.chapters.map((chapter) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: Spacing.sm,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.inputBackground,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                chapter,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                      const SizedBox(height: Spacing.md),
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
                                                backgroundColor: day.completed
                                                    ? AppColors.secondary
                                                    : AppColors.homeGradientStart,
                                                foregroundColor: day.completed
                                                    ? AppColors.textSecondary
                                                    : AppColors.textPrimary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: Spacing.md,
                                                ),
                                              ),
                                              child: Text(
                                                day.completed
                                                    ? 'Completed'
                                                    : 'Mark Complete',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: day.completed
                                                      ? AppColors.textSecondary
                                                      : Colors.white,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: Spacing.md,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.inputBackground,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Available on $formattedDate',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  List<bool> _getWeeklyProgress(List<DayReading> readings) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final checkDate = weekStart.add(Duration(days: i));
      return readings.any((r) =>
          r.date.year == checkDate.year &&
          r.date.month == checkDate.month &&
          r.date.day == checkDate.day);
    });
  }

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

    final lastCompleted = readings.lastWhere(
      (reading) => reading.completed,
      orElse: () => readings.first,
    );

    if (lastCompleted.chapters.isNotEmpty) {
      final chapterLabel = lastCompleted.chapters.first;
      final parts = chapterLabel.split(' ');
      if (parts.length >= 2) {
        return parts.sublist(0, parts.length - 1).join(' ');
      }
    }

    return 'Genesis';
  }
}
