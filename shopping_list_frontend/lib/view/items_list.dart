import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/model/blocs/local_app_state_cubit.dart';

// Describes a single list of items that are part of a category
class ItemsList extends StatelessWidget {
  const ItemsList({required this.categoryName, required this.items, super.key});

  final String categoryName;
  final List<ShoppingItem> items;

  void _onItemChecked(BuildContext context, ShoppingItem item) {
    context.read<ItemListBloc>().add(ItemRemovedEvent(item: item));
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
              ),
              // if (items.where((item) => item.itemName.isNotEmpty).isEmpty)
              if (items.every((item) => item.itemName.isEmpty))
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      // Try to guess the checkboxes' line and position it there
                      padding: const EdgeInsets.symmetric(horizontal: 26.0),
                      onPressed: () => context
                          .read<ItemListBloc>()
                          .add(DeleteCategoryEvent(categoryName)),
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final currentItem = items
                  .where((item) => item.itemName.isNotEmpty)
                  .elementAt(index);
              return Row(
                children: [
                  Expanded(
                    flex: 10,
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
                    flex: 3,
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
            // Here we are handling the placeholder item - the builder method won't be called for it
            itemCount: items.where((item) => item.itemName.isNotEmpty).length,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
