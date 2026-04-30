import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waypoint_app/screens/add_prayer_screen.dart';

import 'state/app_state.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';
import 'widgets/bottom_navigation_shell.dart';
import 'theme/app_theme.dart';
import 'widgets/splash_screen.dart';
import 'screens/bible_plan_screen.dart';
import 'screens/prayer_log_screen.dart';
import 'screens/habit_tracking_screen.dart';
import 'screens/plan_generation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open boxes
  await HiveService().init();

  // Initialize notifications asynchronously (non-blocking)
  NotificationService.initialize().catchError((e) {
    debugPrint('Notification service initialization failed: $e');
  });

  runApp(ChangeNotifierProvider(create: (_) => AppState(), child: const WaypointApp()));
}

class WaypointApp extends StatefulWidget {
  const WaypointApp({Key? key}) : super(key: key);

  @override
  State<WaypointApp> createState() => _WaypointAppState();
}

class _WaypointAppState extends State<WaypointApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Delay initialization to next frame to avoid deactivated widget errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    if (!mounted) return;
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.loadData();
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
        home: SplashScreen(onInitialized: _initializeApp),
      );
    }

    return MaterialApp(
      title: 'Waypoint',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const BottomNavigationShell(),
      routes: {
        '/plan': (context) => const BiblePlanScreen(),
        '/prayer log': (context) => const PrayerLogScreen(),
        '/habits': (context) => const HabitTrackingScreen(),
        '/add': (context) => const AddPrayerScreen(),
        '/generate-plan': (context) => PlanGenerationScreen(
          onGenerate: (config) {
            final appState = Provider.of<AppState>(context, listen: false);
            appState.generatePlan(config);
            Navigator.pop(context); // Go back after generating
          },
        ),
      },
    );
  }
}
