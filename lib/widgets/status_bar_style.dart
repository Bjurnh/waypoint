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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}

