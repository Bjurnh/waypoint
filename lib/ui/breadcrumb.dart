import 'package:flutter/material.dart';

class AppBreadcrumb extends StatelessWidget {
  final List<String> items;

  const AppBreadcrumb({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((s) => Padding(padding: EdgeInsets.only(right: 6), child: Text(s))).toList(),
    );
  }
}
