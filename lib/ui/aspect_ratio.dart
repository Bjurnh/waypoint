import 'package:flutter/material.dart';

class AppAspectRatio extends StatelessWidget {
  final double ratio;
  final Widget child;

  const AppAspectRatio({required this.ratio, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(aspectRatio: ratio, child: child);
}
