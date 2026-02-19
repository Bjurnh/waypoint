import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;

  const AppSwitch({required this.value, required this.onChanged, this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (label != null) Text(label!),
        Spacer(),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
