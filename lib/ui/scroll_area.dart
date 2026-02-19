import 'package:flutter/material.dart';

class ScrollArea extends StatelessWidget {
  final Widget child;

  const ScrollArea({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: child);
  }
}
