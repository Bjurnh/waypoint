import 'package:flutter/material.dart';

class AppLinearProgress extends StatelessWidget {
  final double value;

  const AppLinearProgress({required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(value: value);
  }
}

class AppCircularProgress extends StatelessWidget {
  final double value;
  final double size;

  const AppCircularProgress({required this.value, this.size = 48, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(value: value),
    );
  }
}
