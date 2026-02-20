import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

/// Search filter bar with search input and horizontal scrollable filter pills.
/// Used in PrayerLogScreen and HabitTrackingScreen.
class SearchFilterBar extends StatelessWidget {
  /// Search text controller
  final TextEditingController? searchController;
  
  /// Callback when search text changes
  final ValueChanged<String>? onSearchChanged;
  
  /// Available filter options
  final List<String> filters;
  
  /// Currently selected filter
  final String selectedFilter;
  
  /// Callback when filter is selected
  final ValueChanged<String>? onFilterSelected;
  
  /// Search hint text
  final String searchHint;
  
  /// Whether to show the "Show Answered" toggle
  final bool showAnsweredToggle;
  
  /// Whether answered toggle is on
  final bool showAnswered;
  
  /// Callback when answered toggle changes
  final ValueChanged<bool>? onAnsweredToggleChanged;

  const SearchFilterBar({
    super.key,
    this.searchController,
    this.onSearchChanged,
    required this.filters,
    required this.selectedFilter,
    this.onFilterSelected,
    this.searchHint = 'Search...',
    this.showAnsweredToggle = false,
    this.showAnswered = false,
    this.onAnsweredToggleChanged,
  });

  /// Factory for Prayer Log screen filters
  factory SearchFilterBar.prayerLog({
    Key? key,
    TextEditingController? searchController,
    ValueChanged<String>? onSearchChanged,
    required String selectedFilter,
    ValueChanged<String>? onFilterSelected,
    bool showAnsweredToggle = false,
    bool showAnswered = false,
    ValueChanged<bool>? onAnsweredToggleChanged,
  }) {
    return SearchFilterBar(
      key: key,
      searchController: searchController,
      onSearchChanged: onSearchChanged,
      filters: const ['All', 'Personal', 'Family', 'Friends', 'World'],
      selectedFilter: selectedFilter,
      onFilterSelected: onFilterSelected,
      searchHint: 'Search prayers...',
      showAnsweredToggle: showAnsweredToggle,
      showAnswered: showAnswered,
      onAnsweredToggleChanged: onAnsweredToggleChanged,
    );
  }

  /// Factory for Habit Tracking screen filters
  factory SearchFilterBar.habit({
    Key? key,
    TextEditingController? searchController,
    ValueChanged<String>? onSearchChanged,
    required String selectedFilter,
    ValueChanged<String>? onFilterSelected,
  }) {
    return SearchFilterBar(
      key: key,
      searchController: searchController,
      onSearchChanged: onSearchChanged,
      filters: const ['All', 'Reading', 'Prayer', 'Meditation', 'Journaling'],
      selectedFilter: selectedFilter,
      onFilterSelected: onFilterSelected,
      searchHint: 'Search habits...',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Input
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(Spacing.radiusXl),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: const TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.lg,
                vertical: Spacing.md,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: Spacing.md),
        
        // Filter Pills - Horizontal Scroll
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: Spacing.sm),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = filter == selectedFilter;
              
              return FilterPill(
                label: filter,
                isSelected: isSelected,
                onTap: () => onFilterSelected?.call(filter),
              );
            },
          ),
        ),
        
        // Show Answered Toggle
        if (showAnsweredToggle) ...[
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              const Text(
                'Show Answered',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Switch(
                value: showAnswered,
                onChanged: onAnsweredToggleChanged,
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Individual filter pill widget
class FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterPill({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.blueGradientStart, AppColors.blueGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : AppColors.card,
          borderRadius: BorderRadius.circular(Spacing.radiusFull),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.blueGradientStart.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
