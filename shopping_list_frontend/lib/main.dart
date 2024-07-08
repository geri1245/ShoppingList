import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/state/item_list_state.dart';
import 'package:shopping_list_frontend/view/main_page.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/view/waiting_for_network.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
            ),
          ));
        },
        child: BlocBuilder<ItemListBloc, ItemListState>(
          buildWhen: (previous, current) =>
              previous.status != current.status &&
              current.status != ItemListStatus.networkError,
          builder: (context, state) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: switch (state.status) {
                ItemListStatus.networkError => const WaitingForNetwork(),
                _ => MainPage(items: state.items),
              }),
        ),
      ),
    );
  }
}
