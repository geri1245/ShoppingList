import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/shopping_item.dart';

class ShoppingItemCategory extends StatelessWidget {
  const ShoppingItemCategory(
      {required this.categoryName,
      required this.items,
      required this.onItemCheckedFunction,
      super.key});

  final String categoryName;
  final List<ShoppingItem> items;
  final void Function(ShoppingItem item) onItemCheckedFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(categoryName),
        ListView.builder(
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final currentItem = items[index];
            return Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(currentItem.itemName),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(currentItem.count.toString()),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: () {
                        onItemCheckedFunction(currentItem);
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
        ),
      ],
    );
  }
}
