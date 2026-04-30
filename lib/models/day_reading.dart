import 'package:hive/hive.dart';

part 'day_reading.g.dart';

/// A single day of the Bible reading plan. Stored in Hive for persistence.
@HiveType(typeId: 0)
class DayReading extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  List<String> chapters;

  @HiveField(3)
  bool completed;

  @HiveField(4)
  DateTime? completionDate;

  DayReading({
    required this.id,
    required this.date,
    required this.chapters,
    this.completed = false,
    this.completionDate,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'chapters': chapters,
        'completed': completed,
        'completionDate': completionDate?.toIso8601String(),
      };

  factory DayReading.fromMap(Map<String, dynamic> m) => DayReading(
        id: m['id'] as String,
        date: DateTime.parse(m['date'] as String),
        chapters: List<String>.from(m['chapters'] as List),
        completed: m['completed'] as bool? ?? false,
        completionDate: m['completionDate'] != null
            ? DateTime.parse(m['completionDate'] as String)
            : null,
      );
}
