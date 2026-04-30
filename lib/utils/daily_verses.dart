/// Daily verses data for the home screen rotation
/// Each verse rotates based on the day of the year

class DailyVerse {
  final String verse;
  final String reference;

  const DailyVerse({
    required this.verse,
    required this.reference,
  });

  Map<String, String> toMap() => {
        'verse': verse,
        'reference': reference,
      };
}

class DailyVerses {
  static const List<DailyVerse> verses = [
    DailyVerse(
      verse:
          'For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.',
      reference: 'Jeremiah 29:11',
    ),
    DailyVerse(
      verse:
          'Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.',
      reference: 'Proverbs 3:5-6',
    ),
    DailyVerse(
      verse:
          'Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.',
      reference: 'Joshua 1:9',
    ),
    DailyVerse(
      verse:
          'The Lord is my shepherd, I lack nothing. He makes me lie down in green pastures, he leads me beside quiet waters.',
      reference: 'Psalm 23:1-2',
    ),
    DailyVerse(
      verse: 'I can do all things through Christ who strengthens me.',
      reference: 'Philippians 4:13',
    ),
    DailyVerse(
      verse:
          'Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled and do not be afraid.',
      reference: 'John 14:27',
    ),
    DailyVerse(
      verse:
          'And we know that in all things God works for the good of those who love him, who have been called according to his purpose.',
      reference: 'Romans 8:28',
    ),
    DailyVerse(
      verse:
          'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
      reference: 'John 3:16',
    ),
    DailyVerse(
      verse:
          'Come to me, all you who are weary and burdened, and I will give you rest.',
      reference: 'Matthew 11:28',
    ),
    DailyVerse(
      verse:
          'The Lord is close to the brokenhearted and saves those who are crushed in spirit.',
      reference: 'Psalm 34:18',
    ),
    DailyVerse(
      verse:
          'Let the peace of Christ rule in your hearts, since as members of one body you were called to peace. And be thankful.',
      reference: 'Colossians 3:15',
    ),
    DailyVerse(
      verse:
          'But seek first his kingdom and his righteousness, and all these things will be given to you as well.',
      reference: 'Matthew 6:33',
    ),
    DailyVerse(
      verse: 'Cast all your anxiety on him because he cares for you.',
      reference: '1 Peter 5:7',
    ),
    DailyVerse(
      verse:
          'The righteous person may have many troubles, but the Lord delivers him from them all.',
      reference: 'Psalm 34:19',
    ),
    DailyVerse(
      verse:
          'Therefore, if anyone is in Christ, the new creation has come: The old has gone, the new is here!',
      reference: '2 Corinthians 5:17',
    ),
  ];

  /// Get today's verse based on the day of the year
  static DailyVerse getTodayVerse() {
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final verseIndex = dayOfYear % verses.length;
    return verses[verseIndex];
  }

  /// Get verse for a specific date
  static DailyVerse getVerseForDate(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final verseIndex = dayOfYear % verses.length;
    return verses[verseIndex];
  }
}
