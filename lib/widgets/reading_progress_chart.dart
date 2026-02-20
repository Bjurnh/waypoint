import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import 'chart_card.dart';

/// Bible reading progress display component
/// Shows line chart of reading progress with completion percentage
/// 
/// Displays:
/// - Line chart showing chapters read per week/day
/// - Completion percentage centrally
/// - Progress bar showing relative completion
class ReadingProgressChart extends StatelessWidget {
  /// Chart title
  final String title;

  /// Chart subtitle/description
  final String? subtitle;

  /// Weekly data points (chapters read per week)
  /// Should contain 4-6 data points for monthly view
  final List<FlSpot> weeklyData;

  /// Max value for Y-axis (total chapters or max per week)
  final double maxY;

  /// Completion percentage (0-100)
  final double completionPercentage;

  /// Optional label for completion stat
  final String completionLabel;

  /// Whether chart is loading
  final bool isLoading;

  /// Optional callback
  final VoidCallback? onTap;

  const ReadingProgressChart({
    required this.title,
    required this.weeklyData,
    required this.maxY,
    required this.completionPercentage,
    this.subtitle,
    this.completionLabel = 'Completed',
    this.isLoading = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: title,
      subtitle: subtitle,
      height: 320,
      isLoading: isLoading,
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              _buildChartData(),
            ),
          ),
          SizedBox(height: Spacing.md),
          // Completion stats footer
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Spacing.sm,
              horizontal: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${completionPercentage.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      completionLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border.withOpacity(0.2),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Chapters Read',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      '${weeklyData.fold<double>(0, (sum, spot) => sum + spot.y).toStringAsFixed(0)} total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.foreground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppColors.border.withOpacity(0.2),
          strokeWidth: 0.5,
          dashArray: [5, 5],
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: _buildBottomTitle,
            interval: 1,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: _buildLeftTitle,
            reservedSize: 40,
            interval: maxY / 4,
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      minX: 0,
      maxX: (weeklyData.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: weeklyData,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 5,
              color: AppColors.primary,
              strokeWidth: 2,
              strokeColor: AppColors.card,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.4),
                AppColors.primary.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
      fontSize: 10,
    );

    String text;
    switch (value.toInt()) {
      case 0:
        text = 'W1';
        break;
      case 1:
        text = 'W2';
        break;
      case 2:
        text = 'W3';
        break;
      case 3:
        text = 'W4';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
      fontSize: 10,
    );

    return Text('${value.toInt()}', style: style, textAlign: TextAlign.left);
  }
}

/// Compact reading progress indicator (for dashboard/home)
class ReadingProgressIndicator extends StatelessWidget {
  /// Title/label
  final String label;

  /// Current chapters read
  final int chaptersRead;

  /// Total chapters in plan
  final int totalChapters;

  /// Optional book name
  final String? currentBook;

  /// Custom color
  final Color? color;

  /// Optional callback
  final VoidCallback? onTap;

  const ReadingProgressIndicator({
    required this.label,
    required this.chaptersRead,
    required this.totalChapters,
    this.currentBook,
    this.color,
    this.onTap,
    Key? key,
  }) : super(key: key);

  double get _progress => chaptersRead / totalChapters;
  int get _percentage => (_progress * 100).toInt();

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(
            color: AppColors.border.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: displayColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$_percentage%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: displayColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Spacing.md),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  backgroundColor: AppColors.inputBackground,
                  valueColor: AlwaysStoppedAnimation(displayColor),
                ),
              ),
              SizedBox(height: Spacing.md),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$chaptersRead/$totalChapters',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      Text(
                        'Chapters',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (currentBook != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currentBook!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.foreground,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Current',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
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
