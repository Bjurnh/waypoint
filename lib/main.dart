import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_prayer_screen.dart';
import 'screens/prayer_log_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/generated_plan_screen.dart';
import 'screens/bible_plan_screen.dart';
import 'screens/plan_generation_screen.dart';
import 'screens/progress_dashboard_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/habit_tracking_screen.dart';
import 'state/app_state.dart';
import 'screens/prayer_detail_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_navigation_shell.dart';
import 'services/notification_service.dart';
import 'widgets/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notifications in background (don't await - start it but don't block)
  NotificationService.initialize();

  runApp(ChangeNotifierProvider(create: (_) => AppState(), child: const WaypointApp()));
}

class WaypointApp extends StatefulWidget {
  const WaypointApp({super.key});

  @override
  State<WaypointApp> createState() => _WaypointAppState();
}

class _WaypointAppState extends State<WaypointApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize storage and app state in background
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.initialize();
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        title: 'Waypoint',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: SplashScreen(
          onInitialized: _initializeApp,
        ),
      );
    }

    return MaterialApp(
      title: 'Waypoint',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const BottomNavigationShell(),
      routes: {
        '/add': (context) => AddPrayerScreen(),
        '/log': (context) => PrayerLogScreen(),
        '/profile': (context) => ProfileScreen(),
        '/generated': (context) => GeneratedPlanScreen(readings: Provider.of<AppState>(context).allReadings, onToggleCompletion: (d) => Provider.of<AppState>(context, listen: false).toggleCompletion(d)),
        '/bible-plan': (context) => BiblePlanScreen(),
        '/plan-generator': (context) => PlanGenerationScreen(onGenerate: (cfg) => Provider.of<AppState>(context, listen: false).generatePlan(cfg)),
        '/progress': (context) => ProgressDashboardScreen(currentStreak: Provider.of<AppState>(context).currentStreak, bibleProgress: ((Provider.of<AppState>(context).allReadings.where((r) => r.completed).length / Provider.of<AppState>(context).generatedPlanConfig.timeFrame) * 100).toInt(), totalPrayers: Provider.of<AppState>(context).prayers.length),
        '/notifications': (context) => NotificationsScreen(),
        '/prayer-detail': (context) {
          final app = Provider.of<AppState>(context);
          final p = app.selectedPrayer;
          if (p == null) return Scaffold(body: Center(child: Text('No prayer selected')));
          return PrayerDetailScreen(title: p.title, description: p.description ?? '', isAnswered: p.isAnswered, onToggleAnswered: (v) => app.togglePrayerAnswered(p.id));
        },
        '/habits': (context) => HabitTrackingScreen(),
      },
    );
  }
}
