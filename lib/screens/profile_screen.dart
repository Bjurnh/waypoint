import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current streak: ${app.currentStreak} days', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/notifications'), child: Text('Notifications')),
          ],
        ),
      ),
    );
  }
}
