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
  static const List<String> _kOptions = <String>[
    'alma',
    'barack',
    'dinnye',
    'korte',
    'kifli',
  ];

  static const List<String> _categories = <String>[
    'Default',
    'Shopping',
  ];

  final FocusNode _focusNode = FocusNode();
  late TextEditingController _textEditingController;

  void _onItemSelected(BuildContext context, String selection) {
    final cubit = context.read<AutoCompleteBoxCubit>();
    context.read<ItemListBloc>().add(ItemAddedEvent(
          ShoppingItem(
              category: cubit.category,
              itemName: selection,
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Column(children: [
        RawAutocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _kOptions.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            _textEditingController = textEditingController;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    focusNode: _focusNode,
                    onFieldSubmitted: (String value) {
                      _onCurrentTextAdded(context);
                    },
                  ),
                ),
                BlocBuilder<AutoCompleteBoxCubit, ItemAutoCompleteBoxState>(
                  builder: (context, state) => CategoryDropdownButton(
                    categories: _categories,
                    selectedCategory: state.category,
                  ),
                ),
                IconButton(
                    onPressed: () => _onCurrentTextAdded(context),
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.lightBlue,
                    ))
              ]),
            );
          },
          onSelected: (selectedItem) => _onItemSelected(context, selectedItem),
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        NumberPicker(
          axis: Axis.horizontal,
          value: context.read<AutoCompleteBoxCubit>().quantity,
          minValue: 1,
          maxValue: 10,
          itemHeight: 20,
          selectedTextStyle: const TextStyle(fontSize: 16),
          textStyle: const TextStyle(fontSize: 8),
          onChanged: (value) =>
              context.read<AutoCompleteBoxCubit>().setQuantity(value),
        ),
      ]),
    );
  }
}
