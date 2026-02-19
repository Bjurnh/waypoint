import 'package:flutter/material.dart';
import 'generated_plan_screen.dart';
import '../models/plan_models.dart';

class BiblePlanScreen extends StatelessWidget {
  final PlanConfig? config;
  final List<DayReading>? readings;

  const BiblePlanScreen({this.config, this.readings, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sampleReadings = readings ?? List.generate(30, (i) => DayReading(day: i + 1, date: 'Day ${i + 1}', chapters: ['Genesis ${i + 1}']));

    return Scaffold(
      appBar: AppBar(title: Text('Bible Plan')),
      body: GeneratedPlanScreen(readings: sampleReadings),
    );
  }
}
