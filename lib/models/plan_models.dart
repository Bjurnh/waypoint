class PlanConfig {
  int timeFrame;
  DateTime startDate;
  int dailyMinutes;
  String readingStyle;

  PlanConfig({required this.timeFrame, required this.startDate, required this.dailyMinutes, required this.readingStyle});
}

class DayReading {
  int day;
  String date;
  List<String> chapters;
  bool completed;
  bool isStreakActive;

  DayReading({required this.day, required this.date, required this.chapters, this.completed = false, this.isStreakActive = false});
}
