import 'package:flutter/material.dart';
import 'package:waypoint/services/hive_service.dart';
import '../models/day_reading.dart';
import '../models/habit.dart';
import '../models/prayer_entry.dart';
import '../models/plan_config.dart';
import '../models/plan_models.dart' as plan_models;
import '../services/notification_service.dart';
import '../theme/app_colors.dart';

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
  final HiveService _hive = HiveService();

  List<DayReading> readings = [];
  List<Habit> habits = [];
  List<PrayerEntry> prayers = [];
  PlanConfig? config;
  int currentStreak = 0;
  double spiritualScore = 0.0;

  // additional state used by screens
  final List<Reminder> _reminders = [];
  List<Reminder> get reminders => List.unmodifiable(_reminders);

  /// When a prayer is selected for viewing we keep a reference here. It isn't
  /// strictly needed for current code, but the screens assume a "viewPrayer"
  /// call exists so we store it in state.
  PrayerEntry? _selectedPrayer;
  PrayerEntry? get selectedPrayer => _selectedPrayer;

  /// Generated plan configuration used for progress dashboard. This mirrors
  /// the JS/TS version of the app and is distinct from the Hive-backed
  /// [config] above.
  plan_models.PlanConfig generatedPlanConfig = plan_models.PlanConfig(
    timeFrame: 30,
    startDate: DateTime.now(),
    dailyMinutes: 15,
    readingStyle: 'mixed',
  );

  /// Convenience getter used by some screens so they don't have to know which
  /// list the app stores internally.
  List<DayReading> get allReadings => readings;

  AppState();

  Future<void> loadData() async {
    // Note: Hive is already initialized in main(), no need to call init() again
    readings = _hive.readingsBox.values.toList();
    prayers = _hive.prayersBox.values.toList();
    config = _hive.configBox.isNotEmpty ? _hive.configBox.values.first : null;
    await loadHabits();
    _recalculate();
    notifyListeners();
  }

  Future<void> saveReadings() async {
    final box = _hive.readingsBox;
    await box.clear();
    for (var r in readings) {
      await box.put(r.id, r);
    }
  }

  Future<void> savePrayers() async {
    final box = _hive.prayersBox;
    await box.clear();
    for (var p in prayers) {
      await box.put(p.id, p);
    }
  }

  Future<void> saveConfig() async {
    final box = _hive.configBox;
    await box.clear();
    if (config != null) {
      await box.put('config', config!);
    }
  }

  Future<void> loadHabits() async {
    final loadedHabits = _hive.habitsBox.values.toList();
    if (loadedHabits.isEmpty) {
      habits = _defaultHabits();
      await saveHabits();
      return;
    }

    final today = DateTime.now();
    var changed = false;
    habits = loadedHabits.map((habit) {
      final normalizedHabit = habit.normalizedForDate(today);
      if (!identical(habit, normalizedHabit)) {
        changed = true;
      }
      return normalizedHabit;
    }).toList();

    if (changed) {
      await saveHabits();
    }
  }

  Future<void> saveHabits() async {
    final box = _hive.habitsBox;
    await box.clear();
    for (var habit in habits) {
      await box.put(habit.id, habit);
    }
  }

  Future<void> toggleHabitCompletion(String id) async {
    final index = habits.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final now = DateTime.now();
    final habit = habits[index].normalizedForDate(now);
    final completed = !habit.completedToday;
    final weekData = List<bool>.from(habit.weekData);
    if (weekData.length != 7) {
      for (int i = weekData.length; i < 7; i++) {
        weekData.add(false);
      }
    }
    weekData[weekData.length - 1] = completed;

    final completionRate = weekData.where((value) => value).length / weekData.length;
    final updatedHabit = habit.copyWith(
      completedToday: completed,
      streak: completed ? habit.streak + 1 : (habit.streak > 0 ? habit.streak - 1 : 0),
      weekData: weekData,
      completionRate: completionRate,
      progress: completionRate,
      lastUpdatedEpoch: now.millisecondsSinceEpoch,
    );

    habits[index] = updatedHabit;
    await saveHabits();
    notifyListeners();
  }

  List<Habit> _defaultHabits() {
    return [
      Habit(
        id: 'habit_read_bible',
        title: 'Read Bible',
        subtitle: 'Daily 15 min',
        category: 'Reading',
        progress: 0.6,
        streak: 7,
        colorValue: AppColors.blueGradientStart.value,
        iconCodePoint: Icons.import_contacts.codePoint,
        iconFontFamily: Icons.import_contacts.fontFamily ?? 'MaterialIcons',
        iconFontPackage: Icons.import_contacts.fontPackage,
        iconKey: 'import_contacts',
        completedToday: false,
        weekData: [true, true, false, true, true, false, false],
        completionRate: 0.62,
        lastUpdatedEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      Habit(
        id: 'habit_prayer',
        title: 'Prayer',
        subtitle: 'Morning & Night',
        category: 'Prayer',
        progress: 0.8,
        streak: 14,
        colorValue: AppColors.pinkGradientStart.value,
        iconCodePoint: Icons.favorite.codePoint,
        iconFontFamily: Icons.favorite.fontFamily ?? 'MaterialIcons',
        iconFontPackage: Icons.favorite.fontPackage,
        iconKey: 'favorite',
        completedToday: true,
        weekData: [true, true, true, true, true, true, false],
        completionRate: 0.86,
        lastUpdatedEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      Habit(
        id: 'habit_meditation',
        title: 'Meditation',
        subtitle: 'Evening wind-down',
        category: 'Meditation',
        progress: 0.5,
        streak: 3,
        colorValue: AppColors.greenGradientStart.value,
        iconCodePoint: Icons.psychology.codePoint,
        iconFontFamily: Icons.psychology.fontFamily ?? 'MaterialIcons',
        iconFontPackage: Icons.psychology.fontPackage,
        iconKey: 'psychology',
        completedToday: false,
        weekData: [true, false, true, false, false, true, false],
        completionRate: 0.43,
        lastUpdatedEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      Habit(
        id: 'habit_journal',
        title: 'Journal',
        subtitle: 'Reflections',
        category: 'Journaling',
        progress: 0.7,
        streak: 5,
        colorValue: AppColors.purpleGradientStart.value,
        iconCodePoint: Icons.edit_note.codePoint,
        iconFontFamily: Icons.edit_note.fontFamily ?? 'MaterialIcons',
        iconFontPackage: Icons.edit_note.fontPackage,
        iconKey: 'edit_note',
        completedToday: true,
        weekData: [true, true, false, true, true, true, false],
        completionRate: 0.71,
        lastUpdatedEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
    ];
  }

  /// Adds a new prayer entry and persists to Hive.
  Future<void> addPrayer({
    required String title,
    required String description,
    String category = 'Personal',
  }) async {
    final entry = PrayerEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      dateAdded: DateTime.now(),
    );
    prayers.add(entry);
    await savePrayers();
    _recalculate();
    notifyListeners();
  }

  /// Marks a particular prayer as the one the user is currently viewing.
  /// The caller can then read [selectedPrayer] if necessary (e.g. when using
  /// a named route to render a detail page).
  void viewPrayer(String id) {
    final idx = prayers.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    _selectedPrayer = prayers[idx];
    notifyListeners();
  }

  /// Allows external code (e.g. the plan generation screen) to update the
  /// generated plan configuration used by the dashboard.
  void setGeneratedPlanConfig(plan_models.PlanConfig config) {
    generatedPlanConfig = config;
    notifyListeners();
  }

  /// Generates a new reading plan based on the provided configuration.
  Future<void> generatePlan(plan_models.PlanConfig config) async {
    generatedPlanConfig = config;

    // Convert to storage model
    this.config = PlanConfig(
      length: config.timeFrame,
      startDate: config.startDate,
      style: config.readingStyle,
    );

    final chapters = config.mode == plan_models.PlanMode.continueCurrent
        ? _getRemainingBibleChapters(config)
        : _getBibleChapters(config.readingStyle);

    readings = _buildReadings(chapters, config.timeFrame, config.startDate);

    await saveReadings();
    await saveConfig();
    _recalculate();
    notifyListeners();

    // Schedule notifications for the plan
    await _scheduleReadingReminders(config);
  }

  List<plan_models.BibleChapter> _getRemainingBibleChapters(
      plan_models.PlanConfig config) {
    final allChapters = _getBibleChapters(config.readingStyle);
    final startIndex =
        _findChapterIndex(allChapters, config.lastBook, config.lastChapter);
    return allChapters.sublist(startIndex);
  }

  int _findChapterIndex(
    List<plan_models.BibleChapter> chapters,
    String? book,
    int? chapter,
  ) {
    if (book == null || chapter == null) return 0;
    final normalizedBook = book.trim().toLowerCase();

    final index = chapters.indexWhere((item) {
      return item.book.toLowerCase() == normalizedBook &&
          item.chapter == chapter;
    });

    return index >= 0 ? index : 0;
  }

  List<DayReading> _buildReadings(
    List<plan_models.BibleChapter> chapters,
    int totalDays,
    DateTime startDate,
  ) {
    if (totalDays <= 0 || chapters.isEmpty) {
      return [];
    }

    final totalWeight = chapters.fold<int>(0, (sum, item) => sum + item.verses);
    final targetPerDay = totalWeight / totalDays;
    final days = <_ChapterDay>[];
    var currentWeight = 0;
    var currentChapters = <plan_models.BibleChapter>[];

    for (final chapter in chapters) {
      final shouldFlush = currentChapters.isNotEmpty &&
          currentWeight >= targetPerDay &&
          days.length < totalDays - 1;

      if (shouldFlush) {
        days.add(_ChapterDay(chapters: currentChapters, weight: currentWeight));
        currentWeight = 0;
        currentChapters = [];
      }

      currentChapters.add(chapter);
      currentWeight += chapter.verses;
    }

    if (currentChapters.isNotEmpty) {
      days.add(_ChapterDay(chapters: currentChapters, weight: currentWeight));
    }

    final normalizedDays = _normalizeDayChunks(days, totalDays);

    while (normalizedDays.length < totalDays) {
      normalizedDays.add(_ChapterDay(chapters: [], weight: 0));
    }

    return normalizedDays.asMap().entries.map((entry) {
      final dayIndex = entry.key;
      final chunk = entry.value;
      return DayReading(
        id: 'reading_$dayIndex',
        date: startDate.add(Duration(days: dayIndex)),
        chapters: chunk.chapters.map((chapter) => chapter.label).toList(),
        completed: false,
      );
    }).toList();
  }

  List<_ChapterDay> _normalizeDayChunks(
      List<_ChapterDay> days, int targetCount) {
    if (days.length > targetCount) {
      while (days.length > targetCount) {
        days = _mergeSmallestAdjacentDays(days);
      }
    } else if (days.length < targetCount) {
      while (days.length < targetCount) {
        final splitIndex = _findLargestSplittableDay(days);
        if (splitIndex == -1) {
          break;
        }
        final dayToSplit = days[splitIndex];
        final firstCount = _chooseSplitIndex(dayToSplit);
        final firstChunk = dayToSplit.chapters.sublist(0, firstCount);
        final secondChunk = dayToSplit.chapters.sublist(firstCount);

        days[splitIndex] = _ChapterDay(
          chapters: firstChunk,
          weight: firstChunk.fold<int>(0, (sum, item) => sum + item.verses),
        );
        days.insert(
          splitIndex + 1,
          _ChapterDay(
            chapters: secondChunk,
            weight: secondChunk.fold<int>(0, (sum, item) => sum + item.verses),
          ),
        );
      }
    }

    return days;
  }

  List<_ChapterDay> _mergeSmallestAdjacentDays(List<_ChapterDay> days) {
    if (days.length < 2) return days;

    var mergeIndex = 0;
    var smallestWeight = double.infinity;

    for (var i = 0; i < days.length - 1; i++) {
      final combinedWeight = days[i].weight + days[i + 1].weight;
      if (combinedWeight < smallestWeight) {
        smallestWeight = combinedWeight.toDouble();
        mergeIndex = i;
      }
    }

    final merged = _ChapterDay(
      chapters: [
        ...days[mergeIndex].chapters,
        ...days[mergeIndex + 1].chapters
      ],
      weight: days[mergeIndex].weight + days[mergeIndex + 1].weight,
    );

    return [
      ...days.sublist(0, mergeIndex),
      merged,
      ...days.sublist(mergeIndex + 2),
    ];
  }

  int _findLargestSplittableDay(List<_ChapterDay> days) {
    var bestIndex = -1;
    var bestWeight = -1;
    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      if (day.chapters.length <= 1) continue;
      if (day.weight > bestWeight) {
        bestWeight = day.weight;
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  int _chooseSplitIndex(_ChapterDay day) {
    final halfWeight = day.weight / 2;
    var cumulative = 0;
    for (var i = 0; i < day.chapters.length; i++) {
      cumulative += day.chapters[i].verses;
      if (cumulative >= halfWeight) {
        final splitAt = i + 1;
        final clamped = splitAt.clamp(1, day.chapters.length - 1);
        return clamped;
      }
    }
    return 1;
  }

  List<plan_models.BibleChapter> _getBibleChapters(String readingStyle) {
    const chapterCounts = {
      'Genesis': 50,
      'Exodus': 40,
      'Leviticus': 27,
      'Numbers': 36,
      'Deuteronomy': 34,
      'Joshua': 24,
      'Judges': 21,
      'Ruth': 4,
      '1 Samuel': 31,
      '2 Samuel': 24,
      '1 Kings': 22,
      '2 Kings': 25,
      '1 Chronicles': 29,
      '2 Chronicles': 36,
      'Ezra': 10,
      'Nehemiah': 13,
      'Esther': 10,
      'Job': 42,
      'Psalms': 150,
      'Proverbs': 31,
      'Ecclesiastes': 12,
      'Song of Solomon': 8,
      'Isaiah': 66,
      'Jeremiah': 52,
      'Lamentations': 5,
      'Ezekiel': 48,
      'Daniel': 12,
      'Hosea': 14,
      'Joel': 3,
      'Amos': 9,
      'Obadiah': 1,
      'Jonah': 4,
      'Micah': 7,
      'Nahum': 3,
      'Habakkuk': 3,
      'Zephaniah': 3,
      'Haggai': 2,
      'Zechariah': 14,
      'Malachi': 4,
      'Matthew': 28,
      'Mark': 16,
      'Luke': 24,
      'John': 21,
      'Acts': 28,
      'Romans': 16,
      '1 Corinthians': 16,
      '2 Corinthians': 13,
      'Galatians': 6,
      'Ephesians': 6,
      'Philippians': 4,
      'Colossians': 4,
      '1 Thessalonians': 5,
      '2 Thessalonians': 3,
      '1 Timothy': 6,
      '2 Timothy': 4,
      'Titus': 3,
      'Philemon': 1,
      'Hebrews': 13,
      'James': 5,
      '1 Peter': 5,
      '2 Peter': 3,
      '1 John': 5,
      '2 John': 1,
      '3 John': 1,
      'Jude': 1,
      'Revelation': 22,
    };

    final chapters = <plan_models.BibleChapter>[];
    for (final entry in chapterCounts.entries) {
      for (var chapter = 1; chapter <= entry.value; chapter++) {
        chapters.add(plan_models.BibleChapter(
          book: entry.key,
          chapter: chapter,
          verses: _estimateChapterVerseCount(entry.key, chapter),
        ));
      }
    }

    // For mixed style, interleave Old Testament and New Testament chapters
    if (readingStyle == 'mixed') {
      return _createMixedOrderChapters(chapters);
    }

    // For sequential style, return chapters in order
    return chapters;
  }

  List<plan_models.BibleChapter> _createMixedOrderChapters(List<plan_models.BibleChapter> sequentialChapters) {
    final oldTestament = <plan_models.BibleChapter>[];
    final newTestament = <plan_models.BibleChapter>[];

    // Split chapters into Old and New Testament
    // Old Testament: Genesis to Malachi (39 books)
    // New Testament: Matthew to Revelation (27 books)
    const oldTestamentBooks = [
      'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy',
      'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
      '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles',
      'Ezra', 'Nehemiah', 'Esther', 'Job', 'Psalms',
      'Proverbs', 'Ecclesiastes', 'Song of Solomon',
      'Isaiah', 'Jeremiah', 'Lamentations', 'Ezekiel',
      'Daniel', 'Hosea', 'Joel', 'Amos', 'Obadiah',
      'Jonah', 'Micah', 'Nahum', 'Habakkuk', 'Zephaniah',
      'Haggai', 'Zechariah', 'Malachi'
    ];

    for (final chapter in sequentialChapters) {
      if (oldTestamentBooks.contains(chapter.book)) {
        oldTestament.add(chapter);
      } else {
        newTestament.add(chapter);
      }
    }

    // Interleave Old and New Testament chapters
    final mixedChapters = <plan_models.BibleChapter>[];
    final maxLength = oldTestament.length > newTestament.length
        ? oldTestament.length
        : newTestament.length;

    for (var i = 0; i < maxLength; i++) {
      if (i < oldTestament.length) {
        mixedChapters.add(oldTestament[i]);
      }
      if (i < newTestament.length) {
        mixedChapters.add(newTestament[i]);
      }
    }

    return mixedChapters;
  }

  int _estimateChapterVerseCount(String book, int chapter) {
    const baseVerses = {
      'Genesis': 31,
      'Exodus': 28,
      'Leviticus': 25,
      'Numbers': 28,
      'Deuteronomy': 29,
      'Joshua': 25,
      'Judges': 24,
      'Ruth': 15,
      '1 Samuel': 24,
      '2 Samuel': 21,
      '1 Kings': 19,
      '2 Kings': 20,
      '1 Chronicles': 21,
      '2 Chronicles': 20,
      'Ezra': 20,
      'Nehemiah': 21,
      'Esther': 15,
      'Job': 20,
      'Psalms': 30,
      'Proverbs': 20,
      'Ecclesiastes': 18,
      'Song of Solomon': 17,
      'Isaiah': 26,
      'Jeremiah': 25,
      'Lamentations': 30,
      'Ezekiel': 25,
      'Daniel': 18,
      'Hosea': 18,
      'Joel': 20,
      'Amos': 20,
      'Obadiah': 20,
      'Jonah': 20,
      'Micah': 20,
      'Nahum': 20,
      'Habakkuk': 20,
      'Zephaniah': 20,
      'Haggai': 20,
      'Zechariah': 22,
      'Malachi': 18,
      'Matthew': 23,
      'Mark': 20,
      'Luke': 24,
      'John': 25,
      'Acts': 22,
      'Romans': 21,
      '1 Corinthians': 20,
      '2 Corinthians': 19,
      'Galatians': 18,
      'Ephesians': 17,
      'Philippians': 18,
      'Colossians': 18,
      '1 Thessalonians': 18,
      '2 Thessalonians': 18,
      '1 Timothy': 18,
      '2 Timothy': 18,
      'Titus': 20,
      'Philemon': 25,
      'Hebrews': 18,
      'James': 18,
      '1 Peter': 18,
      '2 Peter': 18,
      '1 John': 18,
      '2 John': 20,
      '3 John': 20,
      'Jude': 20,
      'Revelation': 18,
    };

    final base = baseVerses[book] ?? 20;
    if (book == 'Psalms' && chapter == 119) {
      return 176;
    }

    final offset = ((chapter % 5) - 2) * 3;
    final estimate = base + offset;
    if (estimate < 8) return 8;
    if (estimate > 60) return 60;
    return estimate;
  }

  Future<void> _scheduleReadingReminders(plan_models.PlanConfig config) async {
    // Cancel existing notifications
    await NotificationService.cancelAll();

    // Schedule daily reminders at 8 AM for upcoming readings
    final now = DateTime.now();
    for (final reading in readings) {
      if (!reading.completed &&
          reading.date.isAfter(now.subtract(const Duration(days: 1)))) {
        final reminderTime = DateTime(
          reading.date.year,
          reading.date.month,
          reading.date.day,
          8, // 8 AM
          0,
        );

        if (reminderTime.isAfter(now)) {
          await NotificationService.scheduleNotification(
            id: int.parse(reading.id.split('_').last),
            title: 'Bible Reading Reminder',
            body: 'Time for your daily reading: ${reading.chapters.join(", ")}',
            scheduledDate: reminderTime,
            payload: reading.id,
          );
        }
      }
    }
  }

  /// Reminders -- simple in-memory storage for now. Could be persisted later.
  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void updateReminder(Reminder reminder) {
    final idx = _reminders.indexWhere((r) => r.id == reminder.id);
    if (idx == -1) return;
    _reminders[idx] = reminder;
    notifyListeners();
  }

  Future<void> toggleReadingCompletion(String id) async {
    final idx = readings.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    final item = readings[idx];
    item.completed = !item.completed;
    item.completionDate = item.completed ? DateTime.now() : null;
    await saveReadings();
    _recalculate();
    notifyListeners();
  }

  Future<void> togglePrayerAnswered(String? id) async {
    if (id == null) return;
    final idx = prayers.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    final entry = prayers[idx];
    entry.isAnswered = !entry.isAnswered;
    entry.answeredDate = entry.isAnswered ? DateTime.now() : null;
    await savePrayers();
    _recalculate();
    notifyListeners();
  }

  void _recalculate() {
    currentStreak = _calculateStreak();
    spiritualScore = _calculateSpiritualScore();
  }

  int _calculateStreak() {
    final completedDates = readings
        .where((r) => r.completed && r.completionDate != null)
        .map((r) => r.completionDate!)
        .toList();
    if (completedDates.isEmpty) return 0;
    completedDates.sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime? prev;
    for (var date in completedDates) {
      if (prev == null) {
        streak = 1;
        prev = date;
      } else {
        final diff = prev.difference(date).inDays;
        if (diff <= 3) {
          streak++;
          prev = date;
        } else {
          break;
        }
      }
    }
    return streak;
  }

  double _calculateSpiritualScore() {
    final totalReadings = readings.length;
    final completed = readings.where((r) => r.completed).length;
    final readingRate = totalReadings == 0 ? 0.0 : completed / totalReadings;

    final totalPrayers = prayers.length;
    final answered = prayers.where((p) => p.isAnswered).length;
    final answeredRate = totalPrayers == 0 ? 0.0 : answered / totalPrayers;

    final streakWeight = (currentStreak / 30).clamp(0.0, 1.0);

    return readingRate * 0.6 + answeredRate * 0.3 + streakWeight * 0.1;
  }
}

class _ChapterDay {
  final List<plan_models.BibleChapter> chapters;
  final int weight;

  _ChapterDay({required this.chapters, required this.weight});
}
