import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/view/autocomplete_box.dart';

Future<T?> showModalBottomInputBox<T>(BuildContext context,
    List<String> autocompleteEntries, ItemAddedFunction itemAddedFunction) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 80,
          child: Center(
              child: AutocompleteBox(
            autocompleteEntries: autocompleteEntries,
            itemAddedFunction: (addedItem, quantity) {
              if (addedItem.isEmpty) {
                Navigator.pop(context);
              } else {
                itemAddedFunction(addedItem, quantity);
              }
            },
            dismissedFunction: () => Navigator.pop(context),
          )),
        ),
      );
    },
  );
}
