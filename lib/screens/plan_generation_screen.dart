import 'package:flutter/material.dart';
import '../models/plan_models.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
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
  DateTime _targetEndDate = DateTime.now().add(const Duration(days: 90));
  String _readingStyle = 'mixed';
  String _selectedTimeFrame = '90';
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
        if (_targetEndDate.isBefore(_startDate)) {
          _targetEndDate = _startDate.add(const Duration(days: 90));
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetEndDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _targetEndDate = picked);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  int _computeTargetDays() {
    if (_planMode == 'continue') {
      // For continue mode, always calculate based on end date
      final days = _targetEndDate.difference(_startDate).inDays + 1;
      return days < 1 ? 1 : days;
    }
    return int.tryParse(_selectedTimeFrame) ?? 90;
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
    final timeFrameOptions = ['30', '60', '90', '180', '365'];
    final modeLabel = _planMode == 'continue'
        ? 'Continue from current reading'
        : 'Start a new plan from Genesis to Revelation';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Plan'),
        leading: BackButton(
            onPressed: widget.onBack ?? () => Navigator.maybePop(context)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GradientBackground(
            startColor: Colors.blue.withValues(alpha: 0.05),
            midColor: Colors.purple.withValues(alpha: 0.05),
            endColor: Colors.white,
            child: Container(),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + Spacing.lg,
              left: Spacing.lg,
              right: Spacing.lg,
              bottom: Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha: 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan Type',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Wrap(
                        spacing: Spacing.md,
                        children: [
                          ChoiceChip(
                            selected: _planMode == 'start',
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _planMode = 'start');
                              }
                            },
                            label: const Text('Start New Plan'),
                            selectedColor:
                                AppColors.primary.withValues(alpha: 0.8),
                          ),
                          ChoiceChip(
                            selected: _planMode == 'continue',
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _planMode = 'continue');
                              }
                            },
                            label: const Text('Continue From Current Reading'),
                            selectedColor:
                                AppColors.primary.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        modeLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                if (_planMode == 'start') ...[
                  GradientCard(
                    borderColor: AppColors.border.withValues(alpha: 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reading Duration',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.foreground,
                                  ),
                        ),
                        const SizedBox(height: Spacing.md),
                        Wrap(
                          spacing: Spacing.md,
                          runSpacing: Spacing.md,
                          children: timeFrameOptions.map((days) {
                            final isSelected = _selectedTimeFrame == days;
                            return FilterChip(
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedTimeFrame = days);
                                }
                              },
                              label: Text(
                                '${int.parse(days)} days',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.foreground,
                                ),
                              ),
                              selectedColor:
                                  AppColors.primary.withValues(alpha: 0.8),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  GradientCard(
                    borderColor: AppColors.border.withValues(alpha: 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reading Style',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.foreground,
                                  ),
                        ),
                        const SizedBox(height: Spacing.md),
                        Wrap(
                          spacing: Spacing.md,
                          children: [
                            ChoiceChip(
                              selected: _readingStyle == 'sequential',
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _readingStyle = 'sequential');
                                }
                              },
                              label: const Text('Sequential'),
                              selectedColor:
                                  AppColors.primary.withValues(alpha: 0.8),
                            ),
                            ChoiceChip(
                              selected: _readingStyle == 'mixed',
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _readingStyle = 'mixed');
                                }
                              },
                              label: const Text('Mixed (Old & New Testament)'),
                              selectedColor:
                                  AppColors.primary.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          _readingStyle == 'sequential'
                              ? 'Read chapters in order from Genesis to Revelation'
                              : 'Alternate between Old Testament and New Testament chapters',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                ],
                if (_planMode == 'continue') ...[
                  GradientCard(
                    borderColor: AppColors.border.withValues(alpha: 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Current Reading Position',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.foreground,
                                  ),
                        ),
                        const SizedBox(height: Spacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedLastBook,
                          items: _bibleBooks
                              .map((book) => DropdownMenuItem(
                                  value: book, child: Text(book)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedLastBook = value);
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            labelText: 'Last Read Book',
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _lastChapterCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.inputBackground,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none),
                                  labelText: 'Chapter',
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.md),
                            Expanded(
                              child: TextField(
                                controller: _lastVerseCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.inputBackground,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none),
                                  labelText: 'Verse (optional)',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  GradientCard(
                    borderColor: AppColors.border.withValues(alpha: 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Target Completion',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.foreground,
                                  ),
                        ),
                        const SizedBox(height: Spacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Complete by $endDateStr',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            FilledButton.tonal(
                              onPressed: _pickEndDate,
                              child: const Text('Choose Date'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                ],
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha: 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
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
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          FilledButton.tonal(
                            onPressed: _pickDate,
                            child: const Text('Change Date'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha: 0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Text(
                      _planMode == 'continue'
                          ? 'The generator will include unread chapters from $_selectedLastBook ${_lastChapterCtrl.text}${_lastVerseCtrl.text.isNotEmpty ? ':${_lastVerseCtrl.text}' : ''} and spread them across ${_computeTargetDays()} days to complete by $endDateStr.'
                          : 'Create a balanced full Bible plan from Genesis through Revelation in ${_computeTargetDays()} days.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                FilledButton(
                  onPressed: _generate,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: const Text(
                    'Generate Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                OutlinedButton(
                  onPressed: widget.onBack ?? () => Navigator.maybePop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
