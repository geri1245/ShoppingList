import 'dart:math';

import 'package:flutter/material.dart';

typedef NumberChangedFunction = void Function(int number);

class NumberInput extends StatefulWidget {
  const NumberInput({required this.onNumberChanged, super.key});

  final NumberChangedFunction onNumberChanged;

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  int currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => setState(() {
            currentValue = max(currentValue - 1, 1);
            widget.onNumberChanged(currentValue);
          }),
          icon: const Icon(
            Icons.remove,
            color: Colors.lightBlue,
          ),
        ),
        Text(currentValue.toString()),
        IconButton(
          onPressed: () => setState(() {
            currentValue += 1;
            widget.onNumberChanged(currentValue);
          }),
          icon: const Icon(
            Icons.add,
            color: Colors.lightBlue,
          ),
        ),
      ],
    );
  }
}
