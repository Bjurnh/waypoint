import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = List.generate(4, (i) => 'Notification ${i + 1}');
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView.separated(
        padding: EdgeInsets.all(12),
        itemBuilder: (c, i) => ListTile(title: Text(items[i])),
        separatorBuilder: (_, __) => Divider(),
        itemCount: items.length,
      ),
    );
  }
}
