import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/events.dart';
import 'package:shopping_list_frontend/data/model/item_list_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/data/model/local_app_state_cubit.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({required this.categoryName, required this.items, super.key});

  final String categoryName;
  final List<ShoppingItem> items;

  void _onItemChecked(BuildContext context, ShoppingItem item) {
    context.read<ItemListBloc>().add(ItemRemovedEvent(item));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              Text(
                categoryName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => context
                    .read<LocalAppStateCubit>()
                    .startAddingItems(categoryName),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.lightBlue,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
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
        ),
      ],
    );
  }
}
