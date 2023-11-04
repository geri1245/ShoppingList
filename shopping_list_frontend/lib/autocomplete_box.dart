import 'package:flutter/material.dart';

class AutocompleteBox extends StatefulWidget {
  const AutocompleteBox(this._onItemSelectedFunction, {super.key});

  final void Function(String)? _onItemSelectedFunction;

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

  void _onItemSelected(String selection) {
    widget._onItemSelectedFunction!(selection);
    _textEditingController.clear();
    _focusNode.requestFocus();
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
                focusNode: focusNode,
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  if (textEditingController.text.isNotEmpty) {
                    _onItemSelected(textEditingController.text);
                  }
                },
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
