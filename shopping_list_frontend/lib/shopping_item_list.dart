import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/shopping_item.dart';

class ShoppingItemList extends StatelessWidget {
  const ShoppingItemList(this.items, {super.key});

  final List<ShoppingItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(child: Text(items[index].itemName)),
              Align(
                alignment: Alignment.centerRight,
                child: Text(items[index].count.toString()),
              )
            ],
          ),
        );
      },
      itemCount: items.length,
    );
  }
}
