import 'package:flutter/material.dart';

class ShoppingItem extends StatelessWidget {
  const ShoppingItem(this.itemName, this.count, {super.key});

  final String itemName;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(itemName),
      Text(count.toString()),
    ]);
  }
}
