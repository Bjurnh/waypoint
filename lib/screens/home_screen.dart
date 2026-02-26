import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/streak_badge.dart';
import '../widgets/daily_verse_card.dart';
import '../widgets/feature_card.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    
    return GradientBackground.home(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: Spacing.sm),
                      Text(
                        'Synced',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
          children: [
            // Good Morning Greeting
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: Spacing.xs),
                Text(
                  'Grace & Peace to you today',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // Daily Verse Card
            DailyVerseCard(
              verse: 'For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.',
              reference: 'Jeremiah 29:11',
              onBookmarkTap: () => Navigator.pushNamed(context, '/plan'),
            ),
            const SizedBox(height: Spacing.lg),

            // Current Streak Card
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                        const Text(
                          'Current Streak',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${app.currentStreak} Days Strong! 🔥',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // Quick Actions Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),

            // Quick Action Cards (Vertical Stack)
            FeatureCard(
              icon: Icons.auto_stories,
              title: 'Bible Reading Plan',
              description: 'Continue your daily reading',
              gradientStart: AppColors.blueGradientStart,
              gradientEnd: AppColors.blueGradientEnd,
              onTap: () => Navigator.pushNamed(context, '/bible-plan'),
            ),
            const SizedBox(height: Spacing.md),

            FeatureCard(
              icon: Icons.favorite,
              title: 'Prayer List',
              description: '${app.prayers.length} prayers waiting for you',
              gradientStart: AppColors.pinkGradientStart,
              gradientEnd: AppColors.pinkGradientEnd,
              onTap: () => Navigator.pushNamed(context, '/prayer-log'),
            ),
            const SizedBox(height: Spacing.md),

            FeatureCard(
              icon: Icons.trending_up,
              title: 'Habit Tracker',
              description: 'Track your spiritual habits',
              gradientStart: AppColors.purpleGradientStart,
              gradientEnd: AppColors.purpleGradientEnd,
              onTap: () => Navigator.pushNamed(context, '/habits'),
            ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }
}
