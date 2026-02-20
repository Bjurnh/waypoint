import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';

class AddPrayerScreen extends StatefulWidget {
  @override
  _AddPrayerScreenState createState() => _AddPrayerScreenState();
}

class _AddPrayerScreenState extends State<AddPrayerScreen> {
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String _selectedCategory = 'Personal';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Personal',
    'Family',
    'Friends',
    'Work',
    'World',
  ];

  final Map<String, IconData> _categoryIcons = {
    'Personal': Icons.person_rounded,
    'Family': Icons.family_restroom_rounded,
    'Friends': Icons.people_rounded,
    'Work': Icons.work_rounded,
    'World': Icons.public_rounded,
  };

  final Map<String, Color> _categoryColors = {
    'Personal': Colors.pink,
    'Family': Colors.purple,
    'Friends': Colors.blue,
    'Work': Colors.amber,
    'World': Colors.teal,
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final description = _descriptionCtrl.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prayer title')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    Provider.of<AppState>(context, listen: false).addPrayer(
      title: title,
      description: description,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ Prayer added successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    _titleCtrl.clear();
    _descriptionCtrl.clear();
    setState(() => _isSubmitting = false);

    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      if (mounted) Navigator.maybePop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColors[_selectedCategory] ?? AppColors.primary;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Prayer'),
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
      ),
      body: Stack(
        children: [
          GradientBackground(
            child: Container(),
            startColor: Colors.pink.withOpacity(0.05),
            midColor: Colors.purple.withOpacity(0.05),
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
                // Prayer Title
                GradientCard(
                  borderColor: AppColors.border.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prayer Title',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      TextField(
                        controller: _titleCtrl,
                        decoration: InputDecoration(
                          hintText: 'What do you want to pray for?',
                          prefixIcon: Icon(
                            Icons.favorite_rounded,
                            color: categoryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.md,
                          ),
                          filled: true,
                          fillColor: AppColors.inputBackground,
                        ),
                        maxLines: 2,
                        enabled: !_isSubmitting,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Category Selection
                GradientCard(
                  borderColor: AppColors.border.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      Wrap(
                        spacing: Spacing.md,
                        runSpacing: Spacing.md,
                        children: _categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          final color = _categoryColors[category] ?? AppColors.primary;
                          final icon = _categoryIcons[category] ?? Icons.folder_rounded;

                          return FilterChip(
                            selected: isSelected,
                            onSelected: _isSubmitting ? null : (selected) {
                              if (selected) {
                                setState(() => _selectedCategory = category);
                              }
                            },
                            avatar: Icon(
                              icon,
                              size: 16,
                              color: isSelected ? Colors.white : color,
                            ),
                            label: Text(
                              category,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.foreground,
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: color.withOpacity(0.8),
                            side: BorderSide(
                              color: isSelected
                                  ? color
                                  : AppColors.border.withOpacity(0.4),
                              width: 1.5,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Prayer Description/Details
                GradientCard(
                  borderColor: AppColors.border.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details (Optional)',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      TextField(
                        controller: _descriptionCtrl,
                        decoration: InputDecoration(
                          hintText: 'Add more details or specific requests...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.md,
                          ),
                          filled: true,
                          fillColor: AppColors.inputBackground,
                        ),
                        maxLines: 4,
                        enabled: !_isSubmitting,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.xl),

                // Submit Button
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
                    backgroundColor: categoryColor,
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Save Prayer',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                SizedBox(height: Spacing.md),
                OutlinedButton(
                  onPressed: _isSubmitting ? null : () => Navigator.maybePop(context),
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
