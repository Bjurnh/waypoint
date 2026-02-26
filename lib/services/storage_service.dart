import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Simple persistence layer wrapping SharedPreferences.
/// Used by [AppState] to persist prayers, plan configuration, readings, etc.
class StorageService {
  StorageService._();

  static const String _prayersKey = 'prayers';
  static const String _planConfigKey = 'plan_config';
  static const String _readingsKey = 'readings';
  static const String _streakKey = 'streak';

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  /// Save a raw JSON-serializable object under [key].
  static Future<void> _saveJson(String key, Object value) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(value));
  }

  /// Load a JSON-encoded value from preferences, returning null if not found.
  static Future<dynamic> _loadJson(String key) async {
    final prefs = await _prefs;
    final str = prefs.getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str);
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------------------------------------
  // Prayer persistence
  // ------------------------------------------------------------------

  static Future<void> savePrayers(List<Map<String, dynamic>> prayers) async {
    await _saveJson(_prayersKey, prayers);
  }

  static Future<List<dynamic>?> loadPrayers() async {
    return await _loadJson(_prayersKey) as List<dynamic>?;
  }

  // ------------------------------------------------------------------
  // Plan/reading persistence
  // ------------------------------------------------------------------

  static Future<void> savePlanConfig(Map<String, dynamic> config) async {
    await _saveJson(_planConfigKey, config);
  }

  static Future<Map<String, dynamic>?> loadPlanConfig() async {
    return await _loadJson(_planConfigKey) as Map<String, dynamic>?;
  }

  static Future<void> saveReadings(List<Map<String, dynamic>> readings) async {
    await _saveJson(_readingsKey, readings);
  }

  static Future<List<dynamic>?> loadReadings() async {
    return await _loadJson(_readingsKey) as List<dynamic>?;
  }

  static Future<void> saveStreak(int streak) async {
    final prefs = await _prefs;
    await prefs.setInt(_streakKey, streak);
  }

  static Future<int?> loadStreak() async {
    final prefs = await _prefs;
    return prefs.getInt(_streakKey);
  }

  // ------------------------------------------------------------------
  // Reminder persistence
  // ------------------------------------------------------------------

  static const String _remindersKey = 'reminders';

  static Future<void> saveReminders(List<Map<String, dynamic>> reminders) async {
    await _saveJson(_remindersKey, reminders);
  }

  static Future<List<dynamic>?> loadReminders() async {
    return await _loadJson(_remindersKey) as List<dynamic>?;
  }
}
