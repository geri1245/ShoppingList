import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/controls/autocomplete_box/autocomplete_box.dart';
import 'package:shopping_list_frontend/data/itemList/events.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/data/itemList/state.dart';
import 'package:shopping_list_frontend/shopping_item_list.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => ItemListBloc()..add(UpdateAllItemsEvent()),
      child: BlocListener<ItemListBloc, ItemListState>(
        listenWhen: (previous, current) => current.status != ItemListStatus.ok,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
              SnackBar(content: Text(statusToErrorMessage(state.status))));
        },
        child: BlocBuilder<ItemListBloc, ItemListState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const ItemAutoComplete(),
              Expanded(
                child: ShoppingItemList(items: state.items),
              )
            ],
          ),
        ),
      ),
    );
  }
}
