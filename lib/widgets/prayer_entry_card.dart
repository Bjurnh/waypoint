import 'package:flutter/material.dart';
import '../ui/card.dart';

class PrayerEntryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const PrayerEntryCard({required this.title, required this.subtitle, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
