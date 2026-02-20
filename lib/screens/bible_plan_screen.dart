import 'package:flutter/material.dart';
import 'generated_plan_screen.dart';
import '../models/plan_models.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';
import '../widgets/reading_progress_chart.dart';

class BiblePlanScreen extends StatefulWidget {
  final PlanConfig? config;
  final List<DayReading>? readings;

  const BiblePlanScreen({this.config, this.readings, Key? key}) : super(key: key);

  @override
  State<BiblePlanScreen> createState() => _BiblePlanScreenState();
}

class _BiblePlanScreenState extends State<BiblePlanScreen> {
  late List<DayReading> _readings;
  late PlanConfig _config;

  @override
  void initState() {
    super.initState();
    _readings = widget.readings ?? List.generate(30, (i) => DayReading(day: i + 1, date: 'Day ${i + 1}', chapters: ['Genesis ${i + 1}']));
    _config = widget.config ?? PlanConfig(timeFrame: 30, startDate: DateTime.now(), dailyMinutes: 15, readingStyle: 'sequential');
  }

  @override
  Widget build(BuildContext context) {
    final completedDays = _readings.length ~/ 2;
    final completionPercentage = (completedDays / _readings.length * 100).toInt();
    final weeklyProgress = _getWeeklyProgress();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Bible Reading Plan'),
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
      ),
      body: Stack(
        children: [
          GradientBackground(
            child: Container(),
            startColor: Colors.indigo.withOpacity(0.05),
            midColor: Colors.blue.withOpacity(0.05),
            endColor: Colors.white,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + Spacing.lg,
              left: Spacing.lg,
              right: Spacing.lg,
              bottom: Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Plan Info
                GradientCard(
                  borderColor: AppColors.border.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_config.timeFrame}-Day Plan',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.foreground,
                                  ),
                                ),
                                SizedBox(height: Spacing.xs),
                                Text(
                                  'Started ${_config.startDate.toString().split(' ')[0]}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spacing.md,
                              vertical: Spacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '$completionPercentage%',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Spacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Overall Progress',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '$completedDays/${_readings.length} days',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foreground,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: completedDays / _readings.length,
                              minHeight: 8,
                              backgroundColor: AppColors.inputBackground,
                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Weekly Stats
                Row(
                  children: [
                    Expanded(
                      child: GradientCard(
                        borderColor: AppColors.border.withOpacity(0.2),
                        child: Column(
                          children: [
                            Text(
                              'This Week',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: Spacing.sm),
                            Text(
                              '${weeklyProgress.where((c) => c).length}/7',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: Spacing.xs),
                            Text(
                              'days completed',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: Spacing.md),
                    Expanded(
                      child: GradientCard(
                        borderColor: AppColors.border.withOpacity(0.2),
                        child: Column(
                          children: [
                            Text(
                              'Days Left',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: Spacing.sm),
                            Text(
                              '${_readings.length - completedDays}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: Spacing.xs),
                            Text(
                              'readings',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                SizedBox(height: Spacing.lg),

                // Reading Progress Chart
                ReadingProgressIndicator(
                  label: 'Bible Reading Progress',
                  chaptersRead: int.parse((completedDays * 3.5).toString().split('.')[0]),
                  totalChapters: int.parse((_readings.length * 3.5).toString().split('.')[0]),
                  currentBook: _readings.isNotEmpty ? _readings.last.chapters.isNotEmpty ? _readings.last.chapters.first : 'Genesis' : 'Genesis',
                  color: AppColors.primary,
                ),
                SizedBox(height: Spacing.lg),

                // View Full Plan Button
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GeneratedPlanScreen(readings: _readings),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'View Full Reading Plan',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<bool> _getWeeklyProgress() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final checkDate = weekStart.add(Duration(days: i));
      return _readings.any((r) => r.date.contains(checkDate.toString().split(' ')[0]));
    });
  }
}
