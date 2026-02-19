import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final double elevation;

  const HoverCard({required this.child, this.elevation = 8, Key? key}) : super(key: key);

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        transform: Matrix4.identity()..translate(0, _hovering ? -4 : 0),
        child: Card(elevation: _hovering ? widget.elevation : 2, child: widget.child),
      ),
    );
  }
}
