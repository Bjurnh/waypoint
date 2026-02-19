import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/prayer_entry_card.dart';
import '../widgets/gradient_background.dart';
import '../models/prayer_entry.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

typedef PrayerTapCallback = void Function(PrayerEntry prayer);
typedef PrayerToggleCallback = void Function(String id);

class PrayerLogScreen extends StatelessWidget {
  final List<PrayerEntry>? prayers;
  final VoidCallback? onAddPrayer;
  final PrayerTapCallback? onViewPrayer;
  final PrayerToggleCallback? onToggleAnswered;

  const PrayerLogScreen({
    super.key,
    this.prayers,
    this.onAddPrayer,
    this.onViewPrayer,
    this.onToggleAnswered,
  });

  @override
  Widget build(BuildContext context) {
    final list = prayers ?? Provider.of<AppState>(context).prayers;

    return GradientBackground.prayer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Prayer Log',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pinkGradientStart, AppColors.pinkGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 24),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (c, i) {
            final p = list[i];
            return PrayerEntryCard(
              title: p.title,
              subtitle: p.isAnswered ? 'Answered' : 'Pending',
              onTap: () {
                if (onViewPrayer != null) {
                  onViewPrayer!(p);
                } else {
                  Provider.of<AppState>(context, listen: false).viewPrayer(p.id);
                  Navigator.pushNamed(context, '/profile');
                }
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onAddPrayer ?? () => Navigator.pushNamed(context, '/add'),
          backgroundColor: AppColors.pinkGradientStart,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
