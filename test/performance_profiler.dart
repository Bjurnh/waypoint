/// Performance Profiler for Flutter App
/// Measures build times, memory usage, and overall performance

import 'dart:async';
import 'package:flutter/material.dart';

class PerformanceProfiler {
  static final PerformanceProfiler _instance = PerformanceProfiler._internal();

  factory PerformanceProfiler() {
    return _instance;
  }

  PerformanceProfiler._internal();

  final Map<String, ScreenPerformanceMetrics> _screenMetrics = {};

  /// Record screen build performance
  void recordScreenBuild(
    String screenName, {
    required Duration buildTime,
    required int estimatedMemoryMB,
    int widgetCount = 0,
  }) {
    _screenMetrics[screenName] = ScreenPerformanceMetrics(
      screenName: screenName,
      buildTime: buildTime,
      estimatedMemoryMB: estimatedMemoryMB,
      widgetCount: widgetCount,
    );
  }

  /// Get performance report
  PerformanceReport getReport() {
    return PerformanceReport(_screenMetrics);
  }

  /// Clear metrics
  void clear() {
    _screenMetrics.clear();
  }

  /// Print detailed report
  void printDetailedReport() {
    getReport().print();
  }
}

class ScreenPerformanceMetrics {
  final String screenName;
  final Duration buildTime;
  final int estimatedMemoryMB;
  final int widgetCount;
  final DateTime recordedAt = DateTime.now();

  ScreenPerformanceMetrics({
    required this.screenName,
    required this.buildTime,
    required this.estimatedMemoryMB,
    required this.widgetCount,
  });

  bool get passesPerformanceCheck =>
      buildTime.inMilliseconds <= 500 && estimatedMemoryMB <= 200;

  @override
  String toString() => '''
Screen: $screenName
Build Time: ${buildTime.inMilliseconds}ms
Memory: ${estimatedMemoryMB}MB
Widgets: $widgetCount
Status: ${passesPerformanceCheck ? '✓ PASS' : '✗ NEEDS OPTIMIZATION'}
''';
}

class PerformanceReport {
  final Map<String, ScreenPerformanceMetrics> metrics;

  PerformanceReport(this.metrics);

  Duration get totalBuildTime =>
      metrics.values.fold(Duration.zero, (l, r) => l + r.buildTime);

  double get averageBuildTime =>
      metrics.isEmpty ? 0 : totalBuildTime.inMilliseconds / metrics.length;

  int get totalMemory =>
      metrics.values.fold(0, (l, r) => l + r.estimatedMemoryMB);

  double get averageMemory => metrics.isEmpty ? 0 : totalMemory / metrics.length;

  List<ScreenPerformanceMetrics> get slowScreens =>
      metrics.values.where((m) => m.buildTime.inMilliseconds > 500).toList();

  List<ScreenPerformanceMetrics> get highMemoryScreens =>
      metrics.values.where((m) => m.estimatedMemoryMB > 200).toList();

  bool get isOptimal =>
      averageBuildTime <= 350 && averageMemory <= 150 && slowScreens.isEmpty;

  void print() {
    print('\n' + '═' * 90);
    print('PERFORMANCE PROFILER REPORT');
    print('═' * 90 + '\n');

    // Summary
    print('SUMMARY:');
    print('Total Screens Profiled: ${metrics.length}');
    print('Average Build Time: ${averageBuildTime.toStringAsFixed(1)}ms');
    print('Average Memory Usage: ${averageMemory.toStringAsFixed(1)}MB');
    print('Total Memory Used: ${totalMemory}MB');
    print('');

    // Individual screens
    print('DETAILED METRICS:');
    print('─' * 90);

    for (final metric in metrics.values) {
      print(metric);
      print('─' * 90);
    }

    // Performance issues
    if (slowScreens.isNotEmpty) {
      print('\n⚠️  SLOW SCREENS (>500ms):');
      for (final screen in slowScreens) {
        print(
          '  • ${screen.screenName}: ${screen.buildTime.inMilliseconds}ms',
        );
      }
    }

    if (highMemoryScreens.isNotEmpty) {
      print('\n⚠️  HIGH MEMORY SCREENS (>200MB):');
      for (final screen in highMemoryScreens) {
        print('  • ${screen.screenName}: ${screen.estimatedMemoryMB}MB');
      }
    }

    // Overall status
    print('\n' + '─' * 90);
    print('OVERALL STATUS: ${isOptimal ? '✓ OPTIMAL' : '✗ NEEDS OPTIMIZATION'}');
    print('═' * 90 + '\n');
  }
}

/// Screen-by-screen performance checklist
class PerformanceChecklistByScreen {
  static const Map<String, List<String>> checklistItems = {
    'HomeScreen': [
      'Gradient background renders efficiently',
      'Verse card loads quickly',
      'Streak badge animation smooth',
      'Quick action cards responsive',
      'No unnecessary rebuilds',
    ],
    'PrayerLogScreen': [
      'Prayer list scrolls smoothly',
      'Search filter responsive',
      'Category pills update instantly',
      'Memory usage stable while scrolling',
      'No jank on filter change',
    ],
    'HabitTrackingScreen': [
      'Weekly progress chart renders smoothly',
      'Habit cards toggle instantly',
      'Progress bar animates smoothly',
      'Habit comparison chart loads 60fps',
      'No memory leaks on data update',
    ],
    'ProgressDashboardScreen': [
      'Summary card grid loads quickly',
      'Progress circle animates smoothly',
      'Monthly chart loads in <1 second',
      'Habit comparison chart responsive',
      'Overall screen memory acceptable',
    ],
    'GeneratedPlanScreen': [
      'Plan list scrolls smoothly',
      'Chapter toggles instantly',
      'Progress chart animates',
      'Completion animations play correctly',
      'Memory stable during interactions',
    ],
  };

  static void printChecklist() {
    print('\n📋 SCREEN-BY-SCREEN PERFORMANCE CHECKLIST\n');

    for (final screen in checklistItems.entries) {
      print('${screen.key}:');
      for (final check in screen.value) {
        print('  ☐ $check');
      }
      print('');
    }
  }
}

/// Performance optimization recommendations
class OptimizationRecommendations {
  static const Map<String, List<String>> recommendations = {
    'Build Optimization': [
      'Use const constructors where possible',
      'Avoid rebuilds with proper state management',
      'Use RepaintBoundary for expensive widgets',
      'Profile with DevTools to find hot spots',
    ],
    'Memory Optimization': [
      'Dispose resources in dispose() methods',
      'Cache images and assets',
      'Use lazy loading for long lists',
      'Monitor memory with DevTools',
    ],
    'Animation Optimization': [
      'Use AnimatedBuilder instead of AnimatedWidget',
      'Reduce animation frame rate if needed',
      'Use shouldRebuild() to prevent unnecessary repaints',
      'Test on real devices, not simulators',
    ],
    'Chart Optimization': [
      'Limit data points in charts',
      'Use efficient fl_chart configurations',
      'Debounce data updates',
      'Cache chart data',
    ],
  };

  static void printRecommendations() {
    print('\n💡 OPTIMIZATION RECOMMENDATIONS\n');

    for (final category in recommendations.entries) {
      print('${category.key}:');
      for (final rec in category.value) {
        print('  • $rec');
      }
      print('');
    }
  }
}
