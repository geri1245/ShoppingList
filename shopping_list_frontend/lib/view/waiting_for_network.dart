import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';

class WaitingForNetwork extends StatelessWidget {
  const WaitingForNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
          onPressed: () =>
              context.read<ItemListBloc>().add(UpdateAllItemsEvent()),
          child: const Text("Press to reconnect"),
        ),
        Image.asset(
          "images/loading.gif",
          height: 150.0,
          width: 150.0,
        ),
      ]),
    );
  }
}
