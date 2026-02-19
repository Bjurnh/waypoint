import 'package:flutter/material.dart';

class InputOtp extends StatelessWidget {
  final List<TextEditingController> controllers;
  final double boxSize;

  const InputOtp({required this.controllers, this.boxSize = 48, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controllers.length, (i) {
        return Container(
          width: boxSize,
          height: boxSize,
          margin: EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
            controller: controllers[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(counterText: ''),
          ),
        );
      }),
    );
  }
}
