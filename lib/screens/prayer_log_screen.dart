import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_appbar.dart';
import '../widgets/gradient_card.dart';
import '../models/prayer_entry.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

typedef PrayerTapCallback = void Function(PrayerEntry prayer);
typedef PrayerToggleCallback = void Function(String id);

class PrayerLogScreen extends StatefulWidget {
  final List<PrayerEntry>? prayers;
  final VoidCallback? onAddPrayer;
  final PrayerTapCallback? onViewPrayer;
  final PrayerToggleCallback? onToggleAnswered;

  const PrayerLogScreen({
    super.key,
    this.prayers,
    this.onAddPrayer,
    this.onViewPrayer,
    this.onToggleAnswered,
  });

  @override
  State<PrayerLogScreen> createState() => _PrayerLogScreenState();
}

class _PrayerLogScreenState extends State<PrayerLogScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all';
  bool _showAnswered = false;

  @override
  Widget build(BuildContext context) {
    final list = widget.prayers ?? Provider.of<AppState>(context).prayers;

    // Filter prayers based on selection
    List<PrayerEntry> filteredPrayers = list;
    
    if (_selectedFilter != 'all') {
      filteredPrayers = filteredPrayers
          .where((p) => p.category.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredPrayers = filteredPrayers
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (p.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
          .toList();
    }

    if (_showAnswered) {
      filteredPrayers = filteredPrayers.where((p) => p.isAnswered).toList();
    }

    return GradientBackground.prayer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ModernAppBar.prayer(
          title: 'Prayer Log',
          subtitle: '${filteredPrayers.length} prayers',
        ),
        body: ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            GradientCard(
              child: TextField(
                onChanged: (q) => setState(() { _searchQuery = q; }),
                decoration: InputDecoration(
                  hintText: 'Search prayers',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['all', 'personal', 'family', 'friends', 'world']
                    .map((filter) {
                  final selected = _selectedFilter == filter;
                  final label = filter[0].toUpperCase() + filter.substring(1);
                  return Padding(
                    padding: const EdgeInsets.only(right: Spacing.sm),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (v) {
                        if (v) setState(() => _selectedFilter = filter);
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.8),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: Spacing.md),
            GradientCard(
              flat: true,
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Show Answered Only',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Switch(
                    value: _showAnswered,
                    onChanged: (v) { setState(() { _showAnswered = v; }); },
                    activeThumbColor: AppColors.pinkGradientStart,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.lg),
            if (filteredPrayers.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 48,
                      color: AppColors.mutedForeground.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      'No prayers found',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.mutedForeground.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              )
            else ...filteredPrayers.map((p) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.md),
                child: GradientCard(
                  onTap: () {
                    if (widget.onViewPrayer != null) {
                      widget.onViewPrayer!(p);
                    } else {
                      Provider.of<AppState>(context, listen: false)
                          .viewPrayer(p.id);
                      Navigator.pushNamed(context, '/detail');
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          p.isAnswered ? Icons.check_circle : Icons.circle_outlined,
                          color: p.isAnswered
                              ? AppColors.greenGradientStart
                              : AppColors.mutedForeground,
                        ),
                        onPressed: () {
                          widget.onToggleAnswered?.call(p.id);
                          Provider.of<AppState>(context, listen: false)
                              .togglePrayerAnswered(p.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: widget.onAddPrayer ?? () => Navigator.pushNamed(context, '/add'),
          backgroundColor: AppColors.pinkGradientStart,
          child: const Icon(Icons.add),
        )
          .animate()
          .scale(
            duration: 500.ms,
            curve: Curves.elasticOut,
          ),
      ),
    );
  }
}
