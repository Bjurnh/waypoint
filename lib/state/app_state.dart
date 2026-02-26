import 'package:flutter/material.dart';
import '../models/prayer_entry.dart';
import '../models/plan_models.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

/// A simple scheduled reminder for notifications
class Reminder {
  final String id;
  String title;
  TimeOfDay time;
  bool enabled;

  Reminder({
    required this.id,
    required this.title,
    required this.time,
    this.enabled = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hour': time.hour,
      'minute': time.minute,
      'enabled': enabled,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      title: json['title'] as String,
      time: TimeOfDay(
        hour: json['hour'] as int,
        minute: json['minute'] as int,
      ),
      enabled: json['enabled'] as bool? ?? false,
    );
  }
}

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

  // Lazy loading flag - true when data is loaded
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // user reminders that drive scheduled notifications
  List<Reminder> reminders = [];

  AppState() {
    // Don't load from storage immediately - lazy load instead
  }

  /// Initialize data in background (call after app starts)
  Future<void> initialize() async {
    if (_isInitialized) return; // Already initialized
    
    await _loadFromStorage();
    _isInitialized = true;
  }

  /// Lazy load data on first access
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _loadFromStorage() async {
    // Load data from storage
    try {
      final rawPrayers = await StorageService.loadPrayers();
      if (rawPrayers != null) {
        prayers = rawPrayers
            .map((e) => PrayerEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      final rawConfig = await StorageService.loadPlanConfig();
      if (rawConfig != null) {
        generatedPlanConfig = PlanConfig.fromJson(rawConfig);
      }

      final rawReadings = await StorageService.loadReadings();
      if (rawReadings != null) {
        allReadings = rawReadings
            .map((e) => DayReading.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _generateInitialReadings();
      }

      final savedStreak = await StorageService.loadStreak();
      if (savedStreak != null) {
        currentStreak = savedStreak;
      }

      final rawRem = await StorageService.loadReminders();
      if (rawRem != null) {
        reminders = rawRem
            .map((e) => Reminder.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      // if any error occurs, just continue with defaults
    }

    notifyListeners();
  }

  void _generateInitialReadings() {
    allReadings = List.generate(30, (i) => DayReading(day: i + 1, date: DateTime.now().add(Duration(days: i)).toIso8601String().split('T')[0], chapters: ['Genesis ${i + 1}']));
  }

  void addPrayer({required String title, String? description, String category = 'general'}) {
    final p = PrayerEntry(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title, description: description, category: category, dateAdded: DateTime.now());
    prayers.insert(0, p);
    notifyListeners();
    StorageService.savePrayers(prayers.map((e) => e.toJson()).toList());
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
    StorageService.savePrayers(prayers.map((e) => e.toJson()).toList());
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
    StorageService.savePlanConfig(config.toJson());
    StorageService.saveReadings(allReadings.map((r) => r.toJson()).toList());
    StorageService.saveStreak(currentStreak);

    // fire a quick notification to inform user that plan was updated
    NotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Bible Plan Updated',
      body: 'Your reading plan for today is ready',
    );
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
    StorageService.saveReadings(allReadings.map((r) => r.toJson()).toList());
    StorageService.saveStreak(currentStreak);
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

  // ----------------------------------------------------------
  // Reminder helpers
  // ----------------------------------------------------------

  void addReminder(Reminder reminder) {
    reminders.add(reminder);
    notifyListeners();
    _saveReminders();
    _updateScheduling(reminder);
  }

  void updateReminder(Reminder reminder) {
    final idx = reminders.indexWhere((r) => r.id == reminder.id);
    if (idx != -1) {
      reminders[idx] = reminder;
      notifyListeners();
      _saveReminders();
      _updateScheduling(reminder);
    }
  }

  void _saveReminders() {
    StorageService.saveReminders(reminders.map((r) => r.toJson()).toList());
  }

  void _updateScheduling(Reminder reminder) {
    final notifId = int.parse(reminder.id);
    if (reminder.enabled) {
      final now = DateTime.now();
      DateTime schedule = DateTime(now.year, now.month, now.day, reminder.time.hour, reminder.time.minute);
      if (schedule.isBefore(now)) {
        schedule = schedule.add(const Duration(days: 1));
      }
      NotificationService.scheduleNotification(
        id: notifId,
        title: reminder.title,
        body: reminder.title,
        scheduledDate: schedule,
      );
    } else {
      NotificationService.cancel(notifId);
    }
  }
}
