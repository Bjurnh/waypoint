import 'package:flutter/material.dart';

class AppCarousel extends StatelessWidget {
  final List<Widget> items;
  final double height;

  const AppCarousel({required this.items, this.height = 200, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: PageView(
        children: items,
      ),
    );
  }
}
