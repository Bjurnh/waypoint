import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Forces status bar to be transparent with dark icons.
///
/// This is needed because some screens (other than Home) don't set
/// [SystemUiOverlayStyle], so Android/iOS may revert to defaults.
class StatusBarStyle extends StatelessWidget {
  final Widget child;

  const StatusBarStyle({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // In dark mode we want light status bar icons; in light mode we want dark icons.
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: child,
    );
  }

}

