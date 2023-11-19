import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/shopping_item.dart';
import 'package:shopping_list_frontend/shopping_item_category.dart';

class ShoppingItemList extends StatelessWidget {
  const ShoppingItemList(
      {required this.items, required this.onItemCheckedFunction, super.key});

  final Map<String, List<ShoppingItem>> items;
  final void Function(ShoppingItem item) onItemCheckedFunction;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: items.entries.length,
        itemBuilder: (context, index) {
          final currentItem = items.entries.elementAt(index);
          return ShoppingItemCategory(
              categoryName: currentItem.key,
              items: currentItem.value,
              onItemCheckedFunction: onItemCheckedFunction);
        });
  }
}
