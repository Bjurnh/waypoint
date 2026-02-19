import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress; // 0..1
  final VoidCallback? onTap;

  const HabitCard({required this.title, this.subtitle = '', this.progress = 0.0, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle.isNotEmpty) Text(subtitle),
            SizedBox(height: 6),
            LinearProgressIndicator(value: progress),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
