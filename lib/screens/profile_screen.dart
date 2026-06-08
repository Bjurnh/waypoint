import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';
import '../widgets/status_bar_style.dart';
import 'edit_profile_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return StatusBarStyle(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Profile'),
          leading: BackButton(onPressed: () => Navigator.maybePop(context)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Spacing.md),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  final colorScheme = Theme.of(context).colorScheme;

                  return GradientBackground(
                    startColor: Colors.blue.withValues(alpha: 0.05),
                    midColor: Colors.indigo.withValues(alpha: 0.05),
                    // Avoid forcing a light background in dark mode.
                    endColor: isDark ? colorScheme.surface : Colors.white,
                    child: Container(),
                  );
                },
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: Spacing.lg,
                  right: Spacing.lg,
                  bottom: Spacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header
                    GradientCard(
                      borderColor: AppColors.border.withValues(alpha: 0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withValues(alpha: 0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: Colors.white,
                            ),

                          ),
                          const SizedBox(height: Spacing.md),
                          Consumer<AppState>(
                            builder: (_, app, __) => Text(
                              app.displayName?.trim().isNotEmpty == true
                                  ? app.displayName!.trim()
                                  : 'Prayer Warrior',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            'Member since ${DateTime.now().year}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),

                    // Statistics
                    Text(
                      'Your Statistics',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.foreground,
                          ),
                    ),
                    const SizedBox(height: Spacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: GradientCard(
                            borderColor: AppColors.border.withValues(alpha: 0.2),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.local_fire_department_rounded,
                                  size: 28,
                                  color: Colors.orange,
                                ),
                                const SizedBox(height: Spacing.sm),
                                Text(
                                  '${app.currentStreak}',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.foreground,
                                      ),
                                ),
                                Text(
                                  'Day Streak',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: GradientCard(
                            borderColor: AppColors.border.withValues(alpha: 0.2),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.favorite_rounded,
                                  size: 28,
                                  color: Colors.pink,
                                ),
                                const SizedBox(height: Spacing.sm),
                                Text(
                                  '${app.prayers.length}',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.foreground,
                                      ),
                                ),
                                Text(
                                  'Prayers',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: GradientCard(
                            borderColor: AppColors.border.withValues(alpha: 0.2),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.auto_stories_rounded,
                                  size: 28,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: Spacing.sm),
                                Consumer<AppState>(
                                  builder: (_, app, __) {
                                    final chaptersReadDone = app.allReadings
                                        .where((r) => r.completed)
                                        .fold<int>(
                                          0,
                                          (sum, r) => sum + r.chapters.length,
                                        );

                                    return Text(
                                      chaptersReadDone.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.foreground,
                                          ),
                                    );
                                  },
                                ),
                                Text(
                                  'Chapters',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),

                    // Settings
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.foreground,
                          ),
                    ),
                    const SizedBox(height: Spacing.md),
                    GradientCard(
                      borderColor: AppColors.border.withValues(alpha: 0.2),
                      child: Column(
                        children: [
                          _SettingsTile(
                            icon: Icons.notifications_rounded,
                            label: 'Notifications',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Notification settings')),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _SettingsTile(
                            icon: Icons.dark_mode_rounded,
                            label: 'Theme',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Theme settings')),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _SettingsTile(
                            icon: Icons.privacy_tip_rounded,
                            label: 'Privacy & Security',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Privacy settings')),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _SettingsTile(
                            icon: Icons.help_rounded,
                            label: 'Help & Support',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Help & Support')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),

                    // About
                    GradientCard(
                      borderColor: AppColors.border.withValues(alpha: 0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foreground,
                                ),
                          ),
                          const SizedBox(height: Spacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'App Version',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.foreground,
                                    ),
                              ),
                              Text(
                                '1.0.0',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),

                    // Logout Button
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Logged out successfully')),
                                  );
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                        side: BorderSide(
                          color: AppColors.destructive.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: Spacing.md),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.foreground,
                      ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.border.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

