import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/progress_circle.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_appbar.dart';
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
    final progress = app.allReadings.isEmpty ? 0.0 : (app.allReadings.where((r) => r.completed).length / app.generatedPlanConfig.timeFrame);
    
    return GradientBackground.home(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ModernAppBar.home(
          title: 'Welcome back',
          subtitle: 'Continue your spiritual journey',
        ),
        body: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            // Daily Verse Card
            DailyVerseCard(
              verse: 'The Lord is my light and my salvation',
              reference: 'Psalm 27:1',
              onBookmarkTap: () => Navigator.pushNamed(context, '/plan'),
            ),
            const SizedBox(height: Spacing.lg),

            // Streak Badge
            Center(
              child: StreakBadge(
                days: app.currentStreak,
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // Quick Actions Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.md),
              child: Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Feature Cards Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: Spacing.md,
              mainAxisSpacing: Spacing.md,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FeatureCard(
                  icon: Icons.auto_stories,
                  title: 'Bible Plan',
                  description: 'Daily readings',
                  gradientStart: AppColors.blueGradientStart,
                  gradientEnd: AppColors.blueGradientEnd,
                  onTap: () => Navigator.pushNamed(context, '/bible-plan'),
                ),
                FeatureCard(
                  icon: Icons.favorite,
                  title: 'Add Prayer',
                  description: 'New prayer',
                  gradientStart: AppColors.pinkGradientStart,
                  gradientEnd: AppColors.pinkGradientEnd,
                  onTap: () => Navigator.pushNamed(context, '/add'),
                ),
                FeatureCard(
                  icon: Icons.trending_up,
                  title: 'Habits',
                  description: 'Track daily',
                  gradientStart: AppColors.purpleGradientStart,
                  gradientEnd: AppColors.purpleGradientEnd,
                  onTap: () => Navigator.pushNamed(context, '/habits'),
                ),
                FeatureCard(
                  icon: Icons.show_chart,
                  title: 'Progress',
                  description: 'Your stats',
                  gradientStart: AppColors.indigoGradientStart,
                  gradientEnd: AppColors.indigoGradientEnd,
                  onTap: () => Navigator.pushNamed(context, '/progress'),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),

            // Progress Circle
            const Text(
              'Reading Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Center(
              child: ProgressCircle(value: progress),
            ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/add'),
          backgroundColor: AppColors.pinkGradientStart,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          backgroundColor: AppColors.card,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.mutedForeground,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Prayers'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (i) {
            if (i == 1) Navigator.pushNamed(context, '/log');
            if (i == 2) Navigator.pushNamed(context, '/profile');
          },
        ),
      ),
    );
  }
}
