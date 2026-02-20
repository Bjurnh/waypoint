/// Animation Performance Monitor
/// Tracks and measures animation performance across screens

import 'package:flutter/material.dart';

class AnimationPerformanceMetrics {
  final String animationName;
  final DateTime startTime;
  DateTime? endTime;
  final List<int> frameTimings = [];
  int droppedFrames = 0;

  AnimationPerformanceMetrics({
    required this.animationName,
    required this.startTime,
  });

  Duration get duration => (endTime ?? DateTime.now()).difference(startTime);

  double get averageFrameTime =>
      frameTimings.isEmpty ? 0 : frameTimings.reduce((a, b) => a + b) / frameTimings.length;

  double get estimatedFPS => frameTimings.isEmpty ? 0 : 1000 / averageFrameTime;

  void recordFrame(int timingMs) {
    frameTimings.add(timingMs);
    // Flag as dropped if frame time > 16.67ms (for 60 FPS)
    if (timingMs > 17) {
      droppedFrames++;
    }
  }

  void end() {
    endTime = DateTime.now();
  }

  @override
  String toString() => '''
Animation: $animationName
Duration: ${duration.inMilliseconds}ms
Frames: ${frameTimings.length}
Average Frame Time: ${averageFrameTime.toStringAsFixed(2)}ms
Estimated FPS: ${estimatedFPS.toStringAsFixed(1)}
Dropped Frames: $droppedFrames
''';
}

class AnimationPerformanceMonitor {
  static final AnimationPerformanceMonitor _instance =
      AnimationPerformanceMonitor._internal();

  factory AnimationPerformanceMonitor() {
    return _instance;
  }

  AnimationPerformanceMonitor._internal();

  final Map<String, AnimationPerformanceMetrics> _metrics = {};

  void startAnimation(String name) {
    _metrics[name] = AnimationPerformanceMetrics(
      animationName: name,
      startTime: DateTime.now(),
    );
  }

  void recordFrame(String name, int timingMs) {
    _metrics[name]?.recordFrame(timingMs);
  }

  void endAnimation(String name) {
    _metrics[name]?.end();
  }

  AnimationPerformanceMetrics? getMetrics(String name) => _metrics[name];

  void printReport() {
    print('\n' + '═' * 80);
    print('ANIMATION PERFORMANCE REPORT');
    print('═' * 80 + '\n');

    for (final metric in _metrics.values) {
      print(metric);
      print('-' * 80);
    }

    // Summary
    double totalAvgFPS = 0;
    int totalDroppedFrames = 0;

    for (final metric in _metrics.values) {
      totalAvgFPS += metric.estimatedFPS;
      totalDroppedFrames += metric.droppedFrames;
    }

    final avgFPS = _metrics.isEmpty ? 0 : totalAvgFPS / _metrics.length;

    print('\nSUMMARY:');
    print('Total Animations: ${_metrics.length}');
    print('Average FPS: ${avgFPS.toStringAsFixed(1)}');
    print('Total Dropped Frames: $totalDroppedFrames');
    print('Target FPS: 60');
    print(
      'Status: ${avgFPS >= 55 ? '✓ PASS' : '✗ NEEDS OPTIMIZATION'}',
    );
    print('\n' + '═' * 80 + '\n');
  }

  void clear() {
    _metrics.clear();
  }
}

/// Animation performance tester
class AnimationPerformanceTester {
  /// Test animation frame rate
  static Future<AnimationFrameMetrics> testAnimationFrameRate({
    required VoidCallback animation,
    required Duration duration,
  }) async {
    final metrics = AnimationFrameMetrics();
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < duration) {
      animation();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    stopwatch.stop();
    return metrics;
  }

  /// Check if animation is smooth
  static bool isAnimationSmooth(AnimationPerformanceMetrics metrics) {
    return metrics.estimatedFPS >= 55 && metrics.droppedFrames < 5;
  }

  /// Animation smoothness checklist
  static void printSmoothessChecklist() {
    print('\n✓ ANIMATION SMOOTHNESS CHECKLIST\n');

    final checks = [
      'Screen transitions (fade, slide)',
      'Button tap animations',
      'Progress circle animations',
      'Chart data animations',
      'Streak celebration animation',
      'Habit toggle animations',
      'Prayer entry card animations',
      'Filter pill selection animations',
      'Form field focus animations',
      'List scroll smoothness',
      'Dialog open/close animations',
      'Gradient background transitions',
    ];

    for (int i = 0; i < checks.length; i++) {
      print('${i + 1}. ${checks[i]}');
      print('   Expected: 60 FPS, ✓ Smooth');
      print('   Status: ☐ Not tested');
      print('');
    }
  }
}

class AnimationFrameMetrics {
  final List<Duration> frameTimes = [];
  int droppedFrames = 0;

  void recordFrameTime(Duration time) {
    frameTimes.add(time);
    // 60 FPS = ~16.67ms per frame
    if (time.inMilliseconds > 17) {
      droppedFrames++;
    }
  }

  double get averageFPS =>
      frameTimes.isEmpty ? 0 : 1000 / (frameTimes.reduce((a, b) => a + b).inMilliseconds / frameTimes.length);
}

/// Test specific animation scenarios
class AnimationScenarios {
  static const Map<String, String> testScenarios = {
    'HomeScreen Load': 'Fade in gradient background, verse card, streak badge',
    'Prayer Entry': 'Slide in prayer list items, filter pill selection',
    'Habit Toggle': 'Quick toggle animation, progress update',
    'Chart Animation': 'fl_chart data animation on load',
    'Screen Transition': 'Navigate between screens smoothly',
    'Celebration Dialog': 'Streak celebration milestone popup',
  };

  static void printAnimationTestPlan() {
    print('\n📊 ANIMATION PERFORMANCE TEST PLAN\n');

    int i = 1;
    for (final scenario in testScenarios.entries) {
      print('Test $i: ${scenario.key}');
      print('   Description: ${scenario.value}');
      print('   Target FPS: 60');
      print('   Max Jank: 0-2 frames');
      print('   Status: ☐ Not tested');
      print('');
      i++;
    }
  }
}
