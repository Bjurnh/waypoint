import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';

/// Provides consistent chart styling across the app
/// Integrates with fl_chart for area charts, line charts, and bar charts
class ChartStyles {
  // Prevent instantiation
  ChartStyles._();

  /// Standard chart dimensions
  static const double chartHeight = 240;
  static const double chartPadding = 16;
  static const double gridLineWidth = 0.5;

  /// Grid line style for all charts
  static final FlGridData gridData = FlGridData(
    show: true,
    drawVerticalLine: false,
    horizontalInterval: 25,
    getDrawingHorizontalLine: _drawHorizontalLine,
  );

  /// Bottom title data for weekly charts
  static final FlTitlesData weeklyTitlesData = FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: _weeklyXAxisTitle,
        interval: 1,
        reservedSize: 30,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: _yAxisTitle,
        reservedSize: 40,
        interval: 25,
      ),
    ),
    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );

  /// Android-style area chart below line
  static LineChartData createAreaChartData({
    required List<FlSpot> spots,
    required Color gradientColor,
    required Color lineColor,
    bool showGradient = true,
  }) {
    return LineChartData(
      borderData: FlBorderData(show: false),
      gridData: gridData,
      titlesData: weeklyTitlesData,
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: lineColor,
          barWidth: 2,
          belowBarData: BarAreaData(
            show: showGradient,
            gradient: LinearGradient(
              colors: [
                gradientColor.withOpacity(0.4),
                gradientColor.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 4,
              color: lineColor,
              strokeWidth: 0,
            ),
          ),
        ),
      ],
    );
  }

  /// Bar chart configuration
  static BarChartData createBarChartData({
    required List<BarChartGroupData> barGroups,
    required Color barColor,
  }) {
    return BarChartData(
      borderData: FlBorderData(show: false),
      gridData: gridData,
      titlesData: weeklyTitlesData,
      minY: 0,
      maxY: 100,
      barGroups: barGroups,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => AppColors.foreground,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(0)}%',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Create bar group with single rod
  static BarChartGroupData createBarGroup({
    required int x,
    required double y,
    required Color color,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  /// Horizontal grid line painter
  static FlLine _drawHorizontalLine(double value) {
    return FlLine(
      color: AppColors.border.withOpacity(0.3),
      strokeWidth: gridLineWidth,
      dashArray: [5, 5],
    );
  }

  /// Y-axis title formatter
  static Widget _yAxisTitle(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
      fontSize: 10,
    );

    String text;
    if (value == meta.max) {
      text = '100';
    } else if (value == 0) {
      text = '0';
    } else if (value == 50) {
      text = '50';
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  /// X-axis title formatter for weekly charts
  static Widget _weeklyXAxisTitle(double value, TitleMeta meta) {
    const weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const style = TextStyle(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
      fontSize: 10,
    );

    final index = value.toInt();
    if (index < 0 || index >= weekDays.length) {
      return Container();
    }

    return Text(weekDays[index], style: style);
  }
}
