import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_state.dart';
import 'package:shopping_list_frontend/shopping_item_category.dart';

class ShoppingItemList extends StatelessWidget {
  const ShoppingItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemListState>(
      builder: (context, state) => ListView.builder(
        shrinkWrap: true,
        itemCount: state.items.entries.length,
        itemBuilder: (context, index) {
          final currentItem = state.items.entries.elementAt(index);
          return ShoppingItemCategory(
              categoryName: currentItem.key, items: currentItem.value);
        },
      ),
    );
  }
}
