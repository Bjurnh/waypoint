import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_appbar.dart';
import '../widgets/search_filter_bar.dart';
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
        body: Column(
          children: [
            // Search and Filter Bar
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: SearchFilterBar(
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                onFilterSelected: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                filters: const ['all', 'personal', 'family', 'friends', 'world'],
                selectedFilter: _selectedFilter,
              ),
            ),

            // Show Answered Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: GradientCard(
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
                      onChanged: (value) {
                        setState(() {
                          _showAnswered = value;
                        });
                      },
                      activeColor: AppColors.pinkGradientStart,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),

            // Prayer List
            Expanded(
              child: filteredPrayers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 48,
                            color: AppColors.mutedForeground.withOpacity(0.5),
                          ),
                          const SizedBox(height: Spacing.md),
                          Text(
                            'No prayers found',
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  AppColors.mutedForeground.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.sm,
                      ),
                      itemCount: filteredPrayers.length,
                      itemBuilder: (c, i) {
                        final p = filteredPrayers[i];
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          const SizedBox(height: 8),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: p.isAnswered
                                            ? AppColors.indigoGradientStart
                                                .withOpacity(0.2)
                                            : AppColors.pinkGradientStart
                                                .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        p.isAnswered ? 'Answered' : 'Active',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: p.isAnswered
                                              ? AppColors.indigoGradientStart
                                              : AppColors.pinkGradientStart,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .slideX(
                              begin: -0.1,
                              duration: 400.ms,
                              curve: Curves.easeOut,
                            )
                            .fadeIn(
                              duration: 400.ms,
                              curve: Curves.easeOut,
                            ),
                        );
                      },
                    ),
            ),
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
