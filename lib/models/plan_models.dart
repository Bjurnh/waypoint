/// Models that are used only during the ad‑hoc plan generation flow.
///
/// The mobile app makes use of its own Hive‑backed [PlanConfig] defined in
/// `models/plan_config.dart`. This file exists solely to mirror the shape of
/// a similar file in the React/TypeScript prototype and is currently only used
/// by the plan generation screen in a couple of places.

enum PlanMode { startNew, continueCurrent }

enum PlanTargetType { days, endDate }

class PlanConfig {
  int timeFrame;
  DateTime startDate;
  int dailyMinutes;
  String readingStyle;
  PlanMode mode;
  String? lastBook;
  int? lastChapter;
  int? lastVerse;
  PlanTargetType targetType;
  DateTime? targetEndDate;

  PlanConfig({
    required this.timeFrame,
    required this.startDate,
    required this.dailyMinutes,
    required this.readingStyle,
    this.mode = PlanMode.startNew,
    this.lastBook,
    this.lastChapter,
    this.lastVerse,
    this.targetType = PlanTargetType.days,
    this.targetEndDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'timeFrame': timeFrame,
      'startDate': startDate.toIso8601String(),
      'dailyMinutes': dailyMinutes,
      'readingStyle': readingStyle,
      'mode': mode.toString().split('.').last,
      'lastBook': lastBook,
      'lastChapter': lastChapter,
      'lastVerse': lastVerse,
      'targetType': targetType.toString().split('.').last,
      'targetEndDate': targetEndDate?.toIso8601String(),
    };
  }

  factory PlanConfig.fromJson(Map<String, dynamic> json) {
    PlanMode parseMode(String? value) {
      if (value == 'continueCurrent') return PlanMode.continueCurrent;
      return PlanMode.startNew;
    }

    PlanTargetType parseTargetType(String? value) {
      if (value == 'endDate') return PlanTargetType.endDate;
      return PlanTargetType.days;
    }

    return PlanConfig(
      timeFrame: json['timeFrame'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      dailyMinutes: json['dailyMinutes'] as int,
      readingStyle: json['readingStyle'] as String,
      mode: parseMode(json['mode'] as String?),
      lastBook: json['lastBook'] as String?,
      lastChapter: json['lastChapter'] as int?,
      lastVerse: json['lastVerse'] as int?,
      targetType: parseTargetType(json['targetType'] as String?),
      targetEndDate: json['targetEndDate'] != null
          ? DateTime.parse(json['targetEndDate'] as String)
          : null,
    );
  }
}

class BibleChapter {
  final String book;
  final int chapter;
  final int verses;

  BibleChapter({
    required this.book,
    required this.chapter,
    required this.verses,
  });

  String get label => '$book $chapter';

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'chapter': chapter,
      'verses': verses,
    };
  }
}
