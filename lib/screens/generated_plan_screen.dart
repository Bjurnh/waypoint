import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/progress_circle.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_appbar.dart';
import '../widgets/gradient_card.dart';
import '../models/plan_models.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../utils/chart_styles.dart';

typedef ToggleCompletion = void Function(int day);

class GeneratedPlanScreen extends StatefulWidget {
  final List<DayReading> readings;
  final ToggleCompletion? onToggleCompletion;

  const GeneratedPlanScreen({
    this.readings = const [],
    this.onToggleCompletion,
    Key? key,
  }) : super(key: key);

  @override
  State<GeneratedPlanScreen> createState() => _GeneratedPlanScreenState();
}

class _GeneratedPlanScreenState extends State<GeneratedPlanScreen> {
  @override
  Widget build(BuildContext context) {
    final completedCount =
        widget.readings.where((r) => r.completed).length;
    final progress = widget.readings.isEmpty
        ? 0.0
        : completedCount / widget.readings.length;

    return GradientBackground.plan(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ModernAppBar.progress(
          title: 'Reading Plan',
          subtitle: '${widget.readings.length} days',
        ),
        body: CustomScrollView(
          slivers: [
            // Progress Section (Pinned)
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              expandedHeight: 280,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Column(
                    children: [
                      Center(
                        child: ProgressCircle(
                          value: progress,
                          size: 160,
                          label: 'Reading Progress',
                          progressColor: AppColors.blueGradientStart,
                          animate: true,
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),

                      // Progress stats row
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          _ProgressStat(
                            label: 'Completed',
                            value: completedCount,
                            color: AppColors.greenGradientStart,
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: AppColors.border,
                          ),
                          _ProgressStat(
                            label: 'Remaining',
                            value: widget.readings.length -
                                completedCount,
                            color: AppColors.mutedForeground,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Weekly Progress Area Chart
            SliverPadding(
              padding: const EdgeInsets.all(Spacing.md),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Progress',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: Spacing.md),
                    GradientCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.lg,
                      ),
                      child: SizedBox(
                        height: ChartStyles.chartHeight,
                        child: LineChart(
                          _buildWeeklyChart(completedCount),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Readings List
            SliverPadding(
              padding: const EdgeInsets.all(Spacing.md),
              sliver: SliverList.builder(
                itemCount: widget.readings.length,
                itemBuilder: (context, index) {
                  final reading = widget.readings[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.md),
                    child: _ReadingCard(
                      reading: reading,
                      index: index,
                      onToggle: () {
                        setState(() {
                          widget.onToggleCompletion
                              ?.call(reading.day);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build weekly progress area chart
  LineChartData _buildWeeklyChart(int completedCount) {
    // Distribute completed readings across 7 days
    final weekData = List<int>.filled(7, 0);
    final daysPerWeek = widget.readings.length > 7
        ? (widget.readings.length / 7).ceil()
        : 1;

    var completed = 0;
    for (int day = 0; day < 7 && completed < completedCount; day++) {
      final maxForDay = (daysPerWeek * (day + 1)).toInt();
      weekData[day] = (maxForDay > completed) ? maxForDay : completed;
      completed = maxForDay;
    }

    // Normalize to percentage
    final maxValue = widget.readings.length.toDouble();
    final spots = weekData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), (e.value / maxValue * 100).clamp(0, 100));
    }).toList();

    return ChartStyles.createAreaChartData(
      spots: spots,
      gradientColor: AppColors.blueGradientStart,
      lineColor: AppColors.blueGradientEnd,
      showGradient: true,
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ProgressStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 28,
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

class _ReadingCard extends StatefulWidget {
  final DayReading reading;
  final int index;
  final VoidCallback onToggle;

  const _ReadingCard({
    required this.reading,
    required this.index,
    required this.onToggle,
  });

  @override
  State<_ReadingCard> createState() => _ReadingCardState();
}

class _ReadingCardState extends State<_ReadingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GradientCard(
        onTap: _handleTap,
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: _handleTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.reading.completed
                      ? AppColors.greenGradientStart.withValues(alpha: 0.2)
                      : AppColors.mutedForeground.withValues(alpha: 0.1),
                  border: Border.all(
                    color: widget.reading.completed
                        ? AppColors.greenGradientStart
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: widget.reading.completed
                    ? Icon(
                        Icons.check,
                        color: AppColors.greenGradientStart,
                        size: 24,
                      )
                    : Center(
                        child: Text(
                          '${widget.index + 1}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(width: Spacing.md),

            // Reading details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${widget.reading.day} • ${widget.reading.date}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: widget.reading.completed
                              ? AppColors.mutedForeground
                              : AppColors.textPrimary,
                          decoration: widget.reading.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    widget.reading.chapters.join(', '),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Completion indicator
            if (widget.reading.completed)
              Padding(
                padding: const EdgeInsets.only(left: Spacing.md),
                child: Icon(
                  Icons.done_all,
                  color: AppColors.greenGradientStart,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
