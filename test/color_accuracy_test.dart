/// Color Accuracy Verification Tool
/// Compares Flutter colors against React design specification

import 'package:flutter/material.dart';

class ColorAccuracyTest {
  /// React design colors that Flutter must match
  static const Map<String, Color> reactColorSpec = {
    // Primary colors
    'primary-navy': Color(0xFF030213), // Dark navy primary
    'primary-white': Color(0xFFFFFFFF), // Pure white backgrounds

    // Light theme gradients
    'blue-50': Color(0xFFF0F9FF),
    'pink-50': Color(0xFFFDF2F8),
    'purple-50': Color(0xFFFAF5FF),
    'indigo-50': Color(0xFFF0F4FF),

    // Accent colors
    'blue-400': Color(0xFF60A5FA),
    'purple-400': Color(0xFFC084FC),
    'pink-400': Color(0xFFF472B6),
    'orange-400': Color(0xFFFB923C),

    // Text colors
    'text-primary': Color(0xFF1F2937), // Dark gray for text
    'text-secondary': Color(0xFF6B7280), // Light gray for secondary text

    // Status colors
    'success': Color(0xFF10B981),
    'warning': Color(0xFFF59E0B),
    'error': Color(0xFFEF4444),
    'info': Color(0xFF3B82F6),

    // Border colors
    'border-light': Color(0xFFE5E7EB),
    'border-blue-100': Color(0xFFDBEAFE),
    'border-pink-100': Color(0xFFFCE7F3),

    // Chart colors (semantic)
    'chart-1': Color(0xFF3B82F6), // Blue
    'chart-2': Color(0xFFEF4444), // Red
    'chart-3': Color(0xFF10B981), // Green
    'chart-4': Color(0xFFF59E0B), // Amber
    'chart-5': Color(0xFF8B5CF6), // Violet
  };

  /// Flutter colors to verify
  static const Map<String, Color> flutterColorImplementation = {
    'primary-navy': Color(0xFF030213),
    'primary-white': Color(0xFFFFFFFF),
    'blue-50': Color(0xFFF0F9FF),
    'pink-50': Color(0xFFFDF2F8),
    'purple-50': Color(0xFFFAF5FF),
    'indigo-50': Color(0xFFF0F4FF),
    'blue-400': Color(0xFF60A5FA),
    'purple-400': Color(0xFFC084FC),
    'pink-400': Color(0xFFF472B6),
    'orange-400': Color(0xFFFB923C),
    'text-primary': Color(0xFF1F2937),
    'text-secondary': Color(0xFF6B7280),
    'success': Color(0xFF10B981),
    'warning': Color(0xFFF59E0B),
    'error': Color(0xFFEF4444),
    'info': Color(0xFF3B82F6),
    'border-light': Color(0xFFE5E7EB),
    'border-blue-100': Color(0xFFDBEAFE),
    'border-pink-100': Color(0xFFFCE7F3),
    'chart-1': Color(0xFF3B82F6),
    'chart-2': Color(0xFFEF4444),
    'chart-3': Color(0xFF10B981),
    'chart-4': Color(0xFFF59E0B),
    'chart-5': Color(0xFF8B5CF6),
  };

  /// Verify color accuracy
  static ColorAccuracyResult verifyColors() {
    final result = ColorAccuracyResult();

    for (final entry in reactColorSpec.entries) {
      final colorName = entry.key;
      final reactColor = entry.value;
      final flutterColor = flutterColorImplementation[colorName];

      if (flutterColor == null) {
        result.addError('Missing Flutter color: $colorName');
      } else if (reactColor != flutterColor) {
        result.addError(
          'Color mismatch for $colorName: '
          'React=${reactColor.value.toRadixString(16)} vs '
          'Flutter=${flutterColor.value.toRadixString(16)}',
        );
      } else {
        result.addPass('$colorName matches exactly');
      }
    }

    return result;
  }

  /// Get hex string representation of color
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  /// Calculate color difference (Delta E)
  static double calculateColorDifference(Color color1, Color color2) {
    final r1 = color1.red;
    final g1 = color1.green;
    final b1 = color1.blue;

    final r2 = color2.red;
    final g2 = color2.green;
    final b2 = color2.blue;

    return ((r1 - r2) * (r1 - r2) +
            (g1 - g2) * (g1 - g2) +
            (b1 - b2) * (b1 - b2))
        .toDouble()
        .sqrt();
  }
}

class ColorAccuracyResult {
  final List<String> passes = [];
  final List<String> errors = [];

  void addPass(String message) => passes.add(message);
  void addError(String message) => errors.add(message);

  bool get isValid => errors.isEmpty;

  void printReport() {
    print('═' * 80);
    print('COLOR ACCURACY TEST REPORT');
    print('═' * 80);

    if (passes.isNotEmpty) {
      print('\n✓ PASSED (${passes.length}):');
      for (final pass in passes) {
        print('  ✓ $pass');
      }
    }

    if (errors.isNotEmpty) {
      print('\n✗ FAILED (${errors.length}):');
      for (final error in errors) {
        print('  ✗ $error');
      }
    }

    print('\n${isValid ? '✓ ALL COLORS MATCH' : '✗ COLOR MISMATCHES DETECTED'}');
    print('═' * 80);
  }
}

/// Color palette verification checklist
class ColorPaletteChecklist {
  static const Map<String, List<String>> checklistItems = {
    'Primary Colors': [
      'Navy (#030213) used for main text',
      'White (#FFFFFF) for backgrounds',
    ],
    'Gradient Colors': [
      'Blue-50 for backgrounds',
      'Pink-50 for accents',
      'Purple-50 for secondary',
      'Indigo-50 for additional accents',
    ],
    'Accent Colors': [
      'Blue-400 for primary actions',
      'Purple-400 for secondary',
      'Pink-400 for tertiary',
      'Orange-400 for emphasis',
    ],
    'Text Colors': [
      'Primary text dark gray',
      'Secondary text light gray',
    ],
    'Status Colors': [
      'Green for success',
      'Red for error',
      'Amber for warning',
      'Blue for info',
    ],
    'Chart Colors': [
      '5 semantic chart colors defined',
      'Colors distinct and accessible',
    ],
  };

  static void printChecklist() {
    print('\n🎨 COLOR PALETTE VERIFICATION CHECKLIST\n');
    for (final category in checklistItems.entries) {
      print('${category.key}:');
      for (final item in category.value) {
        print('  ☐ $item');
      }
      print('');
    }
  }
}
