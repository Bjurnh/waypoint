import 'package:flutter/material.dart';

class StreakCelebrationDialog extends StatelessWidget {
  final int streak;
  final int milestone;
  final VoidCallback? onClose;

  const StreakCelebrationDialog({required this.streak, required this.milestone, this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Streak Milestone!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('You reached $streak days!'),
          SizedBox(height: 8),
          Text('Milestone: $milestone days'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onClose != null) onClose!();
          },
          child: Text('Close'),
        )
      ],
    );
  }
}
