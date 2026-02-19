import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  final double value; // 0..1
  const ProgressCircle({required this.value});

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).toInt();
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(value: value, strokeWidth: 10),
              Text('$percent%')
            ],
          ),
        ),
        SizedBox(height: 8),
        Text('Weekly Progress')
      ],
    );
  }
}
