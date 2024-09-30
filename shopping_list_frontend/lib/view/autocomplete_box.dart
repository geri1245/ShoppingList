import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/view/autocomplete_options.dart';
import 'package:shopping_list_frontend/view/number_input.dart';

typedef ItemAddedFunction = void Function(String addedItem, int quantity);
typedef DismissedFunction = void Function();

class AutocompleteBox extends StatefulWidget {
  const AutocompleteBox(
      {required this.autocompleteEntries,
      required this.itemAddedFunction,
      required this.dismissedFunction,
      super.key});

  final List<String> autocompleteEntries;
  final ItemAddedFunction itemAddedFunction;
  final DismissedFunction dismissedFunction;

  @override
  State<StatefulWidget> createState() {
    return AutocompleteBoxState();
  }
}

class AutocompleteBoxState extends State<AutocompleteBox> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  int numberToAdd = 1;

  void _onItemSelected(BuildContext context, String selection) {
    widget.itemAddedFunction(selection, numberToAdd);

    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  void _onCurrentTextAdded(BuildContext context) {
    if (_textEditingController.text.isEmpty) {
      widget.dismissedFunction();
    } else {
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
              flex: 7,
              child: Autocomplete(
                optionsViewOpenDirection: OptionsViewOpenDirection.up,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }

                  // First search for those items, where the match is at the beginning, those should come first
                  // Then we append the matches that are somewhere in the middle/end of the words
                  final stringToSearchFor = textEditingValue.text.toLowerCase();
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
                optionsViewBuilder: (context, onSelected, options) {
                  return AutocompleteOptions(
                    displayStringForOption: (option) => option,
                    maxOptionsHeight: 200,
                    onSelected: onSelected,
                    openDirection: OptionsViewOpenDirection.up,
                    options: options,
                  );
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  _textEditingController = textEditingController;
                  _focusNode = focusNode;
                  _focusNode.requestFocus();

                  return Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            _onCurrentTextAdded(context);
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete_forever)),
                    ],
                  );
                },
                onSelected: (selectedItem) =>
                    _onItemSelected(context, selectedItem),
              ),
            ),
            Expanded(
                flex: 4,
                child: NumberInput(
                  onNumberChanged: (number) => numberToAdd = number,
                )),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4)),
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () {
                  widget.dismissedFunction();
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
    );
  }
}
