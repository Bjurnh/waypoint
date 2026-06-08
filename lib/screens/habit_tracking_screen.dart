import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/chart_styles.dart';
import '../utils/icon_map.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';
import '../widgets/modern_appbar.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/status_bar_style.dart';

class HabitTrackingScreen extends StatefulWidget {
  const HabitTrackingScreen({super.key});

  @override
  State<HabitTrackingScreen> createState() => _HabitTrackingScreenState();
}

// Model for daily completion tracking
class DailyAction {
  final DateTime date;
  final bool completed;

  DailyAction({required this.date, required this.completed});
}

class _HabitTrackingScreenState extends State<HabitTrackingScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.normalizeHabitsForNow();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final colorScheme = Theme.of(context).colorScheme;

    final List<Habit> allHabits = appState.habits;

    // Filter habits based on selection
    List<Habit> filteredHabits = allHabits;

    if (_selectedFilter != 'All') {
      filteredHabits = filteredHabits
          .where((h) => h.category.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredHabits = filteredHabits
          .where((h) =>
              h.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              h.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    final completedToday = allHabits.where((habit) => habit.completedToday).length;

    return StatusBarStyle(
      child: GradientBackground.habit(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: ModernAppBar.habit(
            title: 'Habit Tracker',
            subtitle: '${filteredHabits.length} habits',
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Search and Filter Bar
                SliverPadding(
                  padding: const EdgeInsets.all(Spacing.md),
                  sliver: SliverToBoxAdapter(
                    child: SearchFilterBar.habit(
                      onSearchChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                      onFilterSelected: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedFilter: _selectedFilter,
                    ),
                  ),
                ),

                // Today's Progress Summary Card
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  sliver: SliverToBoxAdapter(
                    child: GradientCard(
                      gradientStart: AppColors.purpleGradientStart,
                      gradientEnd: AppColors.purpleGradientEnd,
                      padding: const EdgeInsets.all(Spacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Progress",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: Spacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${(allHabits.isEmpty ? 0 : ((completedToday / allHabits.length) * 100)).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                  const Text(
                                    'Completion Rate',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.onPrimary.withValues(alpha: 0.2),
                                    width: 4,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        completedToday.toString(),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'of ${allHabits.length}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Habit Comparison Chart
                SliverPadding(
                  padding: const EdgeInsets.all(Spacing.md),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completion Rates',
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
                            child: BarChart(
                              _buildHabitComparisonChart(filteredHabits),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Habits List with completion toggles
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.md,
                  ),
                  sliver: filteredHabits.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 48,
                                  color: AppColors.mutedForeground.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: Spacing.md),
                                Text(
                                  'No habits found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (c, i) {
                              final habit = filteredHabits[i];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: Spacing.md),
                                child: _HabitCard(
                                  habit: habit,
                                  isCompletedToday: habit.completedToday,
                                  onToggleComplete: () {
                                    appState.toggleHabitCompletion(habit.id);
                                  },
                                ),
                              );
                            },
                            childCount: filteredHabits.length,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build habit comparison bar chart
  BarChartData _buildHabitComparisonChart(List<Habit> habits) {
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < habits.length && i < 7; i++) {
      final habit = habits[i];
      final completionRate = habit.computedCompletionRate * 100;

      barGroups.add(
        ChartStyles.createBarGroup(
          x: i,
          y: completionRate.clamp(0, 100),
          color: habit.color,
        ),
      );
    }

    return ChartStyles.createBarChartData(
      barGroups: barGroups,
      barColor: AppColors.purpleGradientStart,
    );
  }
}

class _HabitCard extends StatefulWidget {
  final Habit habit;
  final bool isCompletedToday;
  final VoidCallback onToggleComplete;

  const _HabitCard({
    required this.habit,
    required this.isCompletedToday,
    required this.onToggleComplete,
  });

  @override
  State<_HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<_HabitCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isCompletedToday) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _HabitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompletedToday != oldWidget.isCompletedToday) {
      if (widget.isCompletedToday) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final weekData = widget.habit.weekData.length == 7
        ? widget.habit.weekData
        : List<bool>.filled(7, false);
    final completionRate = widget.habit.computedCompletionRate;
    final color = widget.habit.color;

    return GradientCard(
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
                      widget.habit.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.habit.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              ScaleTransition(
                scale: _scaleAnimation,
                child: RotationTransition(
                  turns: _rotateAnimation,
                  child: GestureDetector(
                    onTap: widget.onToggleComplete,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isCompletedToday
                            ? color.withValues(alpha: 0.3)
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                        border: Border.all(
                          color: widget.isCompletedToday
                              ? color
                              : colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: widget.isCompletedToday
                          ? Center(
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: color,
                                size: 28,
                              ),
                            )
                          : Center(
                              child: Icon(
                                kIconMap[widget.habit.iconKey] ?? Icons.help_outline,
                                color: colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // Streak badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '🔥 ${widget.habit.streak} day streak',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),

          // Week Progress Dots with day labels
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This Week',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int d = 0; d < 7; d++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: weekData[d]
                                    ? color.withValues(alpha: 0.3)
                                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: weekData[d] ? color : colorScheme.outline,
                                  width: 1,
                                ),
                              ),
                              child: weekData[d]
                                  ? Center(
                                      child: Icon(
                                        Icons.check,
                                        size: 14,
                                        color: color,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ['M', 'T', 'W', 'T', 'F', 'S', 'S'][d],
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // Completion Rate Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Completion Rate',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      // keep design in light, auto in dark via theme override below
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(completionRate * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: completionRate,
                  minHeight: 6,
                  backgroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

