import 'package:flutter/material.dart';
import '../widgets/progress_circle.dart';
import '../models/plan_models.dart';

typedef ToggleCompletion = void Function(int day);

class GeneratedPlanScreen extends StatelessWidget {
  final List<DayReading> readings;
  final ToggleCompletion? onToggleCompletion;

  const GeneratedPlanScreen({this.readings = const [], this.onToggleCompletion, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedCount = readings.where((r) => r.completed).length;
    final progress = readings.isEmpty ? 0.0 : completedCount / readings.length;

    return Scaffold(
      appBar: AppBar(title: Text('Generated Plan')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ProgressCircle(value: progress),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: readings.length,
                itemBuilder: (c, i) {
                  final r = readings[i];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: CheckboxListTile(
                      title: Text('Day ${r.day} • ${r.date}'),
                      subtitle: Text(r.chapters.join(', ')),
                      value: r.completed,
                      onChanged: (v) {
                        if (onToggleCompletion != null) onToggleCompletion!(r.day);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
