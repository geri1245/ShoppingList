import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/events.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';

class ShoppingItemCategory extends StatelessWidget {
  const ShoppingItemCategory(
      {required this.categoryName, required this.items, super.key});

  final String categoryName;
  final List<ShoppingItem> items;

  void _onItemChecked(BuildContext context, ShoppingItem item) {
    context.read<ItemListBloc>().add(ItemRemovedEvent(item));
  }

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
                        _onItemChecked(context, currentItem);
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
