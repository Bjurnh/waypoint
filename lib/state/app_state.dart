import 'package:flutter/material.dart';
import '../models/prayer_entry.dart';
import '../models/plan_models.dart';

class AppState extends ChangeNotifier {
  List<PrayerEntry> prayers = [];
  PrayerEntry? selectedPrayer;

  PlanConfig generatedPlanConfig = PlanConfig(timeFrame: 90, startDate: DateTime.now(), dailyMinutes: 15, readingStyle: 'mixed');
  List<DayReading> allReadings = [];
  int currentPage = 0;
  int currentStreak = 0;

  bool isOnline = true;
  bool isSyncing = false;
  DateTime? lastSynced = DateTime.now();

  AppState() {
    // seed with sample prayers and initial readings
    prayers = [
      PrayerEntry(id: '1', title: 'Guidance for career decision', description: 'Praying for wisdom...', category: 'personal', dateAdded: DateTime.now().subtract(Duration(days: 10)), isAnswered: false),
      PrayerEntry(id: '2', title: "Mom's health recovery", description: 'Healing and strength', category: 'family', dateAdded: DateTime.now().subtract(Duration(days: 5)), isAnswered: true, answeredDate: DateTime.now().subtract(Duration(days: 2))),
    ];
    _generateInitialReadings();
  }

  void _generateInitialReadings() {
    allReadings = List.generate(30, (i) => DayReading(day: i + 1, date: DateTime.now().add(Duration(days: i)).toIso8601String().split('T')[0], chapters: ['Genesis ${i + 1}']));
  }

  void addPrayer({required String title, String? description, String category = 'general'}) {
    final p = PrayerEntry(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title, description: description, category: category, dateAdded: DateTime.now());
    prayers.insert(0, p);
    notifyListeners();
  }

  void togglePrayerAnswered(String id) {
    prayers = prayers.map((p) {
      if (p.id == id) {
        final was = p.isAnswered;
        return p.copyWith(isAnswered: !was, answeredDate: !was ? DateTime.now() : null);
      }
      return p;
    }).toList();
    notifyListeners();
  }

  void viewPrayer(String id) {
    if (prayers.isEmpty) {
      selectedPrayer = null;
    } else {
      selectedPrayer = prayers.firstWhere((p) => p.id == id, orElse: () => prayers.first);
    }
    notifyListeners();
  }

  void generatePlan(PlanConfig config) {
    generatedPlanConfig = config;
    // simple generation: replace readings
    allReadings = List.generate(config.timeFrame, (i) => DayReading(day: i + 1, date: config.startDate.add(Duration(days: i)).toIso8601String().split('T')[0], chapters: ['Genesis ${(i % 50) + 1}']));
    currentPage = 0;
    currentStreak = 0;
    notifyListeners();
  }

  void toggleCompletion(int day) {
    allReadings = allReadings.map((r) => r.day == day ? DayReading(day: r.day, date: r.date, chapters: r.chapters, completed: !r.completed, isStreakActive: r.isStreakActive) : r).toList();

    // recalc streak
    int streak = 0;
    final sorted = [...allReadings]..sort((a, b) => a.day.compareTo(b.day));
    for (final r in sorted) {
      if (r.completed) streak++; else break;
    }
    currentStreak = streak;
    notifyListeners();
  }

  void sync() {
    isSyncing = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 2), () {
      isSyncing = false;
      isOnline = true;
      lastSynced = DateTime.now();
      notifyListeners();
    });
  }
}
