import 'package:flutter/material.dart';

class AppSheet {
  static Future<T?> show<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T>(context: context, builder: (_) => child);
  }
}
