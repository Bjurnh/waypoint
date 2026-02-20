import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

/// A special card for displaying the daily verse with gradient background,
/// decorative cross element, and bookmark icon. Matches React's DailyVerseCard design.
class DailyVerseCard extends StatelessWidget {
  /// The verse text to display
  final String verse;
  
  /// The book/reference of the verse
  final String? reference;
  
  /// Callback when bookmark icon is tapped
  final VoidCallback? onBookmarkTap;

  const DailyVerseCard({
    super.key,
    required this.verse,
    this.reference,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFDBEAFE), // blue-100
            Color(0xFFFCE7F3), // pink-100
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: Spacing.shadowMd,
      ),
      child: Stack(
        children: [
          // Decorative cross pattern (subtle)
          Positioned(
            top: -20,
            right: -20,
            child: Opacity(
              opacity: 0.05,
              child: Icon(
                Icons.add,
                size: 120,
                color: AppColors.primary,
              ),
            ),
          ),
          // Decorative cross (vertical)
          Positioned(
            top: 20,
            right: 40,
            child: Opacity(
              opacity: 0.05,
              child: Container(
                width: 3,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Decorative cross (horizontal)
          Positioned(
            top: 50,
            right: 20,
            child: Opacity(
              opacity: 0.05,
              child: Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with label and bookmark
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Daily Verse label
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(Spacing.radiusFull),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: Spacing.xs),
                          Text(
                            'Daily Verse',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bookmark icon button
                    GestureDetector(
                      onTap: onBookmarkTap,
                      child: Container(
                        padding: const EdgeInsets.all(Spacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bookmark_border,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                // Verse text
                Text(
                  verse,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (reference != null) ...[
                  const SizedBox(height: Spacing.md),
                  // Reference
                  Text(
                    reference!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
