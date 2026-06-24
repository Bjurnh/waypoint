import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waypoint/services/hive_service.dart';
import '../models/day_reading.dart';
import '../models/habit.dart';
import '../models/prayer_entry.dart';
import '../models/plan_config.dart';
import '../models/plan_models.dart' as plan_models;
import '../data/reading_plans/bible_in_year_plan.dart';
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

  // ------------------------------------------------------------------
  // Continue-from-current plan generation (Bible-in-a-Year)
  // ------------------------------------------------------------------

  List<DayReading> generateContinueFromCurrentPlan({
    required plan_models.PlanConfig config,
    required DateTime startDate,
  }) {
    final lastBook = config.lastBook?.trim();
    final lastChapter = config.lastChapter;
    if (lastBook == null || lastBook.isEmpty || lastChapter == null) {
      return <DayReading>[];
    }

    // Mixed OT + NT reading style.
    if (config.readingStyle == 'mixed') {
      // NT always starts from Matthew 1.
      const otBookOrder = <String>[
        'Genesis',
        'Exodus',
        'Leviticus',
        'Numbers',
        'Deuteronomy',
        'Joshua',
        'Judges',
        'Ruth',
        '1 Samuel',
        '2 Samuel',
        '1 Kings',
        '2 Kings',
        '1 Chronicles',
        '2 Chronicles',
        'Ezra',
        'Nehemiah',
        'Esther',
        'Job',
        'Psalms',
        'Proverbs',
        'Ecclesiastes',
        'Song of Solomon',
        'Isaiah',
        'Jeremiah',
        'Lamentations',
        'Ezekiel',
        'Daniel',
        'Hosea',
        'Joel',
        'Amos',
        'Obadiah',
        'Jonah',
        'Micah',
        'Nahum',
        'Habakkuk',
        'Zephaniah',
        'Haggai',
        'Zechariah',
        'Malachi',
      ];

      const ntBookOrder = <String>[
        'Matthew',
        'Mark',
        'Luke',
        'John',
        'Acts',
        'Romans',
        '1 Corinthians',
        '2 Corinthians',
        'Galatians',
        'Ephesians',
        'Philippians',
        'Colossians',
        '1 Thessalonians',
        '2 Thessalonians',
        '1 Timothy',
        '2 Timothy',
        'Titus',
        'Philemon',
        'Hebrews',
        'James',
        '1 Peter',
        '2 Peter',
        '1 John',
        '2 John',
        '3 John',
        'Jude',
        'Revelation',
      ];

      const chapterCounts = <String, int>{
        // OT
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
        // NT
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

      int clampChapter(int ch, int max) {
        if (ch < 1) return 1;
        if (ch > max) return max;
        return ch;
      }

      final int totalDays = config.timeFrame;
      if (totalDays <= 0) return <DayReading>[];

      // 1) Build OT remaining chapters list.
      final normalizedLastBook = lastBook.toLowerCase();
      final lastOtBookIndex = otBookOrder.indexWhere((b) => b.toLowerCase() == normalizedLastBook);
      final int otStartBookIndex = lastOtBookIndex == -1 ? 0 : lastOtBookIndex;
      final int otLastBookMax = chapterCounts[otBookOrder[otStartBookIndex]] ?? 0;
      final int rawOtFromChapter = lastOtBookIndex == -1 ? 1 : clampChapter(lastChapter + 1, otLastBookMax);

      final bool lastBookWasKnown = lastOtBookIndex != -1;
      final int effectiveOtFromBookIndex =
          !lastBookWasKnown ? otStartBookIndex : (rawOtFromChapter > otLastBookMax ? otStartBookIndex + 1 : otStartBookIndex);
      final int effectiveOtFromChapter =
          (!lastBookWasKnown || effectiveOtFromBookIndex > otStartBookIndex) ? 1 : rawOtFromChapter;

      final otRemaining = <String>[];
      for (int bi = effectiveOtFromBookIndex; bi < otBookOrder.length; bi++) {
        final book = otBookOrder[bi];
        final totalCh = chapterCounts[book] ?? 0;
        if (totalCh <= 0) continue;

        final int startCh = (bi == effectiveOtFromBookIndex) ? effectiveOtFromChapter : 1;
        if (startCh > totalCh) continue;

        for (int ch = startCh; ch <= totalCh; ch++) {
          otRemaining.add('$book $ch');
        }
      }

      // Edge: lastBook="Malachi" lastChapter=4 => OT list empty.
      // The logic above naturally yields an empty list in that case.

      // 2) Build NT remaining chapters list: always from Matthew 1.
      final ntRemaining = <String>[];
      for (int bi = 0; bi < ntBookOrder.length; bi++) {
        final book = ntBookOrder[bi];
        final totalCh = chapterCounts[book] ?? 0;
        if (totalCh <= 0) continue;
        final int startCh = (bi == 0) ? 1 : 1;
        for (int ch = startCh; ch <= totalCh; ch++) {
          ntRemaining.add('$book $ch');
        }
      }

      // Auto-calculate how many OT/NT chapters per day are needed to finish
      // within the available timeframe.
      final int daysAvailable = config.timeFrame;

      // OT gets 2/3 of daily reading, NT gets 1/3.
      final int otChaptersPerDay =
          ((otRemaining.length / daysAvailable) * 1).ceil().clamp(1, 10);
      final int ntChaptersPerDay =
          ((ntRemaining.length / daysAvailable) * 1).ceil().clamp(1, 5);

      debugPrint('Plan (mixed): ${otRemaining.length} OT, ${ntRemaining.length} NT, '
          '$daysAvailable days, $otChaptersPerDay OT/$ntChaptersPerDay NT per day');

      // 3-5) Group into days, combining lists.

      final prevByDate = {
        for (final r in readings)
          DateTime(r.date.year, r.date.month, r.date.day): r,
      };

      final result = <DayReading>[];
      int dayIndex = 0;
      int otIndex = 0;
      int ntIndex = 0;

      while (dayIndex < totalDays && (otIndex < otRemaining.length || ntIndex < ntRemaining.length)) {
        final dayChapters = <String>[];

        for (int i = 0; i < otChaptersPerDay && otIndex < otRemaining.length; i++) {
          dayChapters.add(otRemaining[otIndex]);
          otIndex++;
        }

        for (int i = 0; i < ntChaptersPerDay && ntIndex < ntRemaining.length; i++) {
          dayChapters.add(ntRemaining[ntIndex]);
          ntIndex++;
        }

        // If one testament is exhausted, the remaining days should get only the other.
        // (This is already satisfied by only pulling while the index is in-range.)

        final date = DateTime(startDate.year, startDate.month, startDate.day)
            .add(Duration(days: dayIndex));
        final prev = prevByDate[DateTime(date.year, date.month, date.day)];

        result.add(DayReading(
          id: 'reading_$dayIndex',
          date: date,
          chapters: dayChapters,
          completed: prev?.completed ?? false,
          completionDate: prev?.completionDate,
        ));

        dayIndex++;
      }

      return result;
    }

    // ------------------------------------------------------------------
    // Default existing sequential logic (unchanged)
    // ------------------------------------------------------------------

    // Hardcoded canonical book order (66 books) + chapter counts.
    const bookOrder = <String>[
      // OT
      'Genesis',
      'Exodus',
      'Leviticus',
      'Numbers',
      'Deuteronomy',
      'Joshua',
      'Judges',
      'Ruth',
      '1 Samuel',
      '2 Samuel',
      '1 Kings',
      '2 Kings',
      '1 Chronicles',
      '2 Chronicles',
      'Ezra',
      'Nehemiah',
      'Esther',
      'Job',
      'Psalms',
      'Proverbs',
      'Ecclesiastes',
      'Song of Solomon',
      'Isaiah',
      'Jeremiah',
      'Lamentations',
      'Ezekiel',
      'Daniel',
      'Hosea',
      'Joel',
      'Amos',
      'Obadiah',
      'Jonah',
      'Micah',
      'Nahum',
      'Habakkuk',
      'Zephaniah',
      'Haggai',
      'Zechariah',
      'Malachi',
      // NT
      'Matthew',
      'Mark',
      'Luke',
      'John',
      'Acts',
      'Romans',
      '1 Corinthians',
      '2 Corinthians',
      'Galatians',
      'Ephesians',
      'Philippians',
      'Colossians',
      '1 Thessalonians',
      '2 Thessalonians',
      '1 Timothy',
      '2 Timothy',
      'Titus',
      'Philemon',
      'Hebrews',
      'James',
      '1 Peter',
      '2 Peter',
      '1 John',
      '2 John',
      '3 John',
      'Jude',
      'Revelation',
    ];

    const chapterCounts = <String, int>{
      // OT
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
      // NT
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

    int clampChapter(int ch, int max) {
      if (ch < 1) return 1;
      if (ch > max) return max;
      return ch;
    }

    final normalizedLastBook = lastBook.toLowerCase();
    final lastBookIndex = bookOrder.indexWhere((b) => b.toLowerCase() == normalizedLastBook);

    // 1) Find starting position: next chapter in lastBook, not re-reading lastChapter.
    // If lastBook is the final OT book (Malachi 4), the next chapter should flow into NT (Matthew 1).
    final fromBookIndex = (lastBookIndex == -1) ? 0 : lastBookIndex;
    final lastBookMax = chapterCounts[bookOrder[fromBookIndex]] ?? 0;

    final rawFromChapter = lastBookIndex == -1 ? 1 : clampChapter(lastChapter + 1, lastBookMax);
    final effectiveFromBookIndex =
        lastBookIndex == -1 ? fromBookIndex : (rawFromChapter > lastBookMax ? fromBookIndex + 1 : fromBookIndex);
    final effectiveFromChapter =
        (lastBookIndex == -1 || effectiveFromBookIndex > fromBookIndex) ? 1 : rawFromChapter;

    // ISSUE 2: If we're already at the very end of the Bible (Revelation 22),
    // return no remaining chapters.
    if (lastBookIndex != -1 &&
        bookOrder[lastBookIndex].toLowerCase() == 'revelation' &&
        lastChapter == (chapterCounts['Revelation'] ?? 22)) {
      return <DayReading>[];
    }

    // 2) Build flat list of remaining chapters from that position.
    final remaining = <Map<String, int>>[];
    for (int bi = effectiveFromBookIndex; bi < bookOrder.length; bi++) {
      final book = bookOrder[bi];
      final totalCh = chapterCounts[book] ?? 0;
      if (totalCh <= 0) continue;

      // If we're starting at the last chapter of the effective book,
      // "next chapter" must move to the next book.
      if (bi == effectiveFromBookIndex && effectiveFromChapter >= totalCh) {
        continue;
      }

      final startCh = (bi == effectiveFromBookIndex) ? effectiveFromChapter : 1;
      for (int ch = startCh; ch <= totalCh; ch++) {
        remaining.add({'book': bi, 'chapter': ch});
      }
    }

    if (remaining.isEmpty) {
      return <DayReading>[];
    }

    // Map bi back to book name for display.
    String bookNameFromIndex(int bi) => bookOrder[bi];

    // 3) Group into days: each day gets exactly chaptersPerDay.
    // NOTE: PlanConfig doesn't currently expose chaptersPerDay; we derive it
    // so the plan always finishes exactly within the available timeframe.
    final totalChaptersRemaining = remaining.length;
    final daysAvailable = config.timeFrame;
    final chaptersPerDay = (totalChaptersRemaining / daysAvailable).ceil();

    debugPrint('Plan: $totalChaptersRemaining chapters, '
        '$daysAvailable days, $chaptersPerDay per day');


    final totalDays = config.timeFrame;
    if (totalDays <= 0) return <DayReading>[];

    final prevByDate = {
      for (final r in readings)
        DateTime(r.date.year, r.date.month, r.date.day): r,
    };

    final dayCount = (remaining.length / chaptersPerDay).ceil();
    final cappedDayCount = dayCount > totalDays ? totalDays : dayCount;

    // 4) Map each group into DayReading objects.
    final result = <DayReading>[];
    for (int dayIndex = 0; dayIndex < cappedDayCount; dayIndex++) {
      final start = dayIndex * chaptersPerDay;
      final end = (start + chaptersPerDay).clamp(0, remaining.length);
      final dayChapters = <String>[];
      for (int i = start; i < end; i++) {
        final bi = remaining[i]['book']!;
        final ch = remaining[i]['chapter']!;
        dayChapters.add('${bookNameFromIndex(bi)} $ch');
      }

      final date = DateTime(startDate.year, startDate.month, startDate.day)
          .add(Duration(days: dayIndex));
      final prev = prevByDate[DateTime(date.year, date.month, date.day)];

      result.add(DayReading(
        id: 'reading_$dayIndex',
        date: date,
        chapters: dayChapters,
        completed: prev?.completed ?? false,
        completionDate: prev?.completionDate,
      ));
    }

    // 5) If remaining chapters are empty, still return empty list.
    return result;
  }

  // ------------------------------------------------------------------
  // Profile (local-only for now)
  // ------------------------------------------------------------------
  String? displayName;

  String get effectiveDisplayName => (displayName?.trim().isNotEmpty ?? false)
      ? displayName!.trim()
      : 'Prayer Warrior';

  static const String _profileDisplayNameKey = 'profile_display_name';

  Future<void> loadProfileDefaultsIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_profileDisplayNameKey);
    if (stored != null && stored.trim().isNotEmpty) {
      displayName = stored.trim();
    }
  }

  Future<void> saveProfile({required String displayName}) async {
    final normalized = displayName.trim();
    this.displayName = normalized.isNotEmpty ? normalized : null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileDisplayNameKey, this.displayName ?? '');

    notifyListeners();
  }




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
    timeFrame: 365,
    startDate: DateTime.now(),
    dailyMinutes: 15,
    readingStyle: 'bibleInYear',
  );

  /// Convenience getter used by some screens so they don't have to know which
  /// list the app stores internally.
  List<DayReading> get allReadings => readings;

  AppState();

  /// Save profile details (currently stored in-memory only).
  ///
  /// If/when a persisted user profile model is added, wire this method to Hive.
  // NOTE: saveProfile is defined once above.



  Future<void> loadData() async {

    // Load persisted profile info (so name survives app restarts)
    await loadProfileDefaultsIfNeeded();

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
    // Avoid clearing the entire box on every toggle.
    // Hive objects are stored under their `id` key.
    for (final r in readings) {
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

  /// Ensures habit data reflects "today" (rollover across midnight).
  /// This fixes cases where the app stays open and UI would otherwise show
  /// stale [completedToday] / [weekData].
  Future<void> normalizeHabitsForNow({bool notify = true}) async {
    if (habits.isEmpty) return;

    final now = DateTime.now();
    var changed = false;

    final normalized = habits.map((habit) {
      final normalizedHabit = habit.normalizedForDate(now);
      if (!identical(habit, normalizedHabit)) {
        changed = true;
      }
      return normalizedHabit;
    }).toList();

    if (!changed) return;

    habits = normalized;
    await saveHabits();
    if (notify) notifyListeners();
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
    final planStartDate = config.startDate;

    if (config.readingStyle == 'bibleInYear') {
      // existing bibleInYear logic - start new plan only
      // do NOT route continueCurrent here anymore
      readings = createBibleInYearPlan(startDate: planStartDate);

      generatedPlanConfig = plan_models.PlanConfig(
        // timeFrame is derived from the PlanConfig passed from the generator,
        // which now represents “end at day-of-year 365” (so length can vary).
        timeFrame: config.timeFrame,
        startDate: planStartDate,
        dailyMinutes: config.dailyMinutes,
        readingStyle: config.readingStyle,
        mode: config.mode,
        lastBook: config.lastBook,
        lastChapter: config.lastChapter,
        lastVerse: config.lastVerse,
        targetType: config.targetType,
        targetEndDate: config.targetEndDate,
      );

      this.config = PlanConfig(
        length: config.timeFrame,
        startDate: planStartDate,
        style: config.readingStyle,
      );

    } else if (config.readingStyle == 'mixed' &&
        config.mode == plan_models.PlanMode.continueCurrent) {
      // mixed OT+NT continue mode
      readings = generateContinueFromCurrentPlan(
        config: config,
        startDate: planStartDate,
      );

      generatedPlanConfig = plan_models.PlanConfig(
        timeFrame: config.timeFrame,
        startDate: planStartDate,
        dailyMinutes: config.dailyMinutes,
        readingStyle: config.readingStyle,
        mode: config.mode,
        lastBook: config.lastBook,
        lastChapter: config.lastChapter,
        lastVerse: config.lastVerse,
        targetType: config.targetType,
        targetEndDate: config.targetEndDate,
      );

      this.config = PlanConfig(
        length: config.timeFrame,
        startDate: planStartDate,
        style: config.readingStyle,
      );

    } else if (config.readingStyle == 'sequential' &&
        config.mode == plan_models.PlanMode.continueCurrent) {
      // sequential continue mode
      readings = generateContinueFromCurrentPlan(
        config: config,
        startDate: planStartDate,
      );

      generatedPlanConfig = plan_models.PlanConfig(
        timeFrame: config.timeFrame,
        startDate: planStartDate,
        dailyMinutes: config.dailyMinutes,
        readingStyle: config.readingStyle,
        mode: config.mode,
        lastBook: config.lastBook,
        lastChapter: config.lastChapter,
        lastVerse: config.lastVerse,
        targetType: config.targetType,
        targetEndDate: config.targetEndDate,
      );

      this.config = PlanConfig(
        length: config.timeFrame,
        startDate: planStartDate,
        style: config.readingStyle,
      );

    } else {
      // default: sequential start new plan
      final chapters = _getBibleChapters(config.readingStyle);
      readings = _buildReadings(chapters, config.timeFrame, planStartDate);

      generatedPlanConfig = config;

      // Convert to storage model
      this.config = PlanConfig(
        length: config.timeFrame,
        startDate: planStartDate,
        style: config.readingStyle,
      );
    }

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

  /// Finds the index in the Bible-in-a-Year mixed plan from which the
  /// user's next unread reading should start.
  ///
  /// [fullPlan] days contain exactly two entries in [DayReading.chapters]:
  ///   - index 0: OT label (e.g. "Isaiah 40 - Isaiah 41")
  ///   - index 1: NT range label(s) (e.g. "John 3:1-16")
  int _findBibleInYearStartDayIndex(
    List<DayReading> fullPlan, {
    required String lastBook,
    required int lastChapter,
    int? lastVerse,
  }) {
    final needleBook = lastBook.trim().toLowerCase();

    // Conservative fallback: start from day 0.
    var best = 0;

    // Track the last day that matched the OT chapter. This prevents
    // erroneously falling back to day 0 when the match exists but the loop
    // doesn't "break" due to precision logic.
    //
    // Only used when verse precision isn't provided (common for saved state
    // where lastVerse is null).
    var lastOtMatchIndexPlusOne = -1;

    for (int i = 0; i < fullPlan.length; i++) {
      final day = fullPlan[i];
      final chapters = day.chapters;
      if (chapters.length < 2) continue;

      final otLabel = chapters.first;
      final ntLabel = chapters[1];

      final otMatches = _labelContainsBookChapter(otLabel, needleBook, lastChapter);
      final ntMatches = _labelContainsBookChapter(ntLabel, needleBook, lastChapter);

      if (lastVerse != null && lastVerse > 0) {
        // With verse precision: only consider a candidate day if the NT
        // chapter matches. OT-only chapter matches are ignored unless the
        // verse also lands inside the NT range.
        if (!ntMatches) continue;
      } else {
        // Without verse precision: require at least one of OT or NT match.
        if (!otMatches && !ntMatches) continue;
      }

      // Remember OT chapter matches for non-verse mode.
      if (lastVerse == null || lastVerse <= 0) {
        if (otMatches) {
          lastOtMatchIndexPlusOne = i + 1;
        }

        // No verse precision: any OT or NT chapter match means the last
        // read position is within this mixed day.
        best = i + 1;
        break;
      }

      final verseMatches = _labelContainsBookChapterVerse(
        ntLabel,
        needleBook,
        lastChapter,
        lastVerse,
      );

      if (verseMatches) {
        // Last read point is in the NT range for this day.
        best = i + 1;
        break;
      }

      // If we have verse precision and we didn't match NT range by verse,
      // allow OT chapter match to advance.
      if (otMatches) {
        best = i + 1;
        break;
      }
    }

    // If we never advanced (still 0) but we did find at least one OT match in
    // non-verse mode, fall back to the last matching day instead of day 0.
    if ((lastVerse == null || lastVerse <= 0) && best == 0 && lastOtMatchIndexPlusOne > 0) {
      best = lastOtMatchIndexPlusOne;
    }

    if (best < 0) best = 0;
    if (best > fullPlan.length) best = fullPlan.length;
    return best;
  }


  bool _labelContainsBookChapter(String label, String needleBook, int needleChapter) {
    final l = label.trim().toLowerCase();

    // OT label formats from _formatOtLabel():
    // 1) "Ezra 3" / "Ezra 3-9"
    // 2) "Genesis 49 - Ezra 1"
    // 3) "Ezra 7 - Nehemiah 1"
    // So we extract book/chapter pairs using regex and check any pair matches.
    //
    // We accept:
    // - optional spaces around dashes
    // - optional chapter ranges: "book 3-9"
    // - mixed-book dash: "bookA chA - bookB chB"
    //
    // Regex captures: book name (non-digits), chapter (digits)
    final re = RegExp(r'(?<book>[^0-9:]+?)\s*(?<chapter>\d+)\b');

    for (final m in re.allMatches(l)) {
      final book = (m.namedGroup('book') ?? '').trim();
      final ch = int.tryParse(m.namedGroup('chapter') ?? '');
      if (book.isEmpty || ch == null) continue;
      if (book == needleBook && ch == needleChapter) {
        return true;
      }
    }

    return false;
  }


  bool _labelContainsBookChapterVerse(
    String label,
    String needleBook,
    int needleChapter,
    int needleVerse,
  ) {
    final l = label.trim().toLowerCase();

    // We look for the first "book chapter:" segment.
    // Expected label format from formatter in bible_in_year_plan.dart:
    //   "Book chapter:startVerse-endVerse" or "Book chapter:startVerse-endVerse; ..."
    final rangeRe = RegExp(
      r'(?<book>[^0-9:;]+)\s*(?<chapter>\d+)\s*:\s*(?<startVerse>\d+)-(?<endVerse>\d+)',
    );

    for (final m in rangeRe.allMatches(l)) {
      final book = (m.namedGroup('book') ?? '').trim();
      final ch = int.tryParse(m.namedGroup('chapter') ?? '');
      final startV = int.tryParse(m.namedGroup('startVerse') ?? '');
      final endV = int.tryParse(m.namedGroup('endVerse') ?? '');

      if (book.toLowerCase() == needleBook && ch == needleChapter && startV != null && endV != null) {
        if (needleVerse >= startV && needleVerse <= endV) {
          return true;
        }
      }
    }

    return false;
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

    // Only sequential or Bible-in-a-Year plans are supported now.
    return chapters;
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
    if (idx == -1) {
      // Helpful debug signal: mismatched id vs current readings.
      // Remove/disable in production if desired.
      debugPrint('toggleReadingCompletion: id=$id not found');
      return;
    }

    final now = DateTime.now();
    final current = readings[idx];

    final updated = DayReading(
      id: current.id,
      date: current.date,
      chapters: List<String>.from(current.chapters),
      completed: !current.completed,
      completionDate: current.completed ? null : now,
    );

    // Replace element to avoid in-place mutation issues.
    readings = List<DayReading>.from(readings);
    readings[idx] = updated;

    await saveReadings();

    // Debug verification: ensure the selected reading id now maps to completed=true
    final postIdx = readings.indexWhere((r) => r.id == id);
    final postCompleted = postIdx == -1 ? null : readings[postIdx].completed;
    debugPrint('toggleReadingCompletion: id=$id updated.completed=${updated.completed}, postReadings.completed=$postCompleted');

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