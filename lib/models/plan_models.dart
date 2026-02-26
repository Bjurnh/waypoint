class PlanConfig {
  int timeFrame;
  DateTime startDate;
  int dailyMinutes;
  String readingStyle;

  PlanConfig({required this.timeFrame, required this.startDate, required this.dailyMinutes, required this.readingStyle});

  Map<String, dynamic> toJson() {
    return {
      'timeFrame': timeFrame,
      'startDate': startDate.toIso8601String(),
      'dailyMinutes': dailyMinutes,
      'readingStyle': readingStyle,
    };
  }

  factory PlanConfig.fromJson(Map<String, dynamic> json) {
    return PlanConfig(
      timeFrame: json['timeFrame'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      dailyMinutes: json['dailyMinutes'] as int,
      readingStyle: json['readingStyle'] as String,
    );
  }
}

class DayReading {
  int day;
  String date;
  List<String> chapters;
  bool completed;
  bool isStreakActive;

  DayReading({required this.day, required this.date, required this.chapters, this.completed = false, this.isStreakActive = false});

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'date': date,
      'chapters': chapters,
      'completed': completed,
      'isStreakActive': isStreakActive,
    };
  }

  factory DayReading.fromJson(Map<String, dynamic> json) {
    return DayReading(
      day: json['day'] as int,
      date: json['date'] as String,
      chapters: List<String>.from(json['chapters'] as List<dynamic>),
      completed: json['completed'] as bool? ?? false,
      isStreakActive: json['isStreakActive'] as bool? ?? false,
    );
  }
}
