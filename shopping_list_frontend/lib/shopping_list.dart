import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/autocomplete_box.dart';
import 'package:shopping_list_frontend/http_requests.dart';
import 'package:shopping_list_frontend/shopping_item.dart';
import 'package:shopping_list_frontend/shopping_item_list.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<ShoppingItem> _items = [];

  void setItems(List<ShoppingItem> items) {
    setState(() {
      _items = items;
    });
  }

  @override
  void initState() {
    super.initState();
    final futureItems = fetchItems();
    futureItems.then((response) {
      if (response.isOk()) {
        setItems(response.data!);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Connection error 😢")));
      }
    }, onError: (error) {});
  }

  void _onItemChecked(String itemName) {
    setState(() {
      _items.removeWhere((shoppingItem) => shoppingItem.itemName == itemName);
    });

    removeItem(ShoppingItem(itemName: itemName, count: 0));
  }

  void _onItemAdded(String name, int quantity) {
    var itemToAdd = ShoppingItem(itemName: name, count: quantity);
    setState(() {
      _items.add(itemToAdd);
    });

    addItem(itemToAdd);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AutocompleteBox(_onItemAdded),
          ShoppingItemList(_items, _onItemChecked),
        ],
      ),
    );
  }
}
