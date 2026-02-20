import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/progress_circle.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_appbar.dart';
import '../widgets/gradient_card.dart';
import '../widgets/summary_card.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

class ProgressDashboardScreen extends StatelessWidget {
  final int? currentStreak;
  final int? bibleProgress; // percent
  final int? totalPrayers;

  const ProgressDashboardScreen({
    this.currentStreak,
    this.bibleProgress,
    this.totalPrayers,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    
    final streak = currentStreak ?? app.currentStreak;
    final prayers = totalPrayers ?? app.prayers.length;
    final completedReadings = app.allReadings.where((r) => r.completed).length;
    final progress = bibleProgress ?? 
        (app.allReadings.isEmpty 
          ? 0 
          : ((completedReadings / 
              app.generatedPlanConfig.timeFrame) * 100).toInt());
    
    return GradientBackground.progress(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ModernAppBar.progress(
          title: 'Progress Dashboard',
          subtitle: 'Your spiritual journey',
        ),
        body: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            // Summary Cards Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: Spacing.md,
              mainAxisSpacing: Spacing.md,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Streak Summary
                SummaryCard(
                  icon: Icons.whatshot,
                  value: streak.toString(),
                  label: 'Day Streak',
                  gradientStart: const Color(0xFFFB923C),
                  gradientEnd: const Color(0xFFEF4444),
                ),

                // Prayers Summary
                SummaryCard(
                  icon: Icons.favorite,
                  value: prayers.toString(),
                  label: 'Prayers',
                  gradientStart: AppColors.pinkGradientStart,
                  gradientEnd: AppColors.pinkGradientEnd,
                ),

                // Readings Summary
                SummaryCard(
                  icon: Icons.auto_stories,
                  value: completedReadings.toString(),
                  label: 'Readings Done',
                  gradientStart: AppColors.blueGradientStart,
                  gradientEnd: AppColors.blueGradientEnd,
                ),

                // Completion Rate Summary
                SummaryCard(
                  icon: Icons.trending_up,
                  value: '${progress.toStringAsFixed(0)}%',
                  label: 'Completion %',
                  gradientStart: AppColors.indigoGradientStart,
                  gradientEnd: AppColors.indigoGradientEnd,
                ),
              ],
            ),

            const SizedBox(height: Spacing.lg),

            // Bible Reading Progress Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Spacing.md),
              child: Text(
                'Bible Reading Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            GradientCard(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ProgressCircle(
                      value: progress / 100.0,
                      size: 160,
                      label: 'Reading Progress',
                      progressColor: AppColors.blueGradientStart,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),

                  // Linear progress bar
                  Text(
                    'Overall Progress',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: Spacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    child: LinearProgressIndicator(
                      value: progress / 100.0,
                      minHeight: 10,
                      backgroundColor: AppColors.mutedForeground
                          .withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.blueGradientStart,
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.md),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(
                        label: 'Completed',
                        value: completedReadings.toString(),
                        color: AppColors.blueGradientStart,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.border,
                      ),
                      _StatColumn(
                        label: 'Remaining',
                        value: (app.generatedPlanConfig.timeFrame -
                                completedReadings)
                            .toString(),
                        color: AppColors.mutedForeground,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: Spacing.lg),

            // Weekly Activity Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Spacing.md),
              child: Text(
                'Weekly Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            GradientCard(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last 7 Days Activity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: Spacing.md),

                    // Simple week grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        final days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ];
                        // Simulate activity - in real app, fetch from state
                        final isActive = index < 5;
                        return Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? AppColors.purpleGradientStart
                                    : AppColors.mutedForeground
                                        .withOpacity(0.2),
                              ),
                              child: isActive
                                  ? const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: Spacing.sm),
                            Text(
                              days[index],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: Spacing.lg),

            // Prayer Activity Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Spacing.md),
              child: Text(
                'Prayer Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            GradientCard(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Prayers',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pinkGradientStart
                                .withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(Spacing.radiusSm),
                          ),
                          child: Text(
                            prayers.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.pinkGradientStart,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.md),

                    // Prayer status breakdown
                    Row(
                      children: [
                        Expanded(
                          child: _PrayerStatusItem(
                            count: app.prayers
                                .where((p) => !p.isAnswered)
                                .length,
                            label: 'Active',
                            color: AppColors.pinkGradientStart,
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: _PrayerStatusItem(
                            count: app.prayers
                                .where((p) => p.isAnswered)
                                .length,
                            label: 'Answered',
                            color: AppColors.greenGradientStart,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _PrayerStatusItem extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _PrayerStatusItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
