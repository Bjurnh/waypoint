import 'package:flutter/material.dart';

class AppPopover<T> extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> items;

  const AppPopover({required this.child, required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      itemBuilder: (_) => items,
      child: child,
    );
  }
}
