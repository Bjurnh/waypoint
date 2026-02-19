import 'package:flutter/material.dart';

class AppSeparator extends StatelessWidget {
  final double thickness;
  final Color? color;

  const AppSeparator({this.thickness = 1, this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: thickness, color: color ?? Colors.grey[300]);
  }
}
