import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_state.dart';
import 'package:shopping_list_frontend/shopping_list.dart';
import 'package:shopping_list_frontend/data/itemList/events.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => ItemListBloc()..add(UpdateAllItemsEvent()),
      child: BlocListener<ItemListBloc, ItemListState>(
        listenWhen: (previous, current) => current.status != ItemListStatus.ok,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          final currentView = View.of(context);
          final viewInsets = EdgeInsets.fromViewPadding(
              currentView.viewInsets, currentView.devicePixelRatio);
          messenger.showSnackBar(SnackBar(
              content: Padding(
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            child: Text(statusToErrorMessage(state.status)),
          )));
        },
        child: BlocBuilder<ItemListBloc, ItemListState>(
          builder: (context, state) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
                actions: [
                  IconButton(
                    onPressed: () =>
                        context.read<ItemListBloc>().add(UpdateAllItemsEvent()),
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ),
              body: switch (state.status) {
                ItemListStatus.ok => const ShoppingList(),
                // ItemListStatus.loading => null,
                _ => Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => context
                                .read<ItemListBloc>()
                                .add(UpdateAllItemsEvent()),
                            child: const Text("Press to reconnect"),
                          ),
                          Image.asset(
                            "images/loading.gif",
                            height: 150.0,
                            width: 150.0,
                          ),
                        ]),
                  ),
              }),
        ),
      ),
    );
  }
}
