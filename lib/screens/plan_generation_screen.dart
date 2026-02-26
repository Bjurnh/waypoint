import 'package:flutter/material.dart';
import '../models/plan_models.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';

class PlanGenerationScreen extends StatefulWidget {
  final void Function(PlanConfig) onGenerate;
  final VoidCallback? onBack;

  const PlanGenerationScreen({required this.onGenerate, this.onBack, Key? key}) : super(key: key);

  @override
  _PlanGenerationScreenState createState() => _PlanGenerationScreenState();
}

class _PlanGenerationScreenState extends State<PlanGenerationScreen> {
  final _timeFrameCtrl = TextEditingController(text: '90');
  final _minutesCtrl = TextEditingController(text: '15');
  DateTime _startDate = DateTime.now();
  String _readingStyle = 'mixed';
  String _selectedTimeFrame = '90';

  @override
  void dispose() {
    _timeFrameCtrl.dispose();
    _minutesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  void _generate() {
    final config = PlanConfig(
      timeFrame: int.tryParse(_selectedTimeFrame) ?? 90,
      startDate: _startDate,
      dailyMinutes: int.tryParse(_minutesCtrl.text) ?? 15,
      readingStyle: _readingStyle,
    );
    widget.onGenerate(config);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _startDate.toLocal().toIso8601String().split('T')[0];
    final timeFrameOptions = ['30', '60', '90', '180', '365'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Plan'),
        leading: BackButton(onPressed: widget.onBack ?? () => Navigator.maybePop(context)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GradientBackground(
            child: Container(),
            startColor: Colors.blue.withValues(alpha: 0.05),
            midColor: Colors.purple.withValues(alpha: 0.05),
            endColor: Colors.white,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + Spacing.lg,
              left: Spacing.lg,
              right: Spacing.lg,
              bottom: Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Time Frame Selection
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha:0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Reading Duration',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: Spacing.md),
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
                                color: isSelected ? Colors.white : AppColors.foreground,
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: AppColors.primary.withValues(alpha:0.8),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border.withValues(alpha:0.4),
                              width: 1.5,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Reading Style Selection
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha:0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reading Style',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      Wrap(
                        spacing: Spacing.md,
                        runSpacing: Spacing.md,
                        children: [
                          FilterChip(
                            selected: _readingStyle == 'sequential',
                            onSelected: (selected) {
                              if (selected) setState(() => _readingStyle = 'sequential');
                            },
                            label: const Text(
                              'Sequential',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            selectedColor: AppColors.primary.withValues(alpha:0.8),
                            side: BorderSide(
                              color: _readingStyle == 'sequential'
                                  ? AppColors.primary
                                  : AppColors.border.withValues(alpha:0.4),
                              width: 1.5,
                            ),
                          ),
                          FilterChip(
                            selected: _readingStyle == 'mixed',
                            onSelected: (selected) {
                              if (selected) setState(() => _readingStyle = 'mixed');
                            },
                            label: const Text(
                              'Mixed',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            selectedColor: AppColors.primary.withValues(alpha:0.8),
                            side: BorderSide(
                              color: _readingStyle == 'mixed'
                                  ? AppColors.primary
                                  : AppColors.border.withValues(alpha:0.4),
                              width: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Start Date Selection
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha:0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foreground,
                                ),
                              ),
                              SizedBox(height: Spacing.xs),
                              Text(
                                dateStr,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
                SizedBox(height: Spacing.lg),

                // Daily Time Commitment
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha:0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Time Commitment',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      TextField(
                        controller: _minutesCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.schedule),
                          suffixText: 'minutes',
                          hintText: 'Enter minutes per day',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.md,
                          ),
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      Container(
                        padding: EdgeInsets.all(Spacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Plan Preview',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: Spacing.sm),
                            Text(
                              '📖 $_selectedTimeFrame-day plan starting $dateStr\n'
                              '${_readingStyle.toUpperCase()} reading style\n'
                              '⏱ ~${_minutesCtrl.text.isEmpty ? '15' : _minutesCtrl.text} minutes daily',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.foreground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.xl),

                // Generate Button
                FilledButton(
                  onPressed: _generate,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'Generate Plan',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: Spacing.md),
                OutlinedButton(
                  onPressed: widget.onBack ?? () => Navigator.maybePop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
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
