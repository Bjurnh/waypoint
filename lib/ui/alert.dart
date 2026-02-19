import 'package:flutter/material.dart';

class AppAlert extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final VoidCallback? onClose;

  const AppAlert({required this.message, this.backgroundColor, this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: backgroundColor ?? Colors.yellow[100], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(child: Text(message)),
          if (onClose != null)
            IconButton(icon: Icon(Icons.close), onPressed: onClose),
        ],
      ),
    );
  }
}
