import 'package:flutter/material.dart';

class ResizableBox extends StatefulWidget {
  final Widget child;
  final double initialHeight;

  const ResizableBox({required this.child, this.initialHeight = 200, Key? key}) : super(key: key);

  @override
  _ResizableBoxState createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<ResizableBox> {
  late double height;

  @override
  void initState() {
    super.initState();
    height = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: height, child: widget.child),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate: (d) => setState(() => height = (height + d.delta.dy).clamp(50.0, 800.0)),
          child: Container(height: 12, color: Colors.transparent, child: Center(child: Icon(Icons.drag_handle))),
        )
      ],
    );
  }
}
