import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;

  const AppDialog({required this.title, required this.content, this.actions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
    );
  }

  static Future<T?> show<T>(BuildContext context, {required String title, required Widget content, List<Widget>? actions}) {
    return showDialog<T>(context: context, builder: (_) => AppDialog(title: title, content: content, actions: actions));
  }
}
