import 'package:flutter/material.dart';

class UseMobile {
  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 700;
  }
}
