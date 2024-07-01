import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/adding_items_control_cubit.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/model/state/item_list_state.dart';
import 'package:shopping_list_frontend/view/items_list.dart';
import 'package:shopping_list_frontend/view/text_input_dialog.dart';

/// Contains the description of a single tab inside the application
class ItemTab extends StatelessWidget {
  const ItemTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemListState>(
      builder: (context, state) => Column(
        children: [
          Expanded(
            flex: 6,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.items.entries.length,
              itemBuilder: (context, index) {
                final currentItem = state.items.entries.elementAt(index);
                return Column(
                  children: [
                    ItemsList(
                        categoryName: currentItem.key,
                        items: currentItem.value),
                    if (index < state.items.entries.length - 1)
                      const Divider(
                        color: Colors.blueAccent,
                        height: 0,
                        indent: 16,
                        endIndent: 16,
                        thickness: 0.0,
                      )
                  ],
                );
              },
            ),
          ),
          SizedBox.fromSize(
              size: const Size.fromHeight(50.0),
              child: OutlinedButton(
                onPressed: () {
                  getTextInputWithDialog(context, (newCategory) {
                    if (newCategory.isNotEmpty) {
                      // Add a placeholder item, so we still display the category correctly
                      context.read<ItemListBloc>().add(ItemAddedEvent(
                          ShoppingItem(
                              category: newCategory, count: 0, itemName: "")));
                      if (!context
                          .read<ItemListBloc>()
                          .state
                          .items
                          .keys
                          .contains(newCategory)) {
                        context
                            .read<AddingItemsControlCubit>()
                            .startAddingItems(newCategory);
                      }
                    }
                  });
                },
                child: const Text("Add new category"),
              ))
        ],
      ),
    );
  }
}
