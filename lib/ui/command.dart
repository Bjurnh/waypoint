import 'package:flutter/material.dart';

class CommandPalette extends StatelessWidget {
  final List<String> commands;

  const CommandPalette({this.commands = const [], Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(decoration: InputDecoration(hintText: 'Search commands')),
          SizedBox(height: 8),
          ...commands.map((c) => ListTile(title: Text(c))).toList(),
        ]),
      ),
    );
  }
}
