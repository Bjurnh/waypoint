class PrayerEntry {
  final String id;
  final String title;
  final String? description;
  final String category;
  final DateTime dateAdded;
  final bool isAnswered;
  final DateTime? answeredDate;

  PrayerEntry({required this.id, required this.title, this.description, required this.category, required this.dateAdded, this.isAnswered = false, this.answeredDate});

  /// Convert object to JSON map for persistence
  Map<String, dynamic> toJson() {
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

  /// Create object from JSON map
  factory PrayerEntry.fromJson(Map<String, dynamic> json) {
    return PrayerEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      isAnswered: json['isAnswered'] as bool? ?? false,
      answeredDate: json['answeredDate'] != null
          ? DateTime.parse(json['answeredDate'] as String)
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
