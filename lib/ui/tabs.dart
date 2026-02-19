import 'package:flutter/material.dart';

class AppTabs extends StatelessWidget {
  final List<Tab> tabs;
  final List<Widget> views;

  const AppTabs({required this.tabs, required this.views, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(tabs: tabs),
          SizedBox(height: 8),
          Expanded(child: TabBarView(children: views)),
        ],
      ),
    );
  }
}
