import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/itemList/list_item.dart';
import 'package:shopping_list_frontend/model/state/item_list_state.dart';
import 'package:shopping_list_frontend/view/items_list.dart';
import 'package:shopping_list_frontend/view/popups/bottom_sheet_autocomplete.dart';
import 'package:shopping_list_frontend/view/popups/text_input_dialog.dart';

/// Contains the description of a single tab inside the application
class ItemTab extends StatelessWidget {
  const ItemTab({required this.mainCategoryName, super.key});

  final String mainCategoryName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemListState>(
        buildWhen: (previous, current) {
      final currentItems = current.items[mainCategoryName];

      if (currentItems == null) {
        return false;
      }

      final previousItems = previous.items[mainCategoryName];

      final areEqual = previousItems == null ||
          !areSubCategoriesEqual(currentItems, previousItems);
      return areEqual;
    }, builder: (context, state) {
      final childCount = state.items[mainCategoryName]?.entries.length ?? 0 + 1;
      return SliverList(
          delegate: SliverChildBuilderDelegate(
        childCount: childCount,
        (context, index) {
          if (index == childCount - 1) {
            return SizedBox.fromSize(
                size: const Size.fromHeight(50.0),
                child: OutlinedButton(
                  onPressed: () {
                    getTextInputWithDialog(
                      context,
                      (p0) {},
                    ).then(
                      (newCategory) {
                        if (newCategory?.isNotEmpty ?? false) {
                          context.read<ItemListBloc>().add(AddItemEvent(Item(
                              mainCategory: mainCategoryName,
                              subCategory: newCategory!,
                              count: 0,
                              name: "")));
                          if (!state.items.keys.contains(newCategory)) {
                            final autocompleteEntries = context
                                .read<ItemListBloc>()
                                .getItemsSeenForCategory(
                                    mainCategory: mainCategoryName,
                                    subCategory: newCategory);
                            showModalBottomInputBox(
                                context, autocompleteEntries,
                                (String itemAdded, int quantity) {
                              context.read<ItemListBloc>().add(AddItemEvent(
                                    Item(
                                        mainCategory: mainCategoryName,
                                        subCategory: newCategory,
                                        name: itemAdded,
                                        count: quantity),
                                  ));
                            });
                          }
                        }
                      },
                    );
                  },
                  child: const Text("Add new category"),
                ));
          } else {
            final entry = state.items[mainCategoryName]!.entries
                .where((element) => element.key.isNotEmpty)
                .elementAt(index);
            return ItemsList(
              subCategoryName: entry.key,
              items: entry.value,
              mainCategoryName: mainCategoryName,
            );
          }
        },
      ));
    });
  }
}
