import 'package:flutter/material.dart';
import '../widgets/habit_card.dart';

class HabitTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> habits = [
      {'title': 'Read Bible', 'subtitle': 'Daily 15 min', 'progress': 0.6},
      {'title': 'Pray', 'subtitle': 'Morning & Night', 'progress': 0.8},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Habits')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: habits.length,
        itemBuilder: (c, i) {
          final h = habits[i];
          return HabitCard(
            title: h['title'] as String,
            subtitle: h['subtitle'] as String,
            progress: h['progress'] as double,
            onTap: () {},
          );
        },
      ),
    );
  }
}
