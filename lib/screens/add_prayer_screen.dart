import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui/input.dart';
import '../ui/button.dart';
import '../state/app_state.dart';

class AddPrayerScreen extends StatefulWidget {
  @override
  _AddPrayerScreenState createState() => _AddPrayerScreenState();
}

class _AddPrayerScreenState extends State<AddPrayerScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    Provider.of<AppState>(context, listen: false).addPrayer(title: text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prayer added')));
    _controller.clear();
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Prayer')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppInput(
              controller: _controller,
              hintText: 'Prayer title / request',
              maxLines: 4,
            ),
            SizedBox(height: 12),
            AppButton(label: 'Save', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
