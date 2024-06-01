import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/model/item_list_bloc.dart';
import 'package:shopping_list_frontend/data/state/item_list_state.dart';
import 'package:shopping_list_frontend/view/items_list.dart';

class TopicPage extends StatelessWidget {
  const TopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemListState>(
      builder: (context, state) => ListView.builder(
        shrinkWrap: true,
        itemCount: state.items.entries.length,
        itemBuilder: (context, index) {
          final currentItem = state.items.entries.elementAt(index);
          return ItemsList(
              categoryName: currentItem.key, items: currentItem.value);
        },
      ),
    );
  }
}
