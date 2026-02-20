import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A modern AppBar with gradient icon container, title, and subtitle.
/// Matches React's header design: "w-12 h-12 bg-gradient-to-br from-blue-400 to-purple-400 rounded-full"
class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The icon to display in the gradient container
  final IconData icon;
  
  /// Gradient start color for icon container
  final Color gradientStart;
  
  /// Gradient end color for icon container
  final Color gradientEnd;
  
  /// The main title text
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Whether to show a back button
  final bool showBackButton;
  
  /// Callback for back button
  final VoidCallback? onBack;
  
  /// List of actions to show on the right
  final List<Widget>? actions;

  const ModernAppBar({
    super.key,
    required this.icon,
    this.gradientStart = AppColors.blueGradientStart,
    this.gradientEnd = AppColors.purpleGradientEnd,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBack,
    this.actions,
  });

  /// Factory for Home screen app bar
  factory ModernAppBar.home({
    Key? key,
    String title = 'Waypoint',
    String? subtitle,
    List<Widget>? actions,
  }) {
    return ModernAppBar(
      key: key,
      icon: Icons.auto_awesome,
      gradientStart: AppColors.blueGradientStart,
      gradientEnd: AppColors.purpleGradientEnd,
      title: title,
      subtitle: subtitle,
      actions: actions,
    );
  }

  /// Factory for Prayer Log screen app bar
  factory ModernAppBar.prayer({
    Key? key,
    String title = 'Prayer Log',
    String? subtitle,
    bool showBackButton = false,
    VoidCallback? onBack,
  }) {
    return ModernAppBar(
      key: key,
      icon: Icons.favorite,
      gradientStart: AppColors.pinkGradientStart,
      gradientEnd: AppColors.pinkGradientEnd,
      title: title,
      subtitle: subtitle,
      showBackButton: showBackButton,
      onBack: onBack,
    );
  }

  /// Factory for Prayer Log screen app bar (alias)
  factory ModernAppBar.prayerLog({
    Key? key,
    String title = 'Prayer Log',
    String? subtitle,
    bool showBackButton = false,
    VoidCallback? onBack,
  }) {
    return ModernAppBar(
      key: key,
      icon: Icons.favorite,
      gradientStart: AppColors.pinkGradientStart,
      gradientEnd: AppColors.pinkGradientEnd,
      title: title,
      subtitle: subtitle,
      showBackButton: showBackButton,
      onBack: onBack,
    );
  }

  /// Factory for Progress Dashboard screen app bar
  factory ModernAppBar.progress({
    Key? key,
    String title = 'Progress',
    String? subtitle,
    bool showBackButton = false,
    VoidCallback? onBack,
  }) {
    return ModernAppBar(
      key: key,
      icon: Icons.trending_up,
      gradientStart: AppColors.indigoGradientStart,
      gradientEnd: AppColors.indigoGradientEnd,
      title: title,
      subtitle: subtitle,
      showBackButton: showBackButton,
      onBack: onBack,
    );
  }

  /// Factory for Habit Tracking screen app bar
  factory ModernAppBar.habit({
    Key? key,
    String title = 'Habits',
    String? subtitle,
    bool showBackButton = false,
    VoidCallback? onBack,
  }) {
    return ModernAppBar(
      key: key,
      icon: Icons.check_circle,
      gradientStart: AppColors.greenGradientStart,
      gradientEnd: AppColors.greenGradientEnd,
      title: title,
      subtitle: subtitle,
      showBackButton: showBackButton,
      onBack: onBack,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
              onPressed: onBack ?? () => Navigator.pop(context),
            )
          : null,
      title: Row(
        children: [
          // Icon in gradient container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          // Title and subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: actions,
    );
  }
}
