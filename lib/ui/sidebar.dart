import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final List<Widget> items;

  const AppSidebar({this.items = const [], Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.grey[50],
      child: ListView(children: items),
    );
  }
}
