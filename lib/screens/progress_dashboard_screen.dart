import 'package:flutter/material.dart';
import '../widgets/progress_circle.dart';

class ProgressDashboardScreen extends StatelessWidget {
  final int currentStreak;
  final int bibleProgress; // percent
  final int totalPrayers;

  const ProgressDashboardScreen({this.currentStreak = 0, this.bibleProgress = 0, this.totalPrayers = 0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Progress')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Streak', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text('$currentStreak days', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 16),
            Text('Bible Progress', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            ProgressCircle(value: bibleProgress / 100),
            SizedBox(height: 16),
            Text('Prayers', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text('$totalPrayers total prayers'),
          ],
        ),
      ),
    );
  }
}
