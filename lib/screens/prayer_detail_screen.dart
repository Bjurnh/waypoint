import 'package:flutter/material.dart';

class PrayerDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final bool isAnswered;
  final ValueChanged<bool>? onToggleAnswered;

  const PrayerDetailScreen({
    required this.title,
    required this.description,
    this.isAnswered = false,
    this.onToggleAnswered,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Detail'),
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Answered:'),
                Switch(
                  value: isAnswered,
                  onChanged: (v) {
                    if (onToggleAnswered != null) onToggleAnswered!(v);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
