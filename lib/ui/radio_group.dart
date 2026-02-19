import 'package:flutter/material.dart';

class AppRadioGroup<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const AppRadioGroup({this.value, required this.items, required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((it) {
        return RadioListTile<T>(
          value: it.value as T,
          groupValue: value,
          title: it.child,
          onChanged: onChanged,
        );
      }).toList(),
    );
  }
}
