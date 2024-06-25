import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
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
                return ItemsList(
                    categoryName: currentItem.key, items: currentItem.value);
              },
            ),
          ),
          SizedBox.fromSize(
              size: const Size.fromHeight(50.0),
              child: OutlinedButton(
                onPressed: () {
                  getTextInputWithDialog(context, (input) {
                    if (input.isNotEmpty) {
                      // Add a placeholder item, so we still display the category correctly
                      context.read<ItemListBloc>().add(ItemAddedEvent(
                          ShoppingItem(
                              category: input, count: 0, itemName: "")));
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
