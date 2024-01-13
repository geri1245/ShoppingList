import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/controls/autocomplete_box/autocomplete_box.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_bloc.dart';
import 'package:shopping_list_frontend/shopping_item_list.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Future<void> _onPagePullRefreshed(BuildContext context) {
    return context.read<ItemListBloc>().updateAlItemsAsync();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onPagePullRefreshed(context),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ItemAutoComplete(),
          Expanded(
            child: ShoppingItemList(),
          )
        ],
      ),
    );
  }
}
