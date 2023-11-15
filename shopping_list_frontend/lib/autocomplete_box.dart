import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class AutocompleteBox extends StatefulWidget {
  const AutocompleteBox(this._onItemSelectedFunction, {super.key});

  final void Function(String, int)? _onItemSelectedFunction;

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

  final FocusNode _focusNode = FocusNode();
  late TextEditingController _textEditingController;
  int _quantityToAdd = 1;

  void _onItemSelected(String selection) {
    widget._onItemSelectedFunction!(selection, _quantityToAdd);
    _textEditingController.clear();
    _focusNode.requestFocus();
    _quantityToAdd = 1;
  }

  void _onCurrentTextAdded() {
    if (_textEditingController.text.isNotEmpty) {
      _onItemSelected(_textEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
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
                  _onCurrentTextAdded();
                },
              ),
            ),
            NumberPicker(
              value: _quantityToAdd,
              minValue: 1,
              maxValue: 10,
              itemHeight: 20,
              selectedTextStyle: const TextStyle(fontSize: 16),
              textStyle: const TextStyle(fontSize: 8),
              onChanged: (value) => setState(() => _quantityToAdd = value),
            ),
            IconButton(
                onPressed: _onCurrentTextAdded,
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.lightBlue,
                ))
          ]),
        );
      },
      onSelected: _onItemSelected,
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
    );
  }
}
