import 'package:flutter/material.dart';

class MiniCalendar extends StatelessWidget {
  final DateTime month;

  MiniCalendar({DateTime? month, Key? key}) : month = month ?? DateTime.now(), super(key: key);

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = first.weekday % 7; // make Sunday=0

    return Column(
      children: [
        Text('${month.year} - ${month.month}'),
        SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          itemCount: startWeekday + daysInMonth,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemBuilder: (c, i) {
            final dayNum = i - startWeekday + 1;
            if (i < startWeekday) return SizedBox.shrink();
            return Center(child: Text('$dayNum'));
          },
        )
      ],
    );
  }
}
