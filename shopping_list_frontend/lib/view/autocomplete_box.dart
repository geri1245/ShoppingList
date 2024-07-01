import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/local_app_state_cubit.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/model/state/local_app_state.dart';
import 'package:shopping_list_frontend/view/number_input.dart';

class AutocompleteBox extends StatefulWidget {
  const AutocompleteBox({required this.autocompleteEntries, super.key});

  final List<String> autocompleteEntries;

  @override
  State<StatefulWidget> createState() {
    return AutocompleteBoxState();
  }
}

class AutocompleteBoxState extends State<AutocompleteBox> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  void _onItemSelected(BuildContext context, String selection) {
    final stateCubit = context.read<LocalAppStateCubit>();
    context.read<ItemListBloc>().add(ItemAddedEvent(
          ShoppingItem(
              category: stateCubit.getState().activeCategory!,
              itemName: selection.trim(),
              count: stateCubit.getState().numberToAdd),
        ));
    _textEditingController.clear();
    _focusNode.requestFocus();
    stateCubit.updateQuantity(1);
  }

  void _onCurrentTextAdded(BuildContext context) {
    if (_textEditingController.text.isNotEmpty) {
      _onItemSelected(context, _textEditingController.text);
    }
  }

  void _onPopInvoked(bool didPop) {
    if (!didPop) {
      context.read<LocalAppStateCubit>().stopAddingItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: _onPopInvoked,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                flex: 7,
                child: BlocBuilder<LocalAppStateCubit, LocalAppState>(
                  builder: (context, state) => Autocomplete(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '' ||
                          state.activeCategory == "") {
                        return const Iterable<String>.empty();
                      }

                      // First search for those items, where the match is at the beginning, those should come first
                      // Then we append the matches that are somewhere in the middle/end of the words
                      final stringToSearchFor =
                          textEditingValue.text.toLowerCase();
                      final matchesBeginning = widget.autocompleteEntries
                          .where((String stringToSearchIn) {
                        return stringToSearchIn.startsWith(stringToSearchFor);
                      });
                      final matchesElsewhere = widget.autocompleteEntries
                          .where((String stringToSearchIn) {
                        return stringToSearchIn.contains(stringToSearchFor) &&
                            !stringToSearchIn.startsWith(stringToSearchFor);
                      });

                      return matchesBeginning.followedBy(matchesElsewhere);
                    },
                    fieldViewBuilder: (context, textEditingController,
                        focusNode, onFieldSubmitted) {
                      _textEditingController = textEditingController;
                      _focusNode = focusNode;
                      _focusNode.requestFocus();

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
              BlocBuilder<LocalAppStateCubit, LocalAppState>(
                builder: (BuildContext context, state) {
                  return Expanded(
                      flex: 4,
                      child: NumberInput(currentValue: state.numberToAdd));
                },
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4)),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () {
                    context.read<LocalAppStateCubit>().stopAddingItems();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.greenAccent,
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
