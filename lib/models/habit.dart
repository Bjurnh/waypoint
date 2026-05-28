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
  });

  IconData get icon => IconData(
        iconCodePoint,
        fontFamily: iconFontFamily,
        fontPackage: iconFontPackage,
      );

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
    );
  }
}

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 3;

  @override
  Habit read(BinaryReader reader) {
    return Habit(
      id: reader.readString(),
      title: reader.readString(),
      subtitle: reader.readString(),
      category: reader.readString(),
      progress: reader.readDouble(),
      streak: reader.readInt(),
      colorValue: reader.readInt(),
      iconCodePoint: reader.readInt(),
      iconFontFamily: reader.readString(),
      iconFontPackage: reader.readBool() ? reader.readString() : null,
      completedToday: reader.readBool(),
      weekData: List<bool>.from(reader.readList()),
      completionRate: reader.readDouble(),
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
  }
}
