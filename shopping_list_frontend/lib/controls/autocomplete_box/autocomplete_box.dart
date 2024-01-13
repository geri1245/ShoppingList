import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/controls/autocomplete_box/raw_autocomplete.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/auto_complete_box_cubit.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/autocomplete_state.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_state.dart';

class ItemAutoComplete extends StatelessWidget {
  const ItemAutoComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemListState>(
      builder: (context, state) => BlocProvider(
        lazy: false,
        create: (context) =>
            AutoCompleteBoxCubit(state.categories, state.itemsSeen),
        child: BlocBuilder<AutoCompleteBoxCubit, ItemAutoCompleteBoxState>(
          builder: (context, state) {
            return AutocompleteBox(
              selectedCategory: state.category ?? "",
              selectedQuantity: state.quantity,
            );
          },
        ),
      ),
    );
  }
}
