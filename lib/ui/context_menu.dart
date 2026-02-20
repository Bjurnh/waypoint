import 'package:flutter/material.dart';

class AppContextMenu<T> extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> items;

  const AppContextMenu({required this.child, required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) async {
        // show at tap position
        await showMenu<T>(
          context: context,
          position: RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, details.globalPosition.dx, details.globalPosition.dy),
          items: items,
        );
        // ignore selected here; consumer can wrap child and handle selection via provided menu items
      },
      child: child,
    );
  }
}
