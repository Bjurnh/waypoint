import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_appbar.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/gradient_card.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../utils/chart_styles.dart';

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
  String _selectedFilter = 'all';
  late Map<int, bool> _todayCompletion;

  @override
  void initState() {
    super.initState();
    // Initialize today's completion tracking
    _todayCompletion = {
      1: false,
      2: true,
      3: false,
      4: true,
    };
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allHabits = [
      {
        'id': 1,
        'title': 'Read Bible',
        'subtitle': 'Daily 15 min',
        'category': 'reading',
        'progress': 0.6,
        'streak': 7,
        'color': AppColors.blueGradientStart,
        'icon': Icons.import_contacts,
        'weekData': [true, true, false, true, true, false, false],
        'completionRate': 0.62,
      },
      {
        'id': 2,
        'title': 'Prayer',
        'subtitle': 'Morning & Night',
        'category': 'spiritual',
        'progress': 0.8,
        'streak': 14,
        'color': AppColors.pinkGradientStart,
        'icon': Icons.favorite,
        'weekData': [true, true, true, true, true, true, false],
        'completionRate': 0.86,
      },
      {
        'id': 3,
        'title': 'Meditation',
        'subtitle': 'Evening wind-down',
        'category': 'wellness',
        'progress': 0.5,
        'streak': 3,
        'color': AppColors.greenGradientStart,
        'icon': Icons.psychology,
        'weekData': [true, false, true, false, false, true, false],
        'completionRate': 0.43,
      },
      {
        'id': 4,
        'title': 'Journal',
        'subtitle': 'Reflections',
        'category': 'reflection',
        'progress': 0.7,
        'streak': 5,
        'color': AppColors.purpleGradientStart,
        'icon': Icons.edit_note,
        'weekData': [true, true, false, true, true, true, false],
        'completionRate': 0.71,
      },
    ];

    // Filter habits based on selection
    List<Map<String, dynamic>> filteredHabits = allHabits;

    if (_selectedFilter != 'all') {
      filteredHabits = filteredHabits
          .where((h) =>
              (h['category'] as String).toLowerCase() ==
              _selectedFilter.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredHabits = filteredHabits
          .where((h) =>
              (h['title'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (h['subtitle'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    final completedToday = _todayCompletion.values
        .where((completed) => completed)
        .length;

    return GradientBackground.habit(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ModernAppBar.habit(
          title: 'Habit Tracker',
          subtitle: '${filteredHabits.length} habits',
        ),
        body: CustomScrollView(
          slivers: [
            // Search and Filter Bar
            SliverPadding(
              padding: const EdgeInsets.all(Spacing.md),
              sliver: SliverToBoxAdapter(
                child: SearchFilterBar(
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
                  filters: const ['all', 'reading', 'spiritual', 'wellness', 'reflection'],
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
                      const Text(
                        "Today's Progress",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
                                '${((completedToday / _todayCompletion.length) * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Completion Rate',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
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
                                color: Colors.white30,
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
                                    'of ${_todayCompletion.length}',
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
                          _buildHabitComparisonChart(
                            filteredHabits,
                          ),
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
                              color: AppColors.mutedForeground.withOpacity(0.5),
                            ),
                            const SizedBox(height: Spacing.md),
                            Text(
                              'No habits found',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    AppColors.mutedForeground.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList.builder(
                      itemCount: filteredHabits.length,
                      itemBuilder: (c, i) {
                        final h = filteredHabits[i];
                        final habitId = h['id'] as int;
                        final isCompletedToday =
                            _todayCompletion[habitId] ?? false;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.md),
                          child: _HabitCard(
                            habit: h,
                            isCompletedToday: isCompletedToday,
                            onToggleComplete: () {
                              setState(() {
                                _todayCompletion[habitId] =
                                    !_todayCompletion[habitId]!;
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

  /// Build habit comparison bar chart
  BarChartData _buildHabitComparisonChart(
    List<Map<String, dynamic>> habits,
  ) {
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < habits.length && i < 7; i++) {
      final habit = habits[i];
      final completionRate = (habit['completionRate'] as double) * 100;
      
      barGroups.add(
        ChartStyles.createBarGroup(
          x: i,
          y: completionRate.clamp(0, 100),
          color: habit['color'] as Color,
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
  final Map<String, dynamic> habit;
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

class _HabitCardState extends State<_HabitCard>
    with SingleTickerProviderStateMixin {
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
    final weekData = widget.habit['weekData'] as List<bool>;
    final completionRate = widget.habit['completionRate'] as double;
    final color = widget.habit['color'] as Color;

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
                      widget.habit['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.habit['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              // Animated completion badge
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
                            ? color.withOpacity(0.3)
                            : AppColors.mutedForeground.withOpacity(0.1),
                        border: Border.all(
                          color: widget.isCompletedToday
                              ? color
                              : AppColors.border,
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
                                widget.habit['icon'] as IconData,
                                color: AppColors.mutedForeground,
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
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '🔥 ${widget.habit['streak']} day streak',
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
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
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
                                    ? color.withOpacity(0.3)
                                    : AppColors.mutedForeground.withOpacity(0.1),
                                border: Border.all(
                                  color: weekData[d]
                                      ? color
                                      : AppColors.border,
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
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
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
                  Text(
                    'Completion Rate',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
                  backgroundColor:
                      AppColors.mutedForeground.withOpacity(0.2),
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
