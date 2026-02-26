import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/bible_plan_screen.dart';
import '../screens/habit_tracking_screen.dart';
import '../screens/prayer_log_screen.dart';
import '../screens/progress_dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../theme/app_colors.dart';

class BottomNavigationShell extends StatefulWidget {
  const BottomNavigationShell({Key? key}) : super(key: key);

  @override
  State<BottomNavigationShell> createState() => _BottomNavigationShellState();
}

class _BottomNavigationShellState extends State<BottomNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    BiblePlanScreen(),
    HabitTrackingScreen(),
    PrayerLogScreen(),
    ProgressDashboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.blueGradientStart,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Bible'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Prayer'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
