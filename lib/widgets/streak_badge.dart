import 'package:flutter/material.dart';

class StreakBadge extends StatelessWidget {
  final int days;
  final double size;

  const StreakBadge({required this.days, this.size = 48, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$days', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: size * 0.35)),
          Text('days', style: TextStyle(color: Colors.white70, fontSize: size * 0.15)),
        ],
      ),
    );
  }
}
