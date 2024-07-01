import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/tap_position_cubit.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/model/blocs/adding_items_control_cubit.dart';
import 'package:shopping_list_frontend/view/popups/long_tap_item_action_popup_menu.dart';
import 'package:shopping_list_frontend/view/popups/string_list_popup_menu.dart';

const paddingBetweenListItems = 8.0;
const paddingAroundCategoryTitles = 12.0;
const paddingAroundIcons = 12.0;
const iconSize = 20.0;

const fullListHorizontalPadding = 26.0;

// Describes a single list of items that are part of a category
class ItemsList extends StatelessWidget {
  const ItemsList({required this.categoryName, required this.items, super.key});

  final String categoryName;
  final List<ShoppingItem> items;

  void _onItemChecked(BuildContext context, ShoppingItem item) {
    context.read<ItemListBloc>().add(ItemRemovedEvent(item: item));
  }

  void _onItemLongTapActionSelected(
      ItemLongTapAction? action,
      BuildContext context,
      ShoppingItem longTappedItem,
      Offset tapPosition,
      Size screenSize) {
    if (action != null) {
      switch (action) {
        case ItemLongTapAction.moveToAnotherCategory:
          final categories = context
              .read<ItemListBloc>()
              .state
              .items
              .keys
              .where((element) => element != longTappedItem.category)
              .toList();
          if (categories.isNotEmpty) {
            showStringListPopupMenu(
                    context, tapPosition, screenSize, categories)
                .then((selectedCategory) {
              if (selectedCategory != null) {
                context
                    .read<ItemListBloc>()
                    .add(ItemRemovedEvent(item: longTappedItem));
                context.read<ItemListBloc>().add(ItemAddedEvent(ShoppingItem(
                    category: selectedCategory,
                    count: longTappedItem.count,
                    itemName: longTappedItem.itemName)));
              }
            });
          }
        case ItemLongTapAction.delete:
          context
              .read<ItemListBloc>()
              .add(ItemRemovedEvent(item: longTappedItem));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: fullListHorizontalPadding,
          vertical: paddingAroundCategoryTitles),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                categoryName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: paddingAroundIcons, vertical: 0),
                constraints: const BoxConstraints(),
                iconSize: iconSize,
                onPressed: () => context
                    .read<AddingItemsControlCubit>()
                    .startAddingItems(categoryName),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.lightBlue,
                ),
              ),
              if (items.every((item) => item.itemName.isEmpty))
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      // Try to guess the checkboxes' line and position it there
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 0),
                      constraints: const BoxConstraints(),

                      iconSize: iconSize,
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
          BlocProvider(
            create: (context) => TapPositionStateCubit(),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final currentItem = items
                    .where((item) => item.itemName.isNotEmpty)
                    .elementAt(index);
                return GestureDetector(
                  onLongPress: () async {
                    final tapPosition = context
                        .read<TapPositionStateCubit>()
                        .getTapStartPosition();
                    if (tapPosition != null) {
                      final overlay =
                          Overlay.of(context).context.findRenderObject();
                      if (overlay != null) {
                        final screenSize = overlay.semanticBounds.size;
                        showItemLongTapActionMenu(
                                context, tapPosition, screenSize)
                            .then((action) => _onItemLongTapActionSelected(
                                action,
                                context,
                                currentItem,
                                tapPosition,
                                screenSize));
                      }
                    }
                  },
                  onTapDown: (details) => context
                      .read<TapPositionStateCubit>()
                      .updateTapPosition(details.globalPosition),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: paddingBetweenListItems),
                    child: Row(
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
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              iconSize: iconSize,
                              onPressed: () {
                                _onItemChecked(context, currentItem);
                              },
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.lightBlue,
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
              // Here we are handling the placeholder item - the builder method won't be called for it
              itemCount: items.where((item) => item.itemName.isNotEmpty).length,
              shrinkWrap: true,
            ),
          ),
          const Divider(
            color: Colors.blueAccent,
            height: 0,
            indent: 16,
            endIndent: 16,
            thickness: 0.0,
          )
        ],
      ),
    );
  }
}
