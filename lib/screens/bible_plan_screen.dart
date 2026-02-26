import 'package:flutter/material.dart';
import 'generated_plan_screen.dart';
import '../models/plan_models.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';
import '../widgets/reading_progress_chart.dart';
import '../widgets/summary_card.dart';

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
    _config = widget.config ?? PlanConfig(timeFrame: 30, startDate: DateTime.now(), dailyMinutes: 15, readingStyle: 'sequential');

    // If readings weren't provided, generate a placeholder schedule using the plan start date
    _readings = widget.readings ?? List.generate(_config.timeFrame, (i) {
      final date = _config.startDate.add(Duration(days: i));
      // Create a few simple chapter placeholders for each day
      final base = i * 3 + 1;
      final chapters = List.generate(3, (j) => 'Chapter ${base + j}');
      return DayReading(day: i + 1, date: date.toIso8601String().split('T').first, chapters: chapters);
    });
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
            startColor: Colors.indigo.withValues(alpha: 0.05),
            midColor: Colors.blue.withValues(alpha: 0.05),
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
                // Top summary row (Days / Streak / Completed)
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha: 0.2),
                  padding: EdgeInsets.all(Spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard.bibleReading(
                              value: '${_readings.length}',
                              label: 'Days',
                              onTap: null,
                            ),
                          ),
                          SizedBox(width: Spacing.md),
                          Expanded(
                            child: SummaryCard.streak(
                              value: '0',
                              label: 'Streak',
                            ),
                          ),
                          SizedBox(width: Spacing.md),
                          Expanded(
                            child: SummaryCard.habits(
                              value: '${completedDays}',
                              label: 'Completed',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Spacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_config.timeFrame}-Day Plan', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                              SizedBox(height: Spacing.xs),
                              Text('Started ${_config.startDate.toIso8601String().split('T').first}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                          Text('$completionPercentage%', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
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
                        borderColor: AppColors.border.withValues(alpha:0.2),
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
                        borderColor: AppColors.border.withValues(alpha:0.2),
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
                SizedBox(height: Spacing.lg),

                // Reading Schedule header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reading Schedule', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(_config.readingStyle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ),
                  ],
                ),
                SizedBox(height: Spacing.md),

                // Schedule list
                Column(
                  children: _readings.map((day) {
                    final dayDate = DateTime.tryParse(day.date) ?? DateTime.now();
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
                                SizedBox(width: Spacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Day ${day.day}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                      SizedBox(height: Spacing.xs),
                                      Text(day.date, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                SizedBox(width: Spacing.md),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xs),
                                  decoration: BoxDecoration(
                                    color: day.completed ? AppColors.primary.withValues(alpha: 0.12) : AppColors.inputBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(day.completed ? 'Completed' : 'Not Completed', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                ),
                              ],
                            ),
                            SizedBox(height: Spacing.md),
                            // Chapters
                            Column(
                              children: day.chapters.map((c) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBackground,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.menu_book, color: AppColors.primary, size: 18),
                                      SizedBox(width: Spacing.md),
                                      Expanded(child: Text(c, style: Theme.of(context).textTheme.bodyMedium)),
                                    ],
                                  ),
                                ),
                              )).toList(),
                            ),
                            SizedBox(height: Spacing.md),
                            // action area
                            available
                              ? FilledButton(
                                  onPressed: day.completed ? null : () { setState(() { day.completed = true; }); },
                                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: EdgeInsets.symmetric(vertical: Spacing.md)),
                                  child: Text(day.completed ? 'Completed' : 'Mark as Complete', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                                )
                              : Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: Spacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBackground,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(child: Text('Available on ${day.date}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))),
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

  List<bool> _getWeeklyProgress() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final checkDate = weekStart.add(Duration(days: i));
      return _readings.any((r) => r.date.contains(checkDate.toString().split(' ')[0]));
    });
  }
}
