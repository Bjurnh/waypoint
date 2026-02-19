import 'package:flutter/material.dart';

class AppForm extends StatelessWidget {
  final Widget child;
  final GlobalKey<FormState>? formKey;

  const AppForm({required this.child, this.formKey, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(key: formKey, child: child);
  }
}
