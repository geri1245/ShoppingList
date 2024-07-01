import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shopping_list_frontend/model/blocs/adding_items_control_cubit.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/state/adding_items_control_state.dart';
import 'package:shopping_list_frontend/view/autocomplete_box.dart';
import 'package:shopping_list_frontend/view/item_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StreamSubscription<bool> keyboardSubscription;
  bool keyboardHasJustClosed = false;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        setState(() => keyboardHasJustClosed = true);
      }
    });
  }

  Future<void> _onPagePullRefreshed(BuildContext context) {
    return context.read<ItemListBloc>().updateAlItems();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onPagePullRefreshed(context),
      child: BlocProvider(
        create: (context) => AddingItemsControlCubit(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<AddingItemsControlCubit, AddingItemsControlState>(
              builder: (BuildContext context, state) {
                // Show the keyboard when we start adding items to a category
                // If the keyboard is dismissed, then we set keyboardHasJustClosed,
                // so we can dismiss the AutocompleteBox when the user dismisses the keyboard
                if (state.activeCategory != null && !keyboardHasJustClosed) {
                  return AutocompleteBox(
                      autocompleteEntries: context
                          .read<ItemListBloc>()
                          .getItemsSeenForCategory(state.activeCategory!));
                } else {
                  keyboardHasJustClosed = false;
                  context.read<AddingItemsControlCubit>().stopAddingItems();
                  return const SizedBox.shrink();
                }
              },
            ),
            const Expanded(
              child: ItemTab(),
            )
          ],
        ),
      ),
    );
  }
}
