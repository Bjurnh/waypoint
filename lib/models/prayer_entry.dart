class PrayerEntry {
  final String id;
  final String title;
  final String? description;
  final String category;
  final DateTime dateAdded;
  final bool isAnswered;
  final DateTime? answeredDate;

  PrayerEntry({required this.id, required this.title, this.description, required this.category, required this.dateAdded, this.isAnswered = false, this.answeredDate});

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
