import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Widget? header;
  final List<Widget> items;

  const AppDrawer({this.header, this.items = const [], Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (header != null) DrawerHeader(child: header!),
          ...items,
        ],
      ),
    );
  }
}
