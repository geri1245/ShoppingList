import 'dart:html';

import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/shopping_item.dart';

class ShoppingItemList extends StatelessWidget {
  const ShoppingItemList(this.items, this._onItemCheckedFunction, {super.key});

  final List<ShoppingItem> items;
  final void Function(String name) _onItemCheckedFunction;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              flex: 8,
              child: Text(items[index].itemName),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(items[index].count.toString()),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    _onItemCheckedFunction(items[index].itemName);
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.lightBlue,
                  )),
            ),
          ],
        );
      },
      itemCount: items.length,
      shrinkWrap: true,
    );
  }
}
