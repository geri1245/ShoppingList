import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/auto_complete_box_cubit.dart';
import 'package:shopping_list_frontend/delete_popup_entry.dart';
import 'package:shopping_list_frontend/text_input_dialog.dart';

const String addNewItemString = "New category...";

class CategoryDropdownButton extends StatefulWidget {
  const CategoryDropdownButton(
      {required this.categories, required this.selectedCategory, super.key});

  final List<String> categories;
  final String? selectedCategory;

  @override
  State<CategoryDropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<CategoryDropdownButton> {
  late GlobalKey _dropdownKey;

  @override
  void initState() {
    super.initState();

    _dropdownKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    var dropdownOptions = [...widget.categories, addNewItemString]
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: GestureDetector(
          child: Text(value),
          onLongPress: () => showMenu(
            context: context,
            position: const RelativeRect.fromLTRB(2, 2, 2, 2),
            items: [const DeletePopupEntry()],
          ).then((shouldRemove) {
            if (shouldRemove != null && shouldRemove == true) {
              context.read<AutoCompleteBoxCubit>().removeCategory(value);
              Navigator.pop(_dropdownKey.currentContext!);
            }
          }),
        ),
      );
    }).toList();

    final defaultSelectedCategory = widget.selectedCategory ?? addNewItemString;

    return DropdownButton<String>(
      key: _dropdownKey,
      padding: const EdgeInsets.all(4),
      isExpanded: true,
      value: defaultSelectedCategory,
      elevation: 16,
      dropdownColor: Colors.white,
      focusColor: Colors.white,
      style: const TextStyle(
          color: Colors.deepPurple, overflow: TextOverflow.ellipsis),
      onChanged: (String? selectedItem) {
        if (selectedItem == addNewItemString) {
          getTextInputWithDialog(context).then((String? newCategoryName) {
            if (newCategoryName != null) {
              context.read<AutoCompleteBoxCubit>().addCategory(newCategoryName);
            }
          });
        } else if (selectedItem != null) {
          context.read<AutoCompleteBoxCubit>().setCategory(selectedItem);
        }
      },
      items: dropdownOptions,
    );
  }
}
