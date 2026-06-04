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
          'For I know the thoughts that I think toward you, saith the Lord, thoughts of peace, and not of evil, to give you an expected end.',
      reference: 'Jeremiah 29:11',
    ),
    DailyVerse(
      verse:
          'Trust in the LORD with all thine heart; and lean not unto thine own understanding; In all thy ways acknowledge him, and he shall direct thy paths.',
      reference: 'Proverbs 3:5-6',
    ),
    DailyVerse(
      verse:
          'Have not I commanded thee? Be strong and of a good courage; be not afraid, neither be thou dismayed: for the Lord thy God is with thee whithersoever thou goest.',
      reference: 'Joshua 1:9',
    ),
    DailyVerse(
      verse:
          'The LORD is my shepherd; I shall not want. He maketh me to lie down in green pastures: he leadeth me beside the still waters.',
      reference: 'Psalm 23:1-2',
    ),
    DailyVerse(
      verse: 'I can do all things through Christ which strengtheneth me.',
      reference: 'Philippians 4:13',
    ),
    DailyVerse(
      verse:
          'Peace I leave with you, my peace I give unto you: not as the world giveth, give I unto you. Let not your heart be troubled, neither let it be afraid.',
      reference: 'John 14:27',
    ),
    DailyVerse(
      verse:
          '"And we know that all things work together for good to them that love God, to them who are the called according to his purpose.',
      reference: 'Romans 8:28',
    ),
    DailyVerse(
      verse:
          '"For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.',
      reference: 'John 3:16',
    ),
    DailyVerse(
      verse:
          'Come unto me, all ye that labour and are heavy laden, and I will give you rest.',
      reference: 'Matthew 11:28',
    ),
    DailyVerse(
      verse:
          '"The LORD is nigh unto them that are of a broken heart; and saveth such as be of a contrite spirit.',
      reference: 'Psalm 34:18',
    ),
    DailyVerse(
      verse:
          'And let the peace of God rule in your hearts, to the which also ye are called in one body; and be ye thankful.',
      reference: 'Colossians 3:15',
    ),
    DailyVerse(
      verse:
          'But seek ye first the kingdom of God, and his righteousness; and all these things shall be added unto you.',
      reference: 'Matthew 6:33',
    ),
    DailyVerse(
      verse: 'Casting all your care upon him; for he careth for you.',
      reference: '1 Peter 5:7',
    ),
    DailyVerse(
      verse:
          'Many are the afflictions of the righteous: but the LORD delivereth him out of them all.',
      reference: 'Psalm 34:19',
    ),
    DailyVerse(
      verse:
          'Therefore if any man be in Christ, he is a new creature: old things are passed away; behold, all things are become new.',
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
