import 'package:flutter/material.dart';

class AppTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const AppTooltip({required this.message, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(message: message, child: child);
  }
}
