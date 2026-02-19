import 'package:flutter/material.dart';

class AppAlertDialog {
  static Future<T?> show<T>(BuildContext context, {required String title, required Widget content, List<Widget>? actions}) {
    return showDialog<T>(
      context: context,
      builder: (c) => AlertDialog(title: Text(title), content: content, actions: actions),
    );
  }
}
