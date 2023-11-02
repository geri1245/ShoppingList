import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/autocomplete_box.dart';
import 'package:shopping_list_frontend/shopping_item.dart';
import 'package:shopping_list_frontend/shopping_item_list.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<ShoppingItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AutocompleteBox((value) => setState(() {
                items.add(ShoppingItem(value, 1));
              })),
          ShoppingItemList(items),
        ],
      ),
    );
  }
}
