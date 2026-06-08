import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/daily_verses.dart';
import '../utils/spacing.dart';
import '../widgets/daily_verse_card.dart';
import '../widgets/feature_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/status_bar_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.onGoToBiblePlan,
    this.onGoToPrayerLog,
    this.onGoToHabits,
  });

  final VoidCallback? onGoToBiblePlan;
  final VoidCallback? onGoToPrayerLog;
  final VoidCallback? onGoToHabits;

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 22) return 'Good Evening';
    return 'Good Night';
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return StatusBarStyle(
      child: GradientBackground.home(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: SafeArea(
            top: true,
            left: false,
            right: false,
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                16,
                Spacing.lg,
                Spacing.md,
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    const Text(
                      'Grace & Peace to you today',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xl),

                DailyVerseCard(
                  verse: DailyVerses.getTodayVerse().verse,
                  reference: DailyVerses.getTodayVerse().reference,
                  onBookmarkTap: () => Navigator.pushNamed(context, '/plan'),
                ),
                const SizedBox(height: Spacing.lg),

                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.08,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF2D2D44)
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Streak',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${app.currentStreak} Days Strong! 🔥',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                  child: Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.md),

                FeatureCard(
                  icon: Icons.auto_stories,
                  title: 'Bible Reading Plan',
                  description: 'Continue your daily reading',
                  gradientStart: AppColors.blueGradientStart,
                  gradientEnd: AppColors.blueGradientEnd,
                  onTap: onGoToBiblePlan ?? () => Navigator.pushNamed(context, '/plan'),
                ),
                const SizedBox(height: Spacing.md),

                FeatureCard(
                  icon: Icons.favorite,
                  title: 'Prayer List',
                  description: '${app.prayers.length} prayers waiting for you',
                  gradientStart: AppColors.pinkGradientStart,
                  gradientEnd: AppColors.pinkGradientEnd,
                  onTap: onGoToPrayerLog ?? () => Navigator.pushNamed(context, '/prayer log'),
                ),
                const SizedBox(height: Spacing.md),

                FeatureCard(
                  icon: Icons.trending_up,
                  title: 'Habit Tracker',
                  description: 'Track your spiritual habits',
                  gradientStart: AppColors.purpleGradientStart,
                  gradientEnd: AppColors.purpleGradientEnd,
                  onTap: onGoToHabits ?? () => Navigator.pushNamed(context, '/habits'),
                ),
                const SizedBox(height: Spacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
