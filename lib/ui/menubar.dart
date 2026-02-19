import 'package:flutter/material.dart';

class AppMenubar extends StatelessWidget {
  final List<Widget> items;

  const AppMenubar({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: items);
  }
}
