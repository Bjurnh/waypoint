import 'package:flutter/material.dart';
import '../models/plan_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';

class PlanGenerationScreen extends StatefulWidget {
  final void Function(PlanConfig) onGenerate;
  final VoidCallback? onBack;

  const PlanGenerationScreen({required this.onGenerate, this.onBack, Key? key})
      : super(key: key);

  @override
  State<PlanGenerationScreen> createState() => PlanGenerationScreenState();
}

class PlanGenerationScreenState extends State<PlanGenerationScreen> {
  final _minutesCtrl = TextEditingController(text: '15');
  final _lastChapterCtrl = TextEditingController(text: '1');
  final _lastVerseCtrl = TextEditingController();
  String _selectedLastBook = 'Genesis';
  DateTime _startDate = DateTime.now();
  // Plan should end at day-of-year = 365 (end-point), not “365 daily entries”.
  // We compute the actual number of generated readings based on the chosen start date.
  DateTime _targetEndDate = DateTime.now();

  String _readingStyle = 'bibleInYear';

  static const int _endDayOfYear = 365;

  /// Returns the actual calendar date that corresponds to “day 365” for the given year.
  /// If the year is a leap year and day 365 would fall after Dec 31-1, clamp to Dec 31.
  DateTime _dateForEndDayOfYear(int year) {
    final jan1 = DateTime(year, 1, 1);
    final candidate = jan1.add(Duration(days: _endDayOfYear - 1));
    // Clamp so we never go past Dec 31.
    return DateTime(year, 12, 31).isBefore(candidate)
        ? DateTime(year, 12, 31)
        : candidate;
  }

  DateTime _computeEndOfYear(DateTime start) {
    return _dateForEndDayOfYear(start.year);
  }


  void _syncContinueTargetEndDate() {
    _targetEndDate = _computeEndOfYear(_startDate);
  }

  @override
  void initState() {
    super.initState();
    // Default start date to now; compute target end for day-of-year 365.
    _syncContinueTargetEndDate();
  }


  String _selectedTimeFrame = '365';
  String _planMode = 'start';

  static const _bibleBooks = <String>[
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

  @override
  void dispose() {
    _minutesCtrl.dispose();
    _lastChapterCtrl.dispose();
    _lastVerseCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_planMode == 'continue') {
          _syncContinueTargetEndDate();
        }
      });
    }
  }


  // Continue mode always targets Dec 31; end-date picking is disabled.
  Future<void> _pickEndDate() async {
    if (_planMode != 'continue') return;
    _syncContinueTargetEndDate();
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  int _computeTargetDays() {
    // “365” means end-point day-of-year 365, so the number of generated reading entries
    // depends on the chosen start date.
    final days = _targetEndDate.difference(_startDate).inDays + 1;
    return days < 1 ? 1 : days;
  }


  void _generate() {
    if (_planMode == 'continue' && _lastChapterCtrl.text.trim().isEmpty) {
      _showError('Enter the last chapter you read.');
      return;
    }

    final lastChapter = int.tryParse(_lastChapterCtrl.text.trim());
    if (_planMode == 'continue' && (lastChapter == null || lastChapter < 1)) {
      _showError('Enter a valid last chapter.');
      return;
    }

    if (_planMode == 'continue' && _targetEndDate.isBefore(_startDate)) {
      _showError('End date must be on or after the start date.');
      return;
    }

    final config = PlanConfig(
      timeFrame: _computeTargetDays(),
      startDate: _startDate,
      dailyMinutes: int.tryParse(_minutesCtrl.text.trim()) ?? 15,
      readingStyle: _readingStyle,
      mode: _planMode == 'continue'
          ? PlanMode.continueCurrent
          : PlanMode.startNew,
      lastBook: _planMode == 'continue' ? _selectedLastBook : null,
      lastChapter: _planMode == 'continue' ? lastChapter : null,
      lastVerse: _planMode == 'continue'
          ? int.tryParse(_lastVerseCtrl.text.trim())
          : null,
      targetType: _planMode == 'continue'
          ? PlanTargetType.endDate
          : PlanTargetType.days,
      targetEndDate: _planMode == 'continue' ? _targetEndDate : null,
    );

    widget.onGenerate(config);
  }

  @override
  Widget build(BuildContext context) {
    final startDateStr = _startDate.toLocal().toIso8601String().split('T')[0];
    final endDateStr = _targetEndDate.toLocal().toIso8601String().split('T')[0];
    final timeFrameOptions = ['365'];

    final modeLabel = _planMode == 'continue'
        ? 'Continue from current reading'
        : 'Start a new plan from Genesis to Revelation';

    AppColors.blueGradientStart.withAlpha(220);
    final chipLabelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(fontWeight: FontWeight.w600);

    InputDecoration inputDecoration(String label) {
      return AppTheme.inputDecoration(
        labelText: label,
        fillColor: AppColors.inputBackground,
        borderColor: AppColors.border.withAlpha((0.25 * 255).round()),
      );
    }

    Widget optionChip({
      required String label,
      required bool selected,
      required void Function(bool) onSelected,
      bool isFilter = false,
    }) {
      final borderRadius = BorderRadius.circular(24);
      final horizontal = isFilter ? 16.0 : 16.0;

      return InkWell(
        borderRadius: borderRadius,
        onTap: () => onSelected(true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: horizontal,
            vertical: isFilter ? 12 : 12,
          ),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: selected ? null : AppColors.inputBackground,
            gradient: selected
                ? const LinearGradient(
                    colors: [
                      AppColors.blueGradientStart,
                      AppColors.blueGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : AppColors.border.withAlpha((0.25 * 255).round()),
              width: selected ? 0 : 1.5,
            ),
          ),
          child: Text(
            label,
            style: chipLabelStyle?.copyWith(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      );
    }


    return GradientBackground.home(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Generate Plan'),
          leading: BackButton(onPressed: () => widget.onBack ?? Navigator.maybePop(context)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Build your Bible plan',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.foreground,
                      ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  'Choose a gentle pace, set your start date, and let the app create a balanced reading plan for you.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: Spacing.xl),
                GradientCard.home(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan Type',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.foreground,
                            ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Wrap(
                        spacing: Spacing.md,
                        runSpacing: Spacing.sm,
                        children: [
                          optionChip(
                            label: 'Start New Plan',
                            selected: _planMode == 'start',
onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _planMode = 'start';
                                  _readingStyle = 'bibleInYear';
                                });
                              }
                            },
                          ),
                          optionChip(
                            label: 'Continue From Current Reading',
                            selected: _planMode == 'continue',
onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _planMode = 'continue';
                                  _readingStyle = 'sequential';
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        modeLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _planMode == 'start'
                      ? Column(
                          key: const ValueKey('startMode'),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GradientCard.home(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reading Duration',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.foreground,
                                        ),
                                  ),
                                  const SizedBox(height: Spacing.md),
                      Wrap(
                        spacing: Spacing.md,
                        runSpacing: Spacing.md,
                        children: timeFrameOptions.map((days) {
                                      final isSelected = _selectedTimeFrame == days;
                                      // UI option label refers to end-point day-of-year.
                                      return optionChip(
                                        label: 'Ends on day ${int.parse(days)}',
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          if (selected) {
                                            setState(() => _selectedTimeFrame = days);
                                          }
                                        },

                                        isFilter: true,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            GradientCard.home(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reading Style',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.foreground,
                                        ),
                                  ),
                                  const SizedBox(height: Spacing.md),
                                  Wrap(
                                    spacing: Spacing.md,
                                    runSpacing: Spacing.sm,
                                    children: [
                                      optionChip(
                                        label: 'Sequential',
                                        selected: _readingStyle == 'sequential',
                                        onSelected: (selected) {
                                          if (selected) {
                                            setState(() => _readingStyle = 'sequential');
                                          }
                                        },
                                      ),
optionChip(
                                        label: 'Bible in a Year (OT + NT)',
                                        selected: _readingStyle == 'bibleInYear',
                                        onSelected: (selected) {
                                          if (selected) {
                                            setState(() => _readingStyle = 'bibleInYear');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Spacing.sm),
                                  Text(
                                    _readingStyle == 'sequential'
                                        ? 'Read chapters in order from Genesis to Revelation'
                                        : 'A balanced 365-day plan pairing Old Testament passages with New Testament verse ranges',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          key: const ValueKey('continueMode'),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GradientCard.home(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Current Reading Position',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.foreground,
                                        ),
                                  ),
                                  const SizedBox(height: Spacing.md),
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedLastBook,
                                    items: _bibleBooks
                                        .map((book) => DropdownMenuItem(
                                              value: book,
                                              child: Text(book),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => _selectedLastBook = value);
                                      }
                                    },
                                    decoration: inputDecoration('Last Read Book'),
                                  ),
                                  const SizedBox(height: Spacing.md),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _lastChapterCtrl,
                                          keyboardType: TextInputType.number,
                                          decoration: inputDecoration('Chapter'),
                                        ),
                                      ),
                                      const SizedBox(width: Spacing.md),
                                      Expanded(
                                        child: TextField(
                                          controller: _lastVerseCtrl,
                                          keyboardType: TextInputType.number,
                                          decoration: inputDecoration('Verse (optional)'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            GradientCard.home(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reading Style',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.foreground,
                                        ),
                                  ),
                                  const SizedBox(height: Spacing.md),
                                  Wrap(
                                    spacing: Spacing.md,
                                    runSpacing: Spacing.sm,
                                    children: [
                                      optionChip(
                                        label: 'Sequential',
                                        selected: _readingStyle == 'sequential',
                                        onSelected: (selected) {
                                          if (selected) {
                                            setState(() => _readingStyle = 'sequential');
                                          }
                                        },
                                      ),
                                      optionChip(
                                        label: 'Bible in a Year (OT + NT)',
                                        selected: _readingStyle == 'mixed',
                                        onSelected: (selected) {
                                          if (selected) {
                                            setState(() => _readingStyle = 'mixed');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Spacing.sm),
                                  Text(
                                    _readingStyle == 'sequential'
                                        ? 'Read chapters in order from where you left'
                                        : 'A balanced plan pairing Old Testament passages with New Testament verse ranges',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: Spacing.lg),
                                  Text(
                                    'Target Completion',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.foreground,
                                        ),
                                  ),
                                  const SizedBox(height: Spacing.md),
                                  Text(
                                    'Complete by Dec 31 ($endDateStr)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                ),
                const SizedBox(height: Spacing.lg),
                GradientCard.home(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.foreground,
                            ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            startDateStr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          FilledButton.tonal(
                            onPressed: _pickDate,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.card,
                              foregroundColor: AppColors.primary,
                              minimumSize: const Size(140, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text('Change Date'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                GradientCard(
                  backgroundColor: AppColors.secondary,
                  borderColor: AppColors.border.withAlpha((0.2 * 255).round()),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Text(
                      _planMode == 'continue'
                          ? 'The generator will include unread chapters from $_selectedLastBook ${_lastChapterCtrl.text}${_lastVerseCtrl.text.isNotEmpty ? ':${_lastVerseCtrl.text}' : ''} and spread them across ${_computeTargetDays()} days to complete by $endDateStr.'
                          : 'Create a balanced full Bible plan from Genesis through Revelation in ${_computeTargetDays()} days.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                FilledButton(
                  onPressed: _generate,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.blueGradientStart,
                    foregroundColor: AppColors.textPrimary,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: const Text(
                    'Generate Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                OutlinedButton(
                  onPressed: widget.onBack ?? () => Navigator.maybePop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.border.withAlpha((0.2 * 255).round())),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
