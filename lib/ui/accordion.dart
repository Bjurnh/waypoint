import 'package:flutter/material.dart';

class AppAccordion extends StatelessWidget {
  final List<ExpansionPanel> panels;

  const AppAccordion({required this.panels, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (i, open) {},
      children: panels,
    );
  }
}
