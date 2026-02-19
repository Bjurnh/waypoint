import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final List<Widget> items;

  const NavigationMenu({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: items);
  }
}
