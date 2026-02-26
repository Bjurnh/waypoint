import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Spacing.md),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile coming soon')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GradientBackground(
            child: Container(),
            startColor: Colors.blue.withValues(alpha:0.05),
            midColor: Colors.indigo.withValues(alpha:0.05),
            endColor: Colors.white,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + Spacing.lg,
              left: Spacing.lg,
              right: Spacing.lg,
              bottom: Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Header
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha:0.2),
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
                              AppColors.primary.withValues(alpha:0.7),
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
                              color: Colors.black.withValues(alpha:0.1),
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
                      SizedBox(height: Spacing.md),
                      Text(
                        'Prayer Warrior',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: Spacing.xs),
                      Text(
                        'Member since ${DateTime.now().year}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Statistics
                Text(
                  'Your Statistics',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: GradientCard(
                        borderColor: AppColors.border.withValues(alpha:0.2),
                        child: Column(
                          children: [
                            Icon(
                              Icons.local_fire_department_rounded,
                              size: 28,
                              color: Colors.orange,
                            ),
                            SizedBox(height: Spacing.sm),
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
                    SizedBox(width: Spacing.md),
                    Expanded(
                      child: GradientCard(
                        borderColor: AppColors.border.withValues(alpha:0.2),
                        child: Column(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              size: 28,
                              color: Colors.pink,
                            ),
                            SizedBox(height: Spacing.sm),
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
                    SizedBox(width: Spacing.md),
                    Expanded(
                      child: GradientCard(
                        borderColor: AppColors.border.withValues(alpha:0.2),
                        child: Column(
                          children: [
                            Icon(
                              Icons.auto_stories_rounded,
                              size: 28,
                              color: Colors.blue,
                            ),
                            SizedBox(height: Spacing.sm),
                            Text(
                              '42',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.foreground,
                              ),
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
                SizedBox(height: Spacing.lg),

                // Settings
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                SizedBox(height: Spacing.md),
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha:0.2),
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
                      Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.dark_mode_rounded,
                        label: 'Theme',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Theme settings')),
                          );
                        },
                      ),
                      Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.privacy_tip_rounded,
                        label: 'Privacy & Security',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Privacy settings')),
                          );
                        },
                      ),
                      Divider(height: 1),
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
                SizedBox(height: Spacing.lg),

                // About
                GradientCard(
                  borderColor: AppColors.border.withValues(alpha:0.2),
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
                      SizedBox(height: Spacing.md),
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
                SizedBox(height: Spacing.lg),

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
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
                    side: BorderSide(
                      color: AppColors.destructive.withValues(alpha:0.5),
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        padding: EdgeInsets.symmetric(
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
                SizedBox(width: Spacing.md),
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
              color: AppColors.border.withValues(alpha:0.5),
            ),
          ],
        ),
      ),
    );
  }
}
