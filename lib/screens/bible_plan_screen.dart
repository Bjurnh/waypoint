import 'package:flutter/material.dart';
import 'package:waypoint/models/day_reading.dart';
import 'package:provider/provider.dart';
import 'package:waypoint/state/app_state.dart';
import '../models/plan_config.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';
import '../widgets/reading_progress_chart.dart';
import '../widgets/summary_card.dart';
import '../widgets/status_bar_style.dart';

class BiblePlanScreen extends StatelessWidget {
  const BiblePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.select<AppState, PlanConfig?>((app) => app.config) ??
        PlanConfig(length: 30, startDate: DateTime.now(), style: 'sequential');

    final readings = context.select<AppState, List<DayReading>>((app) => app.readings);

    final completedDays = readings.where((r) => r.completed).length;
    final completionPercentage =
        (completedDays / (readings.isEmpty ? 1 : readings.length) * 100);


    final planSubtitle = readings.isEmpty
        ? 'Create your personalized Bible reading plan to start your journey.'
        : 'Continue your daily journey through Scripture';

    // Debug: confirm header sees updated completion state.
    final debugCompletedIds = readings.where((r) => r.completed).map((r) => r.id).toList();
    // ignore: avoid_print
    print('BiblePlanScreen.build: completedDays=$completedDays completionPercentage=$completionPercentage completedIds=${debugCompletedIds.take(3).toList()}');



    return StatusBarStyle(

      child: GradientBackground.home(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
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
                              GradientCard.withGradient(
                                gradientStart: AppColors.blueGradientStart,
                                gradientEnd: AppColors.blueGradientEnd,
                                borderRadius: 20,
                                padding: EdgeInsets.zero,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/generate-plan'),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.xl,
                                        vertical: Spacing.md,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                    child: const Text(
                                      'Create Reading Plan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
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
                        GradientCard.plan(
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
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: Spacing.xs),
                                        Text(
                                          '${completionPercentage.toStringAsFixed(1)}% complete',
                                          style: const TextStyle(
                                            fontSize: 22,

                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
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
                                  color: AppColors.textSecondary,
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
                                value: '${context.select<AppState, int>((a) => a.currentStreak)}',
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
                        GradientCard.withGradient(
                          gradientStart: AppColors.blueGradientStart,
                          gradientEnd: AppColors.blueGradientEnd,
                          borderRadius: 20,
                          padding: const EdgeInsets.all(0),
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/generate-plan'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Spacing.md),
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide.none,
                                ),
                              ),
                              child: Text(
                                'Generate New Reading Plan',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
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
                          children: readings.asMap().entries.map((entry) {
                            final dayIndex = entry.key;
                            final day = entry.value;
                            final dayDate = day.date;
                            final formattedDate = _formatMonthDayYear(dayDate);
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
                                                  'Day ${dayIndex + 1} reading',
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
                                          ? (day.completed
                                              ? FilledButton(
                                                  onPressed: null,
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.secondary,
                                                    foregroundColor:
                                                        AppColors.textSecondary,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                      vertical: Spacing.md,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Completed',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.textSecondary,
                                                    ),
                                                  ),
                                                )
                                              : GradientCard.withGradient(
                                                  gradientStart:
                                                      AppColors.blueGradientStart,
                                                  gradientEnd:
                                                      AppColors.blueGradientEnd,
                                                  borderRadius: 20,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: FilledButton(
                                                      onPressed: () {
                                                        context
                                                            .read<AppState>()
                                                            .toggleReadingCompletion(
                                                                day.id);
                                                      },
                                                      style: FilledButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        foregroundColor:
                                                            Colors.white,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side:
                                                              BorderSide.none,
                                                        ),
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                          vertical: Spacing.md,
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Mark Complete',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ))
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
    ));
  }


  String _formatMonthDayYear(DateTime date) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final month = monthNames[date.month - 1];
    return '$month ${date.day}, ${date.year}';
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