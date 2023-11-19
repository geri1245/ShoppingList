import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/autocomplete_box.dart';
import 'package:shopping_list_frontend/http_requests.dart';
import 'package:shopping_list_frontend/item_list_cubit.dart';
import 'package:shopping_list_frontend/shopping_item.dart';
import 'package:shopping_list_frontend/shopping_item_list.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  ItemCategoryMap _items = {};

  void setItems(ItemCategoryMap items) {
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

  void _onItemChecked(ShoppingItem item) {
    setState(() {
      if (_items.containsKey(item.category)) {
        _items[item.category]?.remove(item);
      }
    });

    removeItem(
        ShoppingItem(category: "default", itemName: item.itemName, count: 0));
  }

  void _onItemAdded(ShoppingItem itemToAdd) {
    setState(() {
      addToMap(_items, itemToAdd);
    });

    addItem(itemToAdd);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AutocompleteBox(_onItemAdded),
        ShoppingItemList(items: _items, onItemCheckedFunction: _onItemChecked)
      ],
    );
  }
}
