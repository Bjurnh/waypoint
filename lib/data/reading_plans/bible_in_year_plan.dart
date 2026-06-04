import '../../models/day_reading.dart';
import '../../models/plan_models.dart' as plan_models;

List<DayReading> createBibleInYearPlan({DateTime? startDate}) {
  final start = startDate ?? DateTime.now();
  final allChapters = _buildBibleChapters();

  final otChapters = allChapters.where(_isOldTestament).toList();
  final ntChapters = allChapters.where(_isNewTestament).toList();

  final otTotal = otChapters.fold<int>(0, (sum, item) => sum + item.verses);
  final ntTotal = ntChapters.fold<int>(0, (sum, item) => sum + item.verses);
  final otTarget = (otTotal / 365).round().clamp(40, 90);
  final ntTarget = (ntTotal / 365).round().clamp(15, 30);

  final otDays = _normalizeChapterDays(_buildChapterDays(otChapters, otTarget), 365);
  final ntDays = _normalizeVerseDays(_buildNtDays(ntChapters, ntTarget), 365);

  final plan = <DayReading>[];
  for (var dayIndex = 0; dayIndex < 365; dayIndex++) {
    final date = start.add(Duration(days: dayIndex));
    final oldReading = _formatOtLabel(otDays[dayIndex].chapters);
    final newReading = _formatNtLabel(ntDays[dayIndex].ranges);
    plan.add(DayReading(
      id: 'reading_$dayIndex',
      date: DateTime(date.year, date.month, date.day),
      chapters: [oldReading, newReading],
    ));
  }

  return plan;
}

bool _isOldTestament(plan_models.BibleChapter chapter) {
  const oldTestamentBooks = [
    'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy',
    'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
    '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles',
    'Ezra', 'Nehemiah', 'Esther', 'Job', 'Psalms',
    'Proverbs', 'Ecclesiastes', 'Song of Solomon', 'Isaiah',
    'Jeremiah', 'Lamentations', 'Ezekiel', 'Daniel', 'Hosea',
    'Joel', 'Amos', 'Obadiah', 'Jonah', 'Micah',
    'Nahum', 'Habakkuk', 'Zephaniah', 'Haggai', 'Zechariah',
    'Malachi',
  ];
  return oldTestamentBooks.contains(chapter.book);
}

bool _isNewTestament(plan_models.BibleChapter chapter) {
  const newTestamentBooks = [
    'Matthew', 'Mark', 'Luke', 'John', 'Acts',
    'Romans', '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians',
    'Philippians', 'Colossians', '1 Thessalonians', '2 Thessalonians',
    '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews',
    'James', '1 Peter', '2 Peter', '1 John', '2 John', '3 John',
    'Jude', 'Revelation',
  ];
  return newTestamentBooks.contains(chapter.book);
}

List<_ChapterDay> _buildChapterDays(
  List<plan_models.BibleChapter> chapters,
  int targetVerses,
) {
  final days = <_ChapterDay>[];
  var currentWeight = 0;
  var currentChunk = <plan_models.BibleChapter>[];

  for (final chapter in chapters) {
    final nextWeight = currentWeight + chapter.verses;
    final shouldFlush = currentChunk.isNotEmpty &&
        (currentWeight >= targetVerses || nextWeight > targetVerses * 1.4);

    if (shouldFlush) {
      days.add(_ChapterDay(chapters: currentChunk, weight: currentWeight));
      currentChunk = [];
      currentWeight = 0;
    }

    currentChunk.add(chapter);
    currentWeight += chapter.verses;
  }

  if (currentChunk.isNotEmpty) {
    days.add(_ChapterDay(chapters: currentChunk, weight: currentWeight));
  }

  return days;
}

List<_VerseDay> _buildNtDays(
  List<plan_models.BibleChapter> chapters,
  int targetVerses,
) {
  final days = <_VerseDay>[];
  var currentWeight = 0;
  var currentRanges = <_VerseRange>[];

  for (final chapter in chapters) {
    var verseStart = 1;
    final totalVerses = chapter.verses;

    while (verseStart <= totalVerses) {
      final remaining = totalVerses - verseStart + 1;
      final need = targetVerses - currentWeight;
      final take = remaining < need || currentWeight == 0
          ? min(remaining, targetVerses)
          : min(remaining, need);

      final verseRange = _VerseRange(
        book: chapter.book,
        chapter: chapter.chapter,
        startVerse: verseStart,
        endVerse: verseStart + take - 1,
        chapterTotalVerses: totalVerses,
        weight: take,
      );
      currentRanges.add(verseRange);
      currentWeight += take;
      verseStart += take;

      if (currentWeight >= targetVerses) {
        days.add(_VerseDay(ranges: currentRanges, weight: currentWeight));
        currentRanges = [];
        currentWeight = 0;
      }
    }
  }

  if (currentRanges.isNotEmpty) {
    days.add(_VerseDay(ranges: currentRanges, weight: currentWeight));
  }

  return days;
}

List<_ChapterDay> _normalizeChapterDays(
  List<_ChapterDay> days,
  int targetCount,
) {
  if (days.length > targetCount) {
    while (days.length > targetCount) {
      days = _mergeSmallestAdjacentChapterDays(days);
    }
  } else if (days.length < targetCount) {
    while (days.length < targetCount) {
      final splitIndex = _findLargestSplittableChapterDay(days);
      if (splitIndex == -1) break;
      days = _splitChapterDay(days, splitIndex);
    }
  }
  return days;
}

List<_VerseDay> _normalizeVerseDays(
  List<_VerseDay> days,
  int targetCount,
) {
  if (days.length > targetCount) {
    while (days.length > targetCount) {
      days = _mergeSmallestAdjacentVerseDays(days);
    }
  } else if (days.length < targetCount) {
    while (days.length < targetCount) {
      final splitIndex = _findLargestSplittableVerseDay(days);
      if (splitIndex == -1) break;
      days = _splitVerseDay(days, splitIndex);
    }
  }
  return days;
}

List<_ChapterDay> _mergeSmallestAdjacentChapterDays(List<_ChapterDay> days) {
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
    chapters: [...days[mergeIndex].chapters, ...days[mergeIndex + 1].chapters],
    weight: days[mergeIndex].weight + days[mergeIndex + 1].weight,
  );

  return [
    ...days.sublist(0, mergeIndex),
    merged,
    ...days.sublist(mergeIndex + 2),
  ];
}

List<_VerseDay> _mergeSmallestAdjacentVerseDays(List<_VerseDay> days) {
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

  final mergedRanges = [...days[mergeIndex].ranges, ...days[mergeIndex + 1].ranges];
  return [
    ...days.sublist(0, mergeIndex),
    _VerseDay(ranges: mergedRanges, weight: days[mergeIndex].weight + days[mergeIndex + 1].weight),
    ...days.sublist(mergeIndex + 2),
  ];
}

List<_ChapterDay> _splitChapterDay(List<_ChapterDay> days, int splitIndex) {
  final dayToSplit = days[splitIndex];
  if (dayToSplit.chapters.length <= 1) return days;

  final splitAt = dayToSplit.chapters.length ~/ 2;
  final first = dayToSplit.chapters.sublist(0, splitAt);
  final second = dayToSplit.chapters.sublist(splitAt);

  return [
    ...days.sublist(0, splitIndex),
    _ChapterDay(chapters: first, weight: first.fold<int>(0, (sum, item) => sum + item.verses)),
    _ChapterDay(chapters: second, weight: second.fold<int>(0, (sum, item) => sum + item.verses)),
    ...days.sublist(splitIndex + 1),
  ];
}

List<_VerseDay> _splitVerseDay(List<_VerseDay> days, int splitIndex) {
  final dayToSplit = days[splitIndex];
  if (dayToSplit.ranges.length <= 1) {
    return days;
  }

  final splitAt = dayToSplit.ranges.length ~/ 2;
  final first = dayToSplit.ranges.sublist(0, splitAt);
  final second = dayToSplit.ranges.sublist(splitAt);

  return [
    ...days.sublist(0, splitIndex),
    _VerseDay(ranges: first, weight: first.fold<int>(0, (sum, item) => sum + item.weight)),
    _VerseDay(ranges: second, weight: second.fold<int>(0, (sum, item) => sum + item.weight)),
    ...days.sublist(splitIndex + 1),
  ];
}

int _findLargestSplittableChapterDay(List<_ChapterDay> days) {
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

int _findLargestSplittableVerseDay(List<_VerseDay> days) {
  var bestIndex = -1;
  var bestWeight = -1;
  for (var i = 0; i < days.length; i++) {
    final day = days[i];
    if (day.ranges.length <= 1) continue;
    if (day.weight > bestWeight) {
      bestWeight = day.weight;
      bestIndex = i;
    }
  }
  return bestIndex;
}

String _formatOtLabel(List<plan_models.BibleChapter> chapters) {
  if (chapters.isEmpty) return '';
  final first = chapters.first;
  final last = chapters.last;
  if (first.book == last.book) {
    return first.chapter == last.chapter
        ? '${first.book} ${first.chapter}'
        : '${first.book} ${first.chapter}-${last.chapter}';
  }
  return '${first.book} ${first.chapter} - ${last.book} ${last.chapter}';
}

String _formatNtLabel(List<_VerseRange> ranges) {
  if (ranges.isEmpty) return '';
  final labels = ranges.map((range) {
    if (range.startVerse == 1 && range.endVerse == range.chapterTotalVerses) {
      return '${range.book} ${range.chapter}:${range.startVerse}-${range.endVerse}';
    }
    return '${range.book} ${range.chapter}:${range.startVerse}-${range.endVerse}';
  }).toList();
  return labels.join('; ');
}

List<plan_models.BibleChapter> _buildBibleChapters() {
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
      final verses = _estimateChapterVerseCount(entry.key, chapter);
      chapters.add(plan_models.BibleChapter(
        book: entry.key,
        chapter: chapter,
        verses: verses,
      ));
    }
  }
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

int min(int a, int b) => a < b ? a : b;

class _ChapterDay {
  final List<plan_models.BibleChapter> chapters;
  final int weight;

  _ChapterDay({required this.chapters, required this.weight});
}

class _VerseRange {
  final String book;
  final int chapter;
  final int startVerse;
  final int endVerse;
  final int chapterTotalVerses;
  final int weight;

  _VerseRange({
    required this.book,
    required this.chapter,
    required this.startVerse,
    required this.endVerse,
    required this.chapterTotalVerses,
    required this.weight,
  });
}

class _VerseDay {
  final List<_VerseRange> ranges;
  final int weight;

  _VerseDay({required this.ranges, required this.weight});
}
