import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Habit {
  String id;
  String title;
  String subtitle;
  String category;
  double progress;
  int streak;
  int colorValue;
  int iconCodePoint;
  String iconFontFamily;
  String? iconFontPackage;
  bool completedToday;
  List<bool> weekData;
  double completionRate;
  int lastUpdatedEpoch;

  Habit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.progress,
    required this.streak,
    required this.colorValue,
    required this.iconCodePoint,
    required this.iconFontFamily,
    this.iconFontPackage,
    this.completedToday = false,
    required this.weekData,
    required this.completionRate,
    required this.lastUpdatedEpoch,
  });

  IconData get icon => IconData(
        iconCodePoint,
        fontFamily: iconFontFamily,
        fontPackage: iconFontPackage,
      );

  DateTime get lastUpdated => DateTime.fromMillisecondsSinceEpoch(lastUpdatedEpoch);

  double get computedCompletionRate {
    if (weekData.isEmpty) return 0.0;
    return weekData.where((completed) => completed).length / weekData.length;
  }

  static List<bool> _normalizeWeekData(List<bool> data) {
    if (data.length == 7) return List<bool>.from(data);
    if (data.length > 7) {
      return data.sublist(data.length - 7);
    }
    return [for (int i = 0; i < 7 - data.length; i++) false, ...data];
  }

  Habit normalizedForDate(DateTime currentDate) {
    final normalizedToday = DateTime(currentDate.year, currentDate.month, currentDate.day);
    final normalizedTodayEpoch = normalizedToday.millisecondsSinceEpoch;
    final previousUpdate = DateTime(
      lastUpdated.year,
      lastUpdated.month,
      lastUpdated.day,
    );
    final diffDays = normalizedToday.difference(previousUpdate).inDays;
    var normalizedWeekData = _normalizeWeekData(weekData);

    if (diffDays <= 0 && normalizedWeekData.length == 7) {
      final expectedCompletionRate = computedCompletionRate;
      final expectedCompletedToday = normalizedWeekData.last;
      if (completedToday == expectedCompletedToday && completionRate == expectedCompletionRate) {
        return this;
      }
      return copyWith(
        completedToday: expectedCompletedToday,
        completionRate: expectedCompletionRate,
        weekData: normalizedWeekData,
      );
    }

    if (diffDays >= 7) {
      normalizedWeekData = List<bool>.filled(7, false);
    } else if (diffDays > 0) {
      final shifted = List<bool>.filled(7, false);
      for (int i = 0; i < 7 - diffDays; i++) {
        shifted[i] = normalizedWeekData[i + diffDays];
      }
      normalizedWeekData = shifted;
    }

    final normalizedCompletedToday = normalizedWeekData.last;
    return copyWith(
      completedToday: normalizedCompletedToday,
      weekData: normalizedWeekData,
      completionRate: normalizedWeekData.where((completed) => completed).length / normalizedWeekData.length,
      lastUpdatedEpoch: normalizedTodayEpoch,
    );
  }

  Color get color => Color(colorValue);

  Habit copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? category,
    double? progress,
    int? streak,
    int? colorValue,
    int? iconCodePoint,
    String? iconFontFamily,
    String? iconFontPackage,
    bool? completedToday,
    List<bool>? weekData,
    double? completionRate,
    int? lastUpdatedEpoch,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      progress: progress ?? this.progress,
      streak: streak ?? this.streak,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      iconFontPackage: iconFontPackage ?? this.iconFontPackage,
      completedToday: completedToday ?? this.completedToday,
      weekData: weekData ?? this.weekData,
      completionRate: completionRate ?? this.completionRate,
      lastUpdatedEpoch: lastUpdatedEpoch ?? this.lastUpdatedEpoch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'progress': progress,
      'streak': streak,
      'colorValue': colorValue,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
      'iconFontPackage': iconFontPackage,
      'completedToday': completedToday,
      'weekData': weekData,
      'completionRate': completionRate,
      'lastUpdatedEpoch': lastUpdatedEpoch,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> m) {
    return Habit(
      id: m['id'] as String,
      title: m['title'] as String,
      subtitle: m['subtitle'] as String,
      category: m['category'] as String,
      progress: (m['progress'] as num).toDouble(),
      streak: m['streak'] as int,
      colorValue: m['colorValue'] as int,
      iconCodePoint: m['iconCodePoint'] as int,
      iconFontFamily: m['iconFontFamily'] as String,
      iconFontPackage: m['iconFontPackage'] as String?,
      completedToday: m['completedToday'] as bool? ?? false,
      weekData: List<bool>.from(m['weekData'] as List<dynamic>),
      completionRate: (m['completionRate'] as num).toDouble(),
      lastUpdatedEpoch: m['lastUpdatedEpoch'] as int? ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 3;

  @override
  Habit read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final subtitle = reader.readString();
    final category = reader.readString();
    final progress = reader.readDouble();
    final streak = reader.readInt();
    final colorValue = reader.readInt();
    final iconCodePoint = reader.readInt();
    final iconFontFamily = reader.readString();
    final iconFontPackage = reader.readBool() ? reader.readString() : null;
    final completedToday = reader.readBool();
    final weekData = List<bool>.from(reader.readList());
    final completionRate = reader.readDouble();

    var lastUpdatedEpoch = DateTime.now().millisecondsSinceEpoch;
    try {
      lastUpdatedEpoch = reader.readInt();
    } catch (_) {
      // Existing habit data may not include this field yet.
    }

    return Habit(
      id: id,
      title: title,
      subtitle: subtitle,
      category: category,
      progress: progress,
      streak: streak,
      colorValue: colorValue,
      iconCodePoint: iconCodePoint,
      iconFontFamily: iconFontFamily,
      iconFontPackage: iconFontPackage,
      completedToday: completedToday,
      weekData: weekData,
      completionRate: completionRate,
      lastUpdatedEpoch: lastUpdatedEpoch,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.subtitle);
    writer.writeString(obj.category);
    writer.writeDouble(obj.progress);
    writer.writeInt(obj.streak);
    writer.writeInt(obj.colorValue);
    writer.writeInt(obj.iconCodePoint);
    writer.writeString(obj.iconFontFamily);
    writer.writeBool(obj.iconFontPackage != null);
    if (obj.iconFontPackage != null) {
      writer.writeString(obj.iconFontPackage!);
    }
    writer.writeBool(obj.completedToday);
    writer.writeList(obj.weekData);
    writer.writeDouble(obj.completionRate);
    writer.writeInt(obj.lastUpdatedEpoch);
  }
}
