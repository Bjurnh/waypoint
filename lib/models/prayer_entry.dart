import 'package:hive/hive.dart';

part 'prayer_entry.g.dart';

@HiveType(typeId: 2)
class PrayerEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  // category remains optional for legacy UI
  @HiveField(3)
  String? category;

  @HiveField(4)
  DateTime dateAdded;

  @HiveField(5)
  bool isAnswered;

  @HiveField(6)
  DateTime? answeredDate;

  PrayerEntry({
    required this.id,
    required this.title,
    this.description,
    this.category,
    required this.dateAdded,
    this.isAnswered = false,
    this.answeredDate,
  });

  /// Convert object to JSON map (still available for debugging or network work)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'dateAdded': dateAdded.toIso8601String(),
      'isAnswered': isAnswered,
      'answeredDate': answeredDate?.toIso8601String(),
    };
  }

  factory PrayerEntry.fromMap(Map<String, dynamic> m) {
    return PrayerEntry(
      id: m['id'] as String,
      title: m['title'] as String,
      description: m['description'] as String?,
      category: m['category'] as String?,
      dateAdded: DateTime.parse(m['dateAdded'] as String),
      isAnswered: m['isAnswered'] as bool? ?? false,
      answeredDate: m['answeredDate'] != null
          ? DateTime.parse(m['answeredDate'] as String)
          : null,
    );
  }

  PrayerEntry copyWith({String? id, String? title, String? description, String? category, DateTime? dateAdded, bool? isAnswered, DateTime? answeredDate}) {
    return PrayerEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dateAdded: dateAdded ?? this.dateAdded,
      isAnswered: isAnswered ?? this.isAnswered,
      answeredDate: answeredDate ?? this.answeredDate,
    );
  }
}
