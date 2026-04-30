import 'package:hive_flutter/hive_flutter.dart';

import '../models/day_reading.dart';
import '../models/prayer_entry.dart';
import '../models/plan_config.dart';

/// Simple wrapper around Hive initialization and box access.
class HiveService {
  static const String readingsBoxName = 'readings';
  static const String prayersBoxName = 'prayers';
  static const String configBoxName = 'config';
  
  static bool _initialized = false;

  /// call once at app startup (safe to call multiple times)
  Future<void> init() async {
    if (_initialized) return;
    
    await Hive.initFlutter();
    Hive.registerAdapter(DayReadingAdapter());
    Hive.registerAdapter(PlanConfigAdapter());
    Hive.registerAdapter(PrayerEntryAdapter());

    await Hive.openBox<DayReading>(readingsBoxName);
    await Hive.openBox<PrayerEntry>(prayersBoxName);
    await Hive.openBox<PlanConfig>(configBoxName);
    
    _initialized = true;
  }

  Box<DayReading> get readingsBox => Hive.box<DayReading>(readingsBoxName);
  Box<PrayerEntry> get prayersBox => Hive.box<PrayerEntry>(prayersBoxName);
  Box<PlanConfig> get configBox => Hive.box<PlanConfig>(configBoxName);
}
