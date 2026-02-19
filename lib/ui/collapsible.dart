import 'package:flutter/material.dart';

class Collapsible extends StatefulWidget {
  final Widget header;
  final Widget body;

  const Collapsible({required this.header, required this.body, Key? key}) : super(key: key);

  @override
  _CollapsibleState createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(onTap: () => setState(() => open = !open), child: widget.header),
        AnimatedCrossFade(
          firstChild: SizedBox.shrink(),
          secondChild: widget.body,
          crossFadeState: open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        )
      ],
    );
  }
}
