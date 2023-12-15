import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/auto_complete_box_cubit.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/autocomplete_state.dart';
import 'package:shopping_list_frontend/data/itemList/events.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/dropdown_button.dart';

class AutocompleteBox extends StatefulWidget {
  const AutocompleteBox(
      {required this.selectedCategory,
      required this.selectedQuantity,
      super.key});

  final String selectedCategory;
  final int selectedQuantity;

  @override
  State<StatefulWidget> createState() {
    return AutocompleteBoxState();
  }
}

class AutocompleteBoxState extends State<AutocompleteBox> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  void _onItemSelected(BuildContext context, String selection) {
    final cubit = context.read<AutoCompleteBoxCubit>();
    context.read<ItemListBloc>().add(ItemAddedEvent(
          ShoppingItem(
              category: cubit.category,
              itemName: selection.trim(),
              count: cubit.quantity),
        ));
    _textEditingController.clear();
    _focusNode.requestFocus();
    cubit.setQuantity(1);
  }

  void _onCurrentTextAdded(BuildContext context) {
    if (_textEditingController.text.isNotEmpty) {
      _onItemSelected(context, _textEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              flex: 12,
              child:
                  BlocBuilder<AutoCompleteBoxCubit, ItemAutoCompleteBoxState>(
                builder: (context, state) => Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '' ||
                        state.category == "" ||
                        !state.itemsSeen.containsKey(state.category)) {
                      return const Iterable<String>.empty();
                    }

                    return state.itemsSeen[state.category]!
                        .where((String option) {
                      return option
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    _textEditingController = textEditingController;
                    _focusNode = focusNode;

                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onFieldSubmitted: (String value) {
                        _onCurrentTextAdded(context);
                      },
                    );
                  },
                  onSelected: (selectedItem) =>
                      _onItemSelected(context, selectedItem),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child:
                  BlocBuilder<AutoCompleteBoxCubit, ItemAutoCompleteBoxState>(
                builder: (context, state) => CategoryDropdownButton(
                  categories: state.categories,
                  selectedCategory: state.category,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: NumberPicker(
                axis: Axis.vertical,
                value: context.read<AutoCompleteBoxCubit>().quantity,
                minValue: 1,
                maxValue: 10,
                itemHeight: 20,
                selectedTextStyle: const TextStyle(fontSize: 16),
                textStyle: const TextStyle(fontSize: 8),
                onChanged: (value) =>
                    context.read<AutoCompleteBoxCubit>().setQuantity(value),
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () => _onCurrentTextAdded(context),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.lightBlue,
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
