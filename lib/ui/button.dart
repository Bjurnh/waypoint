import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool primary;

  const AppButton({required this.label, required this.onPressed, this.primary = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = primary
        ? ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16))
        : ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          );

    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
