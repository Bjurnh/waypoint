import 'package:flutter/material.dart';

class ToggleGroup<T> extends StatelessWidget {
  final List<T> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final List<Widget>? labels;

  const ToggleGroup({required this.options, this.value, required this.onChanged, this.labels, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options.map((opt) {
        final index = options.indexOf(opt);
        final label = (labels != null && labels!.length > index) ? labels![index] : Text(opt.toString());
        final active = value == opt;
        return ChoiceChip(label: label, selected: active, onSelected: (_) => onChanged(opt));
      }).toList(),
    );
  }
}
