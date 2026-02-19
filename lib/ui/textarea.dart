import 'package:flutter/material.dart';

class AppTextarea extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final int maxLines;

  const AppTextarea({required this.controller, this.hint, this.maxLines = 4, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.all(12),
      ),
    );
  }
}
