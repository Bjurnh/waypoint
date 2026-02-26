import 'package:flutter/material.dart';

/// A simple splash screen shown while app services initialize in background
class SplashScreen extends StatelessWidget {
  final VoidCallback onInitialized;

  const SplashScreen({
    super.key,
    required this.onInitialized,
  });

  @override
  Widget build(BuildContext context) {
    // Start initialization and return immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onInitialized();
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon/logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.directions,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            // App name
            const Text(
              'Waypoint',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your spiritual journey',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
