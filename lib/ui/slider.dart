import 'package:flutter/material.dart';

class AppSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const AppSlider({required this.value, required this.onChanged, this.min = 0, this.max = 1, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider(value: value, onChanged: onChanged, min: min, max: max);
  }
}
