import 'package:flutter/material.dart';
import '../models/plan_models.dart';

class PlanGenerationScreen extends StatefulWidget {
  final void Function(PlanConfig) onGenerate;
  final VoidCallback? onBack;

  const PlanGenerationScreen({required this.onGenerate, this.onBack, Key? key}) : super(key: key);

  @override
  _PlanGenerationScreenState createState() => _PlanGenerationScreenState();
}

class _PlanGenerationScreenState extends State<PlanGenerationScreen> {
  final _timeFrameCtrl = TextEditingController(text: '90');
  final _minutesCtrl = TextEditingController(text: '15');
  DateTime _startDate = DateTime.now();
  String _readingStyle = 'mixed';

  @override
  void dispose() {
    _timeFrameCtrl.dispose();
    _minutesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  void _generate() {
    final config = PlanConfig(
      timeFrame: int.tryParse(_timeFrameCtrl.text) ?? 90,
      startDate: _startDate,
      dailyMinutes: int.tryParse(_minutesCtrl.text) ?? 15,
      readingStyle: _readingStyle,
    );
    widget.onGenerate(config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Plan'),
        leading: BackButton(onPressed: widget.onBack ?? () => Navigator.maybePop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _timeFrameCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Timeframe (days)')),
            SizedBox(height: 8),
            TextField(controller: _minutesCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Daily minutes')),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('Start date: ${_startDate.toLocal().toIso8601String().split('T')[0]}')),
                TextButton(onPressed: _pickDate, child: Text('Change')),
              ],
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _readingStyle,
              items: ['mixed', 'sequential'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _readingStyle = v ?? 'mixed'),
              decoration: InputDecoration(labelText: 'Reading style'),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _generate, child: Text('Generate')),
          ],
        ),
      ),
    );
  }
}
