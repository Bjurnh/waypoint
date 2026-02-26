import 'package:flutter/material.dart';

class SimpleChart extends StatelessWidget {
  final List<double> values;

  const SimpleChart({this.values = const [], Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return Center(child: Text('No data'));
    final max = values.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.map((v) {
          final h = (v / max) * 100;
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: h,
              color: Theme.of(context).primaryColor.withValues(alpha:0.7),
            ),
          );
        }).toList(),
      ),
    );
  }
}
