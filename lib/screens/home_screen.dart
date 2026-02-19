import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/prayer_entry_card.dart';
import '../widgets/progress_circle.dart';
import '../widgets/gradient_background.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final progress = app.allReadings.isEmpty ? 0.0 : (app.allReadings.where((r) => r.completed).length / app.generatedPlanConfig.timeFrame);
    
    return GradientBackground.home(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Waypoint',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.blueGradientStart, AppColors.purpleGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProgressCircle(value: progress),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: app.prayers.length,
                  itemBuilder: (context, idx) {
                    final p = app.prayers[idx];
                    return PrayerEntryCard(
                      title: p.title,
                      subtitle: p.isAnswered ? 'Answered' : 'Pending',
                      onTap: () => Navigator.pushNamed(context, '/log'),
                    );
                  },
                ),
              ),
            ],
          ),
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
